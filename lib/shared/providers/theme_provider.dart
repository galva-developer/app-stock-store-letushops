import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gestionar el tema (modo claro/oscuro) de la aplicación
///
/// Características:
/// ✅ Persistencia del tema seleccionado
/// ✅ Cambio dinámico entre modo claro y oscuro
/// ✅ Respeta la configuración del sistema por defecto
/// ✅ Notifica cambios a la UI automáticamente
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  /// Getter para el modo de tema actual
  ThemeMode get themeMode => _themeMode;

  /// Getter para verificar si está en modo oscuro
  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // Si es system, devolver false por defecto (se puede mejorar detectando el sistema)
    return false;
  }

  /// Getter para verificar si está inicializado
  bool get isInitialized => _isInitialized;

  /// Constructor
  ThemeProvider() {
    _loadThemeMode();
  }

  /// Carga el tema guardado desde SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themeKey);

      if (savedThemeIndex != null) {
        _themeMode = ThemeMode.values[savedThemeIndex];
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error cargando tema: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Cambia el modo de tema
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
      debugPrint('✅ Tema guardado: ${mode.name}');
    } catch (e) {
      debugPrint('❌ Error guardando tema: $e');
    }
  }

  /// Alterna entre modo claro y oscuro
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Cambia a modo claro
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Cambia a modo oscuro
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Usar el tema del sistema
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Obtiene el nombre legible del tema actual
  String get themeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Modo Claro';
      case ThemeMode.dark:
        return 'Modo Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  /// Obtiene el icono del tema actual
  IconData get themeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
