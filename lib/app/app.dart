import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/theme.dart';
import '../shared/util.dart';
import '../data/repositories/game_repository_impl.dart';
import '../domain/usecases/guess_number_usecase.dart';
import '../domain/usecases/start_game_usecase.dart';
import '../presentation/viewmodels/game_viewmodel.dart';
import '../presentation/views/game_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Average", "Alkalami");
    MaterialTheme theme = MaterialTheme(textTheme);

    // Instantiate clean architecture dependencies
    final repository = GameRepositoryImpl();
    final startGameUseCase = StartGameUseCase(repository);
    final guessNumberUseCase = GuessNumberUseCase();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameViewModel(
            startGameUseCase: startGameUseCase,
            guessNumberUseCase: guessNumberUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Número Mágico',
        debugShowCheckedModeBanner: false,
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: const GameScreen(),
      ),
    );
  }
}
