enum GameStatus { playing, won, lost }

class GuessResult {
  final int guessedNumber;
  final String feedback;
  final bool isCorrect;
  final bool isTooHigh;

  const GuessResult({
    required this.guessedNumber,
    required this.feedback,
    required this.isCorrect,
    required this.isTooHigh,
  });
}

class GameState {
  final int secretNumber;
  final int remainingAttempts;
  final GameStatus status;
  final String message;

  const GameState({
    required this.secretNumber,
    required this.remainingAttempts,
    required this.status,
    required this.message,
  });

  factory GameState.initial(int secretNumber) {
    return GameState(
      secretNumber: secretNumber,
      remainingAttempts: 3,
      status: GameStatus.playing,
      message: '¡Adivina el número secreto entre 1 y 50!',
    );
  }

  GameState copyWith({
    int? secretNumber,
    int? remainingAttempts,
    GameStatus? status,
    String? message,
  }) {
    return GameState(
      secretNumber: secretNumber ?? this.secretNumber,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}