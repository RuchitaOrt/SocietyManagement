import 'package:flutter/material.dart';

class CommonOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final IconData? icon;

  const CommonOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = const Color(0xFFE9EAF2),
    this.textColor = const Color(0xFF17264B),
    this.height = 48,
    this.borderRadius = 9,
    this.fontSize = 14,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, height),
        foregroundColor: textColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: icon == null
          ? Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}