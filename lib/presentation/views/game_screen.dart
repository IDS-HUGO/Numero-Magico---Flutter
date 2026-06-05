import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_viewmodel.dart';
import '../../domain/entities/game_state.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitGuess(GameViewModel vm) {
    if (_controller.text.isEmpty) return;
    vm.makeGuess(_controller.text);
    _controller.clear();
    if (!vm.isGameOver) _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Número Mágico'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<GameViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Vidas/Corazones ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i < vm.remainingAttempts;
                      return Icon(
                        active ? Icons.favorite : Icons.favorite_border,
                        color: active ? Colors.red : theme.colorScheme.outline,
                        size: 32,
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 24),

                  // ── Tarjeta de Estado del Juego ────────────────────
                  Card(
                    elevation: 0,
                    color: vm.isGameOver 
                        ? (vm.status == GameStatus.won ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1))
                        : theme.colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Indicador central (Número o signo de pregunta)
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.surface,
                            child: vm.isGameOver
                                ? Text(
                                    '${vm.secretNumber}',
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: vm.status == GameStatus.won ? Colors.green : Colors.red,
                                    ),
                                  )
                                : Icon(Icons.help_outline, size: 40, color: theme.colorScheme.primary),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Text(
                            vm.message,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            vm.isGameOver
                                ? (vm.status == GameStatus.won ? '¡Ganaste! 🎉' : 'Juego Terminado 😢')
                                : 'Adivina el número del 1 al 50',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Controles (Input y Botones) ────────────────────
                  if (!vm.isGameOver) ...[
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: InputDecoration(
                        hintText: 'Introduce tu número',
                        errorText: vm.validationError,
                        border: const OutlineInputBorder(),
                        counterText: '',
                      ),
                      onSubmitted: (_) => _submitGuess(vm),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    FilledButton(
                      onPressed: () => _submitGuess(vm),
                      child: const Text('Adivinar'),
                    ),
                  ] else ...[
                    FilledButton.icon(
                      onPressed: () {
                        vm.startGame();
                        _controller.clear();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Jugar de nuevo'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}