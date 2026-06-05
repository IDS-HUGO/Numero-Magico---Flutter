import '../entities/game_state.dart';

class GuessNumberUseCase {
  GameState call(GameState currentState, int guess) {
    if (currentState.status != GameStatus.playing) {
      return currentState;
    }

    final isCorrect = guess == currentState.secretNumber;
    final isTooHigh = guess > currentState.secretNumber;
    final newRemainingAttempts = currentState.remainingAttempts - 1;

    String message;
    GameStatus newStatus = currentState.status;

    if (isCorrect) {
      message = '¡Felicidades! Adivinaste el número secreto: ${currentState.secretNumber}.';
      newStatus = GameStatus.won;
    } else if (newRemainingAttempts <= 0) {
      message = '¡Has agotado tus intentos! El número secreto era ${currentState.secretNumber}.';
      newStatus = GameStatus.lost;
    } else {
      final feedback = isTooHigh ? 'demasiado alto' : 'demasiado bajo';
      message = 'Tu número es $feedback. Te quedan $newRemainingAttempts intento${newRemainingAttempts == 1 ? '' : 's'}.';
    }

    return currentState.copyWith(
      remainingAttempts: newRemainingAttempts,
      status: newStatus,
      message: message,
    );
  }
}