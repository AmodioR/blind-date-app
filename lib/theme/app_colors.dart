import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds (varmere end din nuværende)
  static const bg = Color(0xFFF6F1FF);        // warm lavender
  static const bgSoft = Color(0xFFFDF8FF);    // næsten hvid, men varm

  // Surfaces (cards)
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFF8F3FF); // varm “tinted surface”

  // Brand
  static const primary = Color(0xFFED4DC1);   // brand primary
  static const primaryDeep = Color(0xFF55339A); // lidt dybere/varmere

  // Wingman
  static const wingmanGoldSoft = Color(0xFFC9A24D);

  // Warm accent (til små highlights – ikke overalt)
  static const accent = Color(0xFFFFC6A8);    // soft peach
  static const accentDeep = Color(0xFFFFA97E);

  // Lines / text
  static const border = Color(0xFFE7DDF7);    // lidt varmere end E6E0F2
  static const textSoft = Color(0xFF3A3347);  // varm mørk (i stedet for sort)
  static const textMuted = Color(0xFF6E647F); // varm grå/lilla

  static const premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF6D8),
      Color(0xFFFFD5A6),
      Color(0xFFFFC4DA),
      Color(0xFFD9C8FF),
    ],
  );
}
