import '../entities/game_state.dart';

class GuessNumberUseCase {
  GameState call(GameState currentState, int guess) {
    if (currentState.status != GameStatus.playing) {
      return currentState;
    }

    final isCorrect = guess == currentState.secretNumber;
    final isTooHigh = guess > currentState.secretNumber;
    final newRemainingAttempts = currentState.remainingAttempts - 1;

    String feedback;
    String message;
    GameStatus newStatus = currentState.status;

    if (isCorrect) {
      feedback = '¡Correcto!';
      message = '¡Felicidades! Adivinaste el número secreto: ${currentState.secretNumber}.';
      newStatus = GameStatus.won;
    } else if (newRemainingAttempts <= 0) {
      feedback = isTooHigh ? 'Demasiado alto' : 'Demasiado bajo';
      message = '¡Has agotado tus intentos! El número secreto era ${currentState.secretNumber}.';
      newStatus = GameStatus.lost;
    } else {
      feedback = isTooHigh ? 'Demasiado alto' : 'Demasiado bajo';
      message = '¡Intento incorrecto! El número es $feedback.';
    }

    final guessResult = GuessResult(
      guessedNumber: guess,
      feedback: feedback,
      isCorrect: isCorrect,
      isTooHigh: isTooHigh,
    );

    final updatedGuesses = List<GuessResult>.from(currentState.previousGuesses)..add(guessResult);

    return currentState.copyWith(
      remainingAttempts: newRemainingAttempts,
      previousGuesses: updatedGuesses,
      status: newStatus,
      message: message,
    );
  }
}
