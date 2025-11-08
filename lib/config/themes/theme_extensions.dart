import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/responsive_constants.dart';

/// 🎨 EXTENSIONES DEL TEMA - FUNCIONALIDADES ADICIONALES
/// Contiene tema oscuro, tipografías responsivas y utilities
class ThemeExtensions {
  // 🌙 TEMA OSCURO
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: ColorConstants.primaryColor, // Mismo rojo que tema claro
        onPrimary: ColorConstants.textOnPrimaryColor, // Texto blanco
        primaryContainer: ColorConstants.red100,
        onPrimaryContainer: ColorConstants.red900,

        secondary: ColorConstants.secondaryColor, // Mismo rojo brillante
        onSecondary: ColorConstants.textOnPrimaryColor, // Texto blanco
        secondaryContainer: ColorConstants.red50,
        onSecondaryContainer: ColorConstants.red800,

        tertiary: ColorConstants.grey600,
        onTertiary: ColorConstants.surfaceColor,
        tertiaryContainer: ColorConstants.grey700,
        onTertiaryContainer: ColorConstants.grey100,

        surface: ColorConstants.grey900,
        onSurface: ColorConstants.grey100,
        surfaceContainerHighest: ColorConstants.grey800,
        onSurfaceVariant: ColorConstants.grey300,

        error: ColorConstants.errorColor, // Mismo rojo error que tema claro
        onError: ColorConstants.textOnPrimaryColor,
        errorContainer: ColorConstants.red900,
        onErrorContainer: ColorConstants.red100,

