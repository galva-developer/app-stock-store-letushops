# 🌓 Guía Rápida: Modo Oscuro

## 🚀 Uso Básico

### Cambiar Tema desde la UI

**Opción 1: Botón en AppBar (ya implementado)**
```dart
// El botón ya está en:
// - home_page.dart
// - admin_users_page.dart

// Simplemente haz clic en el ícono ☀️/🌙 en el AppBar
```

**Opción 2: Diálogo de Selección**
```dart
import 'package:stock_letu_shops/shared/widgets/theme_selector.dart';

// Mostrar diálogo
ThemeDialog.show(context);
```

**Opción 3: Switch en Configuración**
```dart
import 'package:stock_letu_shops/shared/widgets/theme_selector.dart';

ThemeSwitch(label: 'Modo Oscuro')
```

---

## 💻 Uso Programático

### Cambiar Tema

```dart
import 'package:provider/provider.dart';
import 'package:stock_letu_shops/shared/providers/theme_provider.dart';

// Modo Oscuro
context.read<ThemeProvider>().setDarkMode();

// Modo Claro
context.read<ThemeProvider>().setLightMode();

// Automático (Sistema)
context.read<ThemeProvider>().setSystemMode();

// Toggle (alternar)
context.read<ThemeProvider>().toggleTheme();
```

### Leer Tema Actual

```dart
final themeProvider = context.watch<ThemeProvider>();

// Obtener modo actual
ThemeMode currentMode = themeProvider.themeMode;

// Verificar si está oscuro
bool isDark = themeProvider.isDarkMode;

// Nombre legible
String name = themeProvider.themeName; // "Modo Oscuro"

// Ícono
IconData icon = themeProvider.themeIcon; // Icons.dark_mode
```

---

## 🎨 Widgets Disponibles

### 1. ThemeToggleButton
```dart
import 'package:stock_letu_shops/shared/widgets/theme_selector.dart';

// En AppBar
AppBar(
  actions: [
    ThemeToggleButton(), // Sin label
  ],
)

// Con label
ThemeToggleButton(showLabel: true)
```

### 2. ThemeDialog
```dart
// Mostrar diálogo completo
ElevatedButton(
  onPressed: () => ThemeDialog.show(context),
  child: Text('Cambiar Tema'),
)
```

### 3. ThemeSwitch
```dart
// Switch simple
ThemeSwitch(label: 'Modo Oscuro')
```

### 4. ThemeSettingsTile
```dart
// Para página de configuración
ListView(
  children: [
    ThemeSettingsTile(), // Abre diálogo al tocar
  ],
)
```

### 5. ThemeSelector
```dart
// Selector de radio buttons
ThemeSelector()
```

---

## 📁 Archivos Creados

```
lib/
├── shared/
│   ├── providers/
│   │   └── theme_provider.dart         ✅ Provider del tema
│   └── widgets/
│       └── theme_selector.dart         ✅ Widgets de UI
└── main.dart                            ✅ Integración

Documentación:
├── DARK_MODE_DOCUMENTATION.md          ✅ Documentación completa
├── CHANGELOG.md                         ✅ Actualizado
└── README.md                            ✅ Actualizado
```

---

## ✅ Páginas con Modo Oscuro

- ✅ `home_page.dart` - Botón en AppBar
- ✅ `admin_users_page.dart` - Botón en AppBar
- ✅ `login_page.dart` - Tema automático
- ✅ Todas las demás páginas - Tema automático

---

## 🔧 Personalizar Tema Oscuro

**Ubicación:** `lib/config/themes/theme_extensions.dart`

```dart
static ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFFF5252), // Cambiar color principal
      surface: Color(0xFF1E1E1E),  // Cambiar fondo
      // ... más colores
    ),
  );
}
```

---

## 🐛 Troubleshooting

### El tema no persiste
```bash
# Verificar que shared_preferences esté instalado
flutter pub get
```

### El tema no cambia
```dart
// Usar Consumer, no read()
Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return /* widget */;
  },
)
```

### AppBar no cambia de color
```dart
// Usar Theme.of(context), no colores hardcodeados
AppBar(
  backgroundColor: Theme.of(context).primaryColor, // ✅
  // backgroundColor: Color(0xFFD32F2F),           // ❌
)
```

---

## 📚 Documentación Completa

Ver `DARK_MODE_DOCUMENTATION.md` para:
- ✅ Arquitectura detallada
- ✅ Todos los componentes
- ✅ Ejemplos de código
- ✅ Tests
- ✅ Troubleshooting completo

---

**© 2025 Letu Shops - Stock Management System**
