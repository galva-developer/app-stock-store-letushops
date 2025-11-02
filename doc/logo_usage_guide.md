# Guía de Uso del Logo - Stock LetuShops

## Ubicación de los Assets

Los logos de la aplicación se encuentran en:
```
assets/images/logo/
├── logo-transparente.png  (Logo con fondo transparente)
└── logo-blanco.png        (Logo en blanco para fondos oscuros)
```

## Configuración en pubspec.yaml

Los assets ya están configurados en `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/logo/logo-transparente.png
    - assets/images/logo/logo-blanco.png
```

## Widget AppLogo

Se ha creado un widget reutilizable para facilitar el uso del logo en toda la aplicación.

**Ubicación:** `lib/shared/widgets/app_logo.dart`

### Uso Básico

```dart
import 'package:stock_letu_shops/shared/widgets/app_logo.dart';

// Logo estándar
AppLogo()

// Logo con tamaño personalizado
AppLogo(
  width: 100,
  height: 100,
)
```

### Constructores Especializados

#### 1. Logo Circular
```dart
AppLogo.circular(
  width: 80,
  height: 80,
  type: LogoType.transparent,
)
```
Útil para: Headers, avatares, iconos redondos

#### 2. Logo Simple
```dart
AppLogo.simple(
  width: 40,
  height: 40,
)
```
Útil para: Íconos pequeños, sin decoración

### Parámetros Disponibles

| Parámetro | Tipo | Valor por defecto | Descripción |
|-----------|------|-------------------|-------------|
| `type` | `LogoType` | `LogoType.transparent` | Tipo de logo (transparent/white) |
| `width` | `double` | `80` | Ancho del contenedor |
| `height` | `double` | `80` | Alto del contenedor |
| `withShadow` | `bool` | `true` | Si debe mostrar sombra |
| `backgroundColor` | `Color?` | `null` (blanco) | Color de fondo |
| `borderRadius` | `double` | `12` | Radio de las esquinas |
| `padding` | `double` | `12` | Padding interno |

### Tipos de Logo

```dart
enum LogoType {
  transparent,  // Logo con fondo transparente (por defecto)
  white,        // Logo en blanco para fondos oscuros
}
```

## Ejemplos de Implementación

### En Splash Screen
```dart
AppLogo(
  width: 140,
  height: 140,
  borderRadius: 24,
  padding: 20,
  withShadow: true,
)
```

### En Login/Register
```dart
AppLogo.circular(
  width: 100,
  height: 100,
  type: LogoType.transparent,
)
```

### En Navigation Drawer
```dart
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  padding: const EdgeInsets.all(6),
  child: Image.asset(
    'assets/images/logo/logo-transparente.png',
    fit: BoxFit.contain,
  ),
)
```

### En Home Page (Tarjeta de Bienvenida)
```dart
Container(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  padding: const EdgeInsets.all(8),
  child: Image.asset(
    'assets/images/logo/logo-transparente.png',
    fit: BoxFit.contain,
  ),
)
```

## Dónde se Usa el Logo

### ✅ Implementado

- **Splash Screen** (`lib/config/routes/app_routes.dart`)
  - Logo prominente con sombra
  - Tamaño: 140x140
  
- **Login Page** (`lib/features/authentication/presentation/pages/login_page.dart`)
  - Logo circular en header
  - Tamaño: 100x100

- **Register Page** (`lib/features/authentication/presentation/pages/register_page.dart`)
  - Logo circular en header
  - Tamaño: 90x90

- **Forgot Password Page** (`lib/features/authentication/presentation/pages/forgot_password_page.dart`)
  - Logo condicional (logo normal o ícono de éxito)
  - Tamaño: 90x90

- **Home Page** (`lib/features/home/presentation/pages/home_page.dart`)
  - Logo en tarjeta de bienvenida
  - Tamaño: 56x56

- **Navigation Drawer** (`lib/features/home/presentation/pages/main_layout.dart`)
  - Logo en header del drawer (desktop)
  - Tamaño: 48x48

## Mejores Prácticas

### 1. Uso de Logo Transparente vs Blanco

**Logo Transparente:**
- ✅ Fondos claros
- ✅ Tarjetas blancas
- ✅ Contenedores con fondo blanco

**Logo Blanco:**
- ✅ Fondos oscuros
- ✅ Splash screens con color primario
- ✅ Navigation bars oscuras

### 2. Tamaños Recomendados

| Contexto | Tamaño Recomendado |
|----------|-------------------|
| Splash Screen | 120-160px |
| Login/Register Header | 80-100px |
| Navigation Drawer | 40-60px |
| AppBar | 32-40px |
| Cards | 40-56px |
| Avatares pequeños | 24-32px |

### 3. Sombras

- ✅ Usar sombras en fondos blancos o claros
- ❌ Evitar sombras en fondos oscuros
- ✅ Sombras sutiles (opacity 0.1-0.2)

### 4. Padding

- Logo pequeño (< 50px): padding 4-8px
- Logo mediano (50-100px): padding 8-16px
- Logo grande (> 100px): padding 16-24px

## Mantenimiento

### Actualizar el Logo

1. Coloca los nuevos archivos en `assets/images/logo/`
2. Mantén los nombres:
   - `logo-transparente.png`
   - `logo-blanco.png`
3. Ejecuta `flutter pub get`
4. Hot restart la aplicación

### Agregar Variantes

Si necesitas agregar más variantes (ej: logo-dark.png):

1. Agrega el archivo en `assets/images/logo/`
2. Actualiza `pubspec.yaml`:
```yaml
assets:
  - assets/images/logo/logo-dark.png
```
3. Actualiza el enum `LogoType` en `app_logo.dart`:
```dart
enum LogoType {
  transparent,
  white,
  dark,  // Nueva variante
}
```
4. Actualiza el switch en el widget para manejar el nuevo tipo

## Formato Recomendado de Imágenes

- **Formato:** PNG con transparencia
- **Resolución:** Al menos 512x512px para calidad
- **Tamaño de archivo:** < 100KB
- **Color mode:** RGBA

## Troubleshooting

### El logo no se muestra

1. Verifica que los assets estén en `pubspec.yaml`
2. Ejecuta `flutter clean` y `flutter pub get`
3. Verifica la ruta del asset
4. Hot restart (no hot reload)

### El logo se ve pixelado

- Usa imágenes de mayor resolución
- Asegúrate de usar `fit: BoxFit.contain`
- Verifica que el tamaño del contenedor sea apropiado

### El logo tiene bordes blancos

- Verifica que el PNG tenga transparencia real
- Usa `logo-transparente.png` en lugar de `logo-blanco.png`
- Revisa el backgroundColor del Container

## Recursos Adicionales

- [Flutter Assets Documentation](https://docs.flutter.dev/ui/assets/assets-and-images)
- [Image Widget Documentation](https://api.flutter.dev/flutter/widgets/Image-class.html)
- [BoxFit Values](https://api.flutter.dev/flutter/painting/BoxFit.html)
