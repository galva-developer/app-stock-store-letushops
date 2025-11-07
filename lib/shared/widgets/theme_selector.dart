import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Widget para seleccionar el modo de tema de la aplicación
///
/// Muestra opciones para:
/// - Modo Claro
/// - Modo Oscuro
/// - Automático (Sistema)
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción: Modo Claro
            RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.light_mode, color: Colors.orange),
                  SizedBox(width: 12),
                  Text('Modo Claro'),
                ],
              ),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),

            // Opción: Modo Oscuro
            RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.dark_mode, color: Colors.indigo),
                  SizedBox(width: 12),
                  Text('Modo Oscuro'),
                ],
              ),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),

            // Opción: Automático (Sistema)
            RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.brightness_auto, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Automático (Sistema)'),
                ],
              ),
              subtitle: const Text('Usar la configuración del sistema'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Diálogo para cambiar el tema de la aplicación
class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ThemeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.palette, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          const Text('Seleccionar Tema'),
        ],
      ),
      content: const ThemeSelector(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

/// Botón para cambiar el tema (toggle simple)
class ThemeToggleButton extends StatelessWidget {
  final bool showLabel;

  const ThemeToggleButton({super.key, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        if (showLabel) {
          return TextButton.icon(
            icon: Icon(themeProvider.themeIcon),
            label: Text(themeProvider.themeName),
            onPressed: () => themeProvider.toggleTheme(),
          );
        }

        return IconButton(
          icon: Icon(themeProvider.themeIcon),
          onPressed: () => themeProvider.toggleTheme(),
          tooltip: themeProvider.themeName,
        );
      },
    );
  }
}

/// Switch para alternar entre modo claro y oscuro
class ThemeSwitch extends StatelessWidget {
  final String? label;

  const ThemeSwitch({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.themeMode == ThemeMode.dark;

        return SwitchListTile(
          title: Text(label ?? 'Modo Oscuro'),
          secondary: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            color: isDark ? Colors.indigo : Colors.orange,
          ),
          value: isDark,
          onChanged: (value) {
            if (value) {
              themeProvider.setDarkMode();
            } else {
              themeProvider.setLightMode();
            }
          },
        );
      },
    );
  }
}

/// ListTile para abrir el diálogo de selección de tema
class ThemeSettingsTile extends StatelessWidget {
  const ThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          leading: Icon(
            themeProvider.themeIcon,
            color: Theme.of(context).primaryColor,
          ),
          title: const Text('Apariencia'),
          subtitle: Text(themeProvider.themeName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ThemeDialog.show(context),
        );
      },
    );
  }
}
