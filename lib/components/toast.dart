import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shows a toast message that automatically disappears after a duration
void showToast(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
  ToastType type = ToastType.info,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Toast(
      message: message,
      type: type,
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

enum ToastType {
  success,
  error,
  info,
  warning,
}

class Toast extends StatelessWidget {
  final String message;
  final ToastType type;

  const Toast({
    super.key,
    required this.message,
    this.type = ToastType.info,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: const Alignment(0, -0.7),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _getBackgroundColor().withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIcon(),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 200.ms)
          .slideY(
            begin: -0.2,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeOutCubic,
          )
          .then()
          .fadeOut(
            delay: 1800.ms,
            duration: 200.ms,
          ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return Colors.green.shade700;
      case ToastType.error:
        return Colors.red.shade700;
      case ToastType.warning:
        return Colors.orange.shade700;
      case ToastType.info:
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
      default:
        return Icons.info_outline;
    }
  }
}
