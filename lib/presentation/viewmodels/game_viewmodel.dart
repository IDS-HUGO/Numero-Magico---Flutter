import 'package:flutter/foundation.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/guess_number_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';

class GameViewModel extends ChangeNotifier {
  final StartGameUseCase startGameUseCase;
  final GuessNumberUseCase guessNumberUseCase;

  late GameState _state;
  String? _validationError;

  GameViewModel({
    required this.startGameUseCase,
    required this.guessNumberUseCase,
  }) {
    startGame();
  }

  // Getters
  GameState get state => _state;
  int get secretNumber => _state.secretNumber;
  int get remainingAttempts => _state.remainingAttempts;
  List<GuessResult> get previousGuesses => _state.previousGuesses;
  GameStatus get status => _state.status;
  String get message => _state.message;
  String? get validationError => _validationError;

  bool get isGameOver => _state.status != GameStatus.playing;

  // Actions
  void startGame() {
    _state = startGameUseCase();
    _validationError = null;
    notifyListeners();
  }

  void makeGuess(String input) {
    if (isGameOver) return;

    _validationError = null;

    final guess = int.tryParse(input.trim());
    if (guess == null) {
      _validationError = 'Por favor ingresa un número válido.';
      notifyListeners();
      return;
    }

    if (guess < 1 || guess > 50) {
      _validationError = 'El número debe estar entre 1 y 50.';
      notifyListeners();
      return;
    }

    // Process guess
    _state = guessNumberUseCase(_state, guess);
    notifyListeners();
  }
}
