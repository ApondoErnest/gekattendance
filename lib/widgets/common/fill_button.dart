import 'package:flutter/material.dart';

class MyFillButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? minWidth; // New parameter for minimum width
  final double height;
  final VoidCallback onPressed;
  final bool isDisabled;
  final TextStyle? textStyle;
  final Color? backgroundColor; // New parameter for background color

  const MyFillButton(
    this.text, {
    this.width,
    this.minWidth, // Initialize minWidth parameter
    required this.height,
    required this.onPressed,
    this.isDisabled = false,
    this.textStyle,
    this.backgroundColor, // Initialize backgroundColor parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0, // Set minimum width here
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? (backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.5)
                : backgroundColor ?? Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: !isDisabled
              ? onPressed
              : () {}, // Use null instead of empty function for proper disabled state
          child: Text(
            text,
            style:
                textStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
