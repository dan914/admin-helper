import 'package:flutter/material.dart';

class DesignTokens {
  static const Map<String, dynamic> tokens = {
    'color.primary': 0xFF2C61C1,
    'color.primaryHover': 0xFF244FA2,
    'color.secondary': 0xFF5AD2CC,
    'color.textDefault': 0xFF333333,
    'color.textMuted': 0xFF696969,
    'color.bgDefault': 0xFFFAFAFA,
    'color.bgAlt': 0xFFFFFFFF,
    'color.border': 0xFFE5E8EC,
    'color.danger': 0xFFE53E3E,
    'radius.card': 16.0,
    'radius.button': 8.0,
    'spacing.base': 16.0,
    'spacing.small': 8.0,
    'spacing.section': 24.0,
    'font.caption': 16.0,
    'font.body': 20.0,
    'font.heading': 28.0,
    'font.display': 34.0,
  };

  static Color get primary => Color(tokens['color.primary'] as int);
  static Color get primaryHover => Color(tokens['color.primaryHover'] as int);
  static Color get secondary => Color(tokens['color.secondary'] as int);
  static Color get textDefault => Color(tokens['color.textDefault'] as int);
  static Color get textMuted => Color(tokens['color.textMuted'] as int);
  static Color get bgDefault => Color(tokens['color.bgDefault'] as int);
  static Color get bgAlt => Color(tokens['color.bgAlt'] as int);
  static Color get border => Color(tokens['color.border'] as int);
  static Color get danger => Color(tokens['color.danger'] as int);

  static double get radiusCard => tokens['radius.card'] as double;
  static double get radiusButton => tokens['radius.button'] as double;
  static double get spacingBase => tokens['spacing.base'] as double;
  static double get spacingSmall => tokens['spacing.small'] as double;
  static double get spacingSection => tokens['spacing.section'] as double;

  static double get fontCaption => tokens['font.caption'] as double;
  static double get fontBody => tokens['font.body'] as double;
  static double get fontHeading => tokens['font.heading'] as double;
  static double get fontDisplay => tokens['font.display'] as double;
}