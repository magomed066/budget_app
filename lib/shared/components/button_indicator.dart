import 'package:flutter/material.dart';

class ButtonIndicator extends StatelessWidget {
  const ButtonIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
    );
  }
}
