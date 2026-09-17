import 'dart:async';

import 'package:budget_app/app/theme/auth_colors.dart';
import 'package:flutter/material.dart';

/// Mount [builder] on MaterialApp, then show messages from any screen.
class Toaster {
  Toaster._();

  static final _message = ValueNotifier<_ToastMessage?>(null);
  static Timer? _timer;

  static void error(String message) {
    show(message, backgroundColor: AuthColors.error);
  }

  static void success(String message) {
    show(message, backgroundColor: Colors.green.shade700);
  }

  static void warning(String message) {
    show(message, backgroundColor: Colors.orange.shade700);
  }

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = const Color(0xFF323232),
  }) {
    if (message.trim().isEmpty) return;

    _timer?.cancel();
    _message.value = _ToastMessage(message.trim(), backgroundColor);
    _timer = Timer(duration, dismiss);
  }

  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _message.value = null;
  }

  /// Places the toast above the Navigator, including dialogs and routes.
  static Widget builder(BuildContext context, Widget? child) {
    return ValueListenableBuilder<_ToastMessage?>(
      valueListenable: _message,
      child: child ?? const SizedBox.shrink(),
      builder: (context, message, child) {
        final mediaQuery = MediaQuery.of(context);

        return Stack(
          fit: StackFit.expand,
          children: [
            child!,
            if (message != null)
              Positioned(
                left: 24,
                right: 24,
                bottom:
                    mediaQuery.viewInsets.bottom +
                    mediaQuery.padding.bottom +
                    24,
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Semantics(
                        liveRegion: true,
                        child: Material(
                          color: message.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Text(
                              message.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ToastMessage {
  const _ToastMessage(this.text, this.backgroundColor);

  final String text;
  final Color backgroundColor;
}
