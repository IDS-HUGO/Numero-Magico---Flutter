import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

class StartGameUseCase {
  final GameRepository _repository;

  StartGameUseCase(this._repository);

  GameState call() {
    final secretNumber = _repository.generateRandomNumber(1, 50);
    return GameState.initial(secretNumber);
  }
}
