import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String labelText;
  final Widget child;
  final double height;

  const TextLabel({
    super.key,
    required this.labelText,
    required this.child,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: height),
        child,
      ],
    );
  }
}
