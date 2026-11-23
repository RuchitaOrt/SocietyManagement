import 'package:flutter/material.dart';
import 'package:society_management/core/constants/AppFonts.dart';
import 'package:society_management/core/constants/AppTextSizes.dart';
import '../constants/app_colors.dart';


class CommonText extends StatelessWidget {
  const CommonText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.requiredMark = false,
  });

  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) {
    final style = AppFonts.regular.copyWith(
      fontSize: fontSize ?? AppTextSizes.bodyMedium,
      color: color ?? AppColors.navy,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: height,
      letterSpacing: letterSpacing,
    );

    if (requiredMark) {
      return RichText(
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
        text: TextSpan(
          style: style,
          children: [
            TextSpan(text: text),
            TextSpan(
              text: ' *',
              style: style.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      );
    }

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }
}