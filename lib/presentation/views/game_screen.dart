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

  void _submitGuess(GameViewModel viewModel) {
    if (_controller.text.isNotEmpty) {
      viewModel.makeGuess(_controller.text);
      _controller.clear();
      // Keep keyboard open and focused for rapid playing
      if (!viewModel.isGameOver) {
        _focusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        // Determine theme colors depending on status
        Color cardColor;
        Color onCardColor;
        IconData statusIcon;

        if (viewModel.status == GameStatus.won) {
          cardColor = colorScheme.tertiaryContainer;
          onCardColor = colorScheme.onTertiaryContainer;
          statusIcon = Icons.emoji_events;
        } else if (viewModel.status == GameStatus.lost) {
          cardColor = colorScheme.errorContainer;
          onCardColor = colorScheme.onErrorContainer;
          statusIcon = Icons.sentiment_very_dissatisfied;
        } else {
          cardColor = colorScheme.surfaceContainerHigh;
          onCardColor = colorScheme.onSurface;
          statusIcon = Icons.help_outline;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'El Número Mágico',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Alkalami',
              ),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                height: 1.0,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // Remaining attempts (Hearts)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          viewModel.isGameOver
                              ? 'Juego Terminado'
                              : 'Intentos restantes: ${viewModel.remainingAttempts}',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final isActive = index < viewModel.remainingAttempts;
                            return AnimatedScale(
                              scale: isActive ? 1.0 : 0.8,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.elasticOut,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  isActive ? Icons.favorite : Icons.favorite_border,
                                  color: isActive ? Colors.redAccent : colorScheme.outline.withValues(alpha: 0.5),
                                  size: 36,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Main game card
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: viewModel.isGameOver 
                            ? cardColor 
                            : colorScheme.primary.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Secret number display (animated)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Container(
                            key: ValueKey<String>('${viewModel.isGameOver}'),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: viewModel.isGameOver
                                ? Text(
                                    '${viewModel.secretNumber}',
                                    style: textTheme.displayLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: viewModel.status == GameStatus.won
                                          ? colorScheme.tertiary
                                          : colorScheme.error,
                                      fontFamily: 'Alkalami',
                                    ),
                                  )
                                : Icon(
                                    statusIcon,
                                    size: 56,
                                    color: colorScheme.primary,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Message / Feedback text
                        Text(
                          viewModel.message,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onCardColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          viewModel.isGameOver
                              ? (viewModel.status == GameStatus.won 
                                  ? '¡Excelente deducción!' 
                                  : '¡Suerte para la próxima!')
                              : 'Piensa en un número del 1 al 50.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: onCardColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Input box & Action buttons
                  if (!viewModel.isGameOver) ...[
                    // Input TextField
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Average',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLength: 2,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Introduce tu número',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        errorText: viewModel.validationError,
                        errorMaxLines: 2,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorScheme.error, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                      ),
                      onSubmitted: (_) => _submitGuess(viewModel),
                    ),

                    const SizedBox(height: 16),

                    // Submit Guess Button
                    ElevatedButton.icon(
                      onPressed: () => _submitGuess(viewModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.send_rounded),
                      label: Text(
                        'Adivinar',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Play Again Button (Shown only when game is over)
                    ElevatedButton.icon(
                      onPressed: () {
                        viewModel.startGame();
                        _controller.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        'Jugar de nuevo',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Attempts History Title
                  Row(
                    children: [
                      Icon(Icons.history_toggle_off, color: colorScheme.outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Historial de intentos',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  const SizedBox(height: 8),

                  // History List
                  if (viewModel.previousGuesses.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Aún no has realizado ningún intento.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.previousGuesses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        // Show in reverse order (latest first)
                        final reversedIndex = viewModel.previousGuesses.length - 1 - index;
                        final guess = viewModel.previousGuesses[reversedIndex];

                        Color badgeColor;
                        Color onBadgeColor;
                        IconData leadingIcon;

                        if (guess.isCorrect) {
                          badgeColor = colorScheme.tertiaryContainer;
                          onBadgeColor = colorScheme.onTertiaryContainer;
                          leadingIcon = Icons.check_circle;
                        } else if (guess.isTooHigh) {
                          badgeColor = colorScheme.primaryContainer;
                          onBadgeColor = colorScheme.onPrimaryContainer;
                          leadingIcon = Icons.arrow_upward;
                        } else {
                          badgeColor = colorScheme.secondaryContainer;
                          onBadgeColor = colorScheme.onSecondaryContainer;
                          leadingIcon = Icons.arrow_downward;
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: badgeColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${guess.guessedNumber}',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: onBadgeColor,
                                  fontFamily: 'Average',
                                ),
                              ),
                            ),
                            title: Text(
                              'Intento #${reversedIndex + 1}',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              guess.feedback,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Icon(
                              leadingIcon,
                              color: onBadgeColor,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
