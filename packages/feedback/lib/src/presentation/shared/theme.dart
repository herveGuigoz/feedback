import 'package:flutter/material.dart';

/// {@template feedback_theme_data}
/// The theme of the feedback layouts
/// {@endtemplate}
class FeedbackThemeData {
  /// {@macro feedback_theme_data}
  const FeedbackThemeData({
    this.primaryColor = const Color.fromRGBO(79, 119, 255, 1),
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xff343a40),
    this.border = const BorderSide(color: Color.fromRGBO(229, 234, 240, 1)),
  });

  /// The primary color of the theme
  final Color primaryColor;

  /// The background color of the theme
  final Color backgroundColor;

  /// The foreground color of the theme
  final Color foregroundColor;

  /// The border of the theme
  final BorderSide border;

  /// The material theme used by the feedback components.
  ThemeData get material {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(primary: primaryColor),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          side: border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        hintStyle: TextStyle(
          color: Color(0xffadb5bd),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 18,
          foregroundColor: foregroundColor,
          side: border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      useMaterial3: true,
    );
  }
}

/// {@template feedback_theme}
/// Provide the [FeedbackThemeData] to the widget tree
/// {@endtemplate}
class FeedbackTheme extends InheritedTheme {
  /// {@macro feedback_theme}
  const FeedbackTheme({required this.data, required super.child, super.key});

  /// The theme data
  final FeedbackThemeData data;

  /// Get the nearest [FeedbackThemeData] from the [BuildContext]
  static FeedbackThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<FeedbackTheme>();
    assert(theme != null, 'No FeedbackTheme found in context');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(FeedbackTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final theme = context.findAncestorWidgetOfExactType<FeedbackTheme>();
    return identical(this, theme) ? child : FeedbackTheme(data: data, child: child);
  }
}
