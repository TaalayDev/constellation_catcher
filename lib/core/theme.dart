import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game_theme.dart';

class AppTheme {
  static const defaultType = GameTheme.deepSpace;
  static final defaultTheme = AppTheme.fromType(defaultType);

  ThemeConfig get themeConfig => ThemeConfig.forTheme(type);

  late GameTheme type;
  bool isDark;

  late Color primaryColor;
  late Color onPrimaryColor;

  late Color bgColor;
  late Color secondaryColor;
  late Color errorColor;
  late Color surfaceColor;
  late Color greyColor;

  late Color iconColor;
  late Color textColor;
  late Color inverseTextColor;

  // This colors is not dependent on theme type for now
  Color inactiveColor = const Color(0xffF2F1F9);
  Color secondaryTextColor = const Color(0xFF343434);
  Color inputBorderColor = const Color(0xffCBCBCB);

  AppTheme({this.isDark = false}) {
    textColor = isDark ? Colors.white : const Color(0xff000000);
    inverseTextColor = isDark ? const Color(0xff000000) : Colors.white;
    iconColor = isDark ? Colors.white : const Color(0xff545454);
  }

  factory AppTheme.fromType(GameTheme type) {
    final themeConfig = ThemeConfig.forTheme(type);
    switch (type) {
      case GameTheme.classic:
        return AppTheme(isDark: true)
          ..type = type
          ..primaryColor = const Color(0xFF4A90E2)
          ..onPrimaryColor = const Color(0xffFFFFFF)
          ..bgColor = themeConfig.backgroundColor
          ..secondaryColor = const Color(0xffD7D5D5)
          ..errorColor = const Color(0xffd70015)
          ..surfaceColor = const Color(0xffFFFFFF);

      case GameTheme.nebula:
        return AppTheme(isDark: true)
          ..type = type
          ..primaryColor = const Color(0xFF4A90E2)
          ..onPrimaryColor = const Color(0xffFFFFFF)
          ..bgColor = const Color(0xff1A1A1A)
          ..secondaryColor = const Color(0xff2D2D2D)
          ..errorColor = const Color(0xffd70015)
          ..surfaceColor = const Color(0xff2D2D2D);

      case GameTheme.aurora:
        return AppTheme(isDark: true)
          ..type = type
          ..primaryColor = const Color(0xFF4A90E2)
          ..onPrimaryColor = const Color(0xffFFFFFF)
          ..bgColor = themeConfig.backgroundColor
          ..secondaryColor = const Color(0xff2D2D2D)
          ..errorColor = const Color(0xffd70015)
          ..surfaceColor = const Color(0xff2D2D2D);

      case GameTheme.deepSpace:
        return AppTheme(isDark: true)
          ..type = type
          ..primaryColor = const Color(0xFF4A90E2)
          ..onPrimaryColor = const Color(0xffFFFFFF)
          ..bgColor = themeConfig.backgroundColor
          ..secondaryColor = const Color(0xff2D2D2D)
          ..errorColor = const Color(0xffd70015)
          ..surfaceColor = const Color(0xff2D2D2D);
    }
  }

  ThemeData get themeData {
    var t = ThemeData();

    return t.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.interTextTheme(t.textTheme.apply(
        displayColor: textColor,
        bodyColor: textColor,
      )),
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: inverseTextColor,
        error: errorColor,
        onError: textColor,
        background: bgColor,
        onBackground: textColor,
        surface: surfaceColor,
        onSurface: textColor,
      ),
      iconTheme: IconThemeData(color: iconColor),
      dividerColor: inputBorderColor,
      dividerTheme: DividerThemeData(
        color: inputBorderColor,
        thickness: 1,
        space: 0,
      ),
    );
  }

  Color shift(Color c, double amount) {
    amount *= (isDark ? -1 : 1);

    /// Convert to HSL
    var hslc = HSLColor.fromColor(c);

    /// Add/Remove lightness
    double lightness = (hslc.lightness + amount).clamp(0, 1.0).toDouble();

    /// Convert back to Color
    return hslc.withLightness(lightness).toColor();
  }
}