        outline: ColorConstants.grey700,
        outlineVariant: ColorConstants.grey800,
        shadow: ColorConstants.shadowColor,
        scrim: ColorConstants.overlayColor,
        inverseSurface: ColorConstants.grey100,
        onInverseSurface: ColorConstants.grey900,
        inversePrimary: ColorConstants.primaryColor,
      ),

      textTheme: buildTextTheme(Brightness.dark),

      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.primaryColor, // Rojo como tema claro
        foregroundColor: ColorConstants.textOnPrimaryColor, // Texto blanco
        elevation: DimensionConstants.elevationMedium,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ColorConstants.textOnPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: ColorConstants.textOnPrimaryColor,
          size: DimensionConstants.iconSize,
        ),
        actionsIconTheme: IconThemeData(
          color: ColorConstants.textOnPrimaryColor,
          size: DimensionConstants.iconSize,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              ColorConstants.primaryColor, // Mismo rojo que tema claro
          foregroundColor: ColorConstants.textOnPrimaryColor, // Texto blanco
          disabledBackgroundColor: ColorConstants.grey600,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          elevation: DimensionConstants.elevationMedium,
          shadowColor: ColorConstants.shadowColor,
          surfaceTintColor: ColorConstants.primaryLightColor,
          minimumSize: const Size(
            DimensionConstants.buttonWidth,
            DimensionConstants.buttonHeight,
          ),
          maximumSize: const Size(
            double.infinity,
            DimensionConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingLarge,
            vertical: DimensionConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.radiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorConstants.primaryColor,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          side: const BorderSide(
            color: ColorConstants.primaryColor,
            width: 1.5,
          ),
          minimumSize: const Size(
            DimensionConstants.buttonWidth,
            DimensionConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingLarge,
            vertical: DimensionConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.radiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorConstants.primaryColor,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          minimumSize: const Size(0, DimensionConstants.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingMedium,
            vertical: DimensionConstants.paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionConstants.radiusSmall),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
        elevation: DimensionConstants.elevationMedium,
        focusElevation: DimensionConstants.elevationHigh,
        hoverElevation: DimensionConstants.elevationHigh,
        splashColor: ColorConstants.primaryLightColor,
        shape: CircleBorder(),
      ),

      cardTheme: CardTheme(
        color: ColorConstants.grey800,
        elevation: DimensionConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
        margin: const EdgeInsets.all(DimensionConstants.marginSmall),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.grey800,
        contentPadding: const EdgeInsets.all(DimensionConstants.paddingMedium),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.primaryColor, // Mismo rojo que tema claro
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.errorColor,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey700),
        ),

        labelStyle: const TextStyle(
          color: ColorConstants.grey400,
          fontSize: 16,
        ),
        floatingLabelStyle: TextStyle(
          color: ColorConstants.primaryColor, // Mismo rojo que tema claro
          fontSize: 16,
        ),
        hintStyle: const TextStyle(color: ColorConstants.grey500, fontSize: 16),
        errorStyle: const TextStyle(
          color: ColorConstants.errorColor,
          fontSize: 12,
        ),
        prefixIconColor: ColorConstants.grey500,
        suffixIconColor: ColorConstants.grey500,
      ),

      iconTheme: const IconThemeData(
        color: ColorConstants.grey400,
        size: DimensionConstants.iconSize,
      ),

      dividerTheme: const DividerThemeData(
        color: ColorConstants.grey700,
        thickness: 1,
        space: 1,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.grey800,
        selectedItemColor:
            ColorConstants.primaryColor, // Mismo rojo que tema claro
        unselectedItemColor: ColorConstants.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: DimensionConstants.elevationMedium,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: ColorConstants.grey900,
        elevation: DimensionConstants.elevationHigh,
      ),

      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.grey800,
        elevation: DimensionConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusLarge),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorConstants.grey800,
        elevation: DimensionConstants.elevationHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DimensionConstants.radiusLarge),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: ColorConstants.grey700,
        deleteIconColor: ColorConstants.grey400,
        disabledColor: ColorConstants.grey800,
        selectedColor: ColorConstants.primaryColor, // Mismo rojo que tema claro
        secondarySelectedColor: ColorConstants.primaryLightColor,
        labelStyle: const TextStyle(color: ColorConstants.grey100),
        secondaryLabelStyle: const TextStyle(
          color: ColorConstants.textOnPrimaryColor,
        ),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingSmall,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
      ),

      // Temas adicionales para consistencia
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryColor;
          }
          return ColorConstants.grey500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryLightColor;
          }
          return ColorConstants.grey700;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(ColorConstants.textOnPrimaryColor),
        side: const BorderSide(color: ColorConstants.grey500, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusSmall),
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryColor;
          }
          return ColorConstants.grey500;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorConstants.primaryColor,
        linearTrackColor: ColorConstants.grey700,
        circularTrackColor: ColorConstants.grey700,
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: ColorConstants.primaryColor,
        unselectedLabelColor: ColorConstants.grey400,
        indicatorColor: ColorConstants.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingMedium,
          vertical: DimensionConstants.paddingSmall,
        ),
        minLeadingWidth: 40,
        iconColor: ColorConstants.grey400,
        textColor: ColorConstants.grey100,
        selectedColor: ColorConstants.primaryColor,
        selectedTileColor: ColorConstants.grey800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimensionConstants.radiusSmall),
          ),
        ),
      ),

      splashColor: ColorConstants.primaryLightColor.withOpacity(0.3),
      highlightColor: ColorConstants.primaryLightColor.withOpacity(0.1),
      focusColor: ColorConstants.primaryColor.withOpacity(0.12),
      hoverColor: ColorConstants.primaryColor.withOpacity(0.04),
    );
  }

  // 📝 SISTEMA DE TIPOGRAFÍA RESPONSIVE
  static TextTheme buildTextTheme(Brightness brightness) {
    final Color textColor =
        brightness == Brightness.light
            ? ColorConstants.textPrimaryColor
            : ColorConstants.grey100;
    final Color secondaryTextColor =
        brightness == Brightness.light
            ? ColorConstants.textSecondaryColor
            : ColorConstants.grey400;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }

  // 🎯 MÉTODOS UTILITY PARA TEMAS
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getContrastColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey100
        : ColorConstants.textPrimaryColor;
  }

  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey900
        : ColorConstants.backgroundColor;
  }

  static Color getPrimaryColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.red400
        : ColorConstants.primaryColor;
  }

  static Color getSurfaceColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey800
        : ColorConstants.surfaceColor;
  }

  static Color getCardColor(BuildContext context) {
    return isDarkMode(context) ? ColorConstants.grey800 : Colors.white;
  }

  // 📱 RESPONSIVE HELPERS
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final multiplier =
        ResponsiveConstants.isDesktop(context)
            ? 1.1
            : ResponsiveConstants.isTablet(context)
            ? 1.05
            : 1.0;
    return baseSize * multiplier;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(ResponsiveConstants.getHorizontalMargin(context));
  }

  static double getResponsiveIconSize(BuildContext context) {
    return ResponsiveConstants.isDesktop(context)
        ? DimensionConstants.iconSize * 1.2
        : ResponsiveConstants.isTablet(context)
        ? DimensionConstants.iconSize * 1.1
        : DimensionConstants.iconSize;
  }

  // 🎨 THEME SPECIFIC HELPERS
  static TextStyle getHeadlineStyle(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineMedium!.copyWith(
      fontSize:
          fontSize != null ? getResponsiveFontSize(context, fontSize) : null,
      color: getContrastColor(context),
    );
  }

  static TextStyle getBodyStyle(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      fontSize:
          fontSize != null ? getResponsiveFontSize(context, fontSize) : null,
      color: getContrastColor(context),
    );
  }

  static BoxDecoration getCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: getCardColor(context),
      borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode(context)
                  ? Colors.black26
                  : Colors.grey.withOpacity(0.1),
          blurRadius: DimensionConstants.elevationLow,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static LinearGradient getPrimaryGradient(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.blackToRedGradient
        : ColorConstants.primaryGradient;
  }
}
