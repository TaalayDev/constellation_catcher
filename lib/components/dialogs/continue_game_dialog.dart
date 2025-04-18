import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContinueGameDialog extends StatelessWidget {
  final bool isTimeOut;
  final VoidCallback onWatchAd;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const ContinueGameDialog({
    super.key,
    this.isTimeOut = false,
    required this.onWatchAd,
    required this.onRestart,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with animated warning symbol
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 24,
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .scale(
                        duration: 600.ms,
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        duration: 600.ms,
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(1, 1),
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(width: 8),
                  Text(
                    isTimeOut ? 'Time\'s Up!' : 'Too Many Mistakes!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    isTimeOut
                        ? 'You\'ve run out of time.\nWhat would you like to do?'
                        : 'You\'ve made 3 mistakes.\nWhat would you like to do?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Watch ad button
                  _buildButton(
                    icon: Icons.play_circle_outline,
                    text: 'Watch an Ad to Continue',
                    textColor: Colors.white,
                    backgroundColor: Colors.blue.shade700,
                    onTap: onWatchAd,
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 400.ms),

                  // const SizedBox(height: 12),

                  // Restart button
                  // _buildButton(
                  //   icon: Icons.refresh,
                  //   text: 'Restart Level',
                  //   textColor: Colors.white70,
                  //   backgroundColor: Colors.white.withOpacity(0.1),
                  //   onTap: onRestart,
                  // )
                  //     .animate()
                  //     .fadeIn(delay: 300.ms, duration: 400.ms)
                  //     .slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 12),

                  // Quit button
                  _buildButton(
                    icon: Icons.exit_to_app,
                    text: 'Quit to Menu',
                    textColor: Colors.white70,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    onTap: onQuit,
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
