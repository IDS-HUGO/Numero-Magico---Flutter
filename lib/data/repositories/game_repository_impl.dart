import 'dart:math';
import '../../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final Random _random;

  GameRepositoryImpl({Random? random}) : _random = random ?? Random();

  @override
  int generateRandomNumber(int min, int max) {
    if (min > max) {
      throw ArgumentError('min cannot be greater than max');
    }
    return min + _random.nextInt(max - min + 1);
  }
}
