# Deep Linking Configuration

## Descripción General

El deep linking permite que la aplicación Stock LetuShops se abra desde enlaces externos, ya sea desde navegadores web, otras aplicaciones, correos electrónicos, notificaciones push, etc.

## Tipos de Deep Links Implementados

### 1. Custom URL Scheme
**Esquema:** `stockletushops://`

Este tipo de deep link funciona en todas las versiones de Android e iOS, pero requiere que el usuario tenga la aplicación instalada.

**Ejemplos de uso:**
```
stockletushops://home
stockletushops://products
stockletushops://camera
stockletushops://inventory
stockletushops://reports
stockletushops://profile
```

### 2. Universal Links (iOS) / App Links (Android)
**Dominio:** `https://letushops.com`

Este tipo de deep link funciona con URLs HTTPS normales. Si la aplicación está instalada, se abre directamente; si no, puede redirigir al navegador.

**Ejemplos de uso:**
```
https://letushops.com/home
https://letushops.com/products
https://letushops.com/camera
https://letushops.com/inventory
https://letushops.com/reports
https://letushops.com/profile
```

## Configuración por Plataforma

### Android

**Archivo:** `android/app/src/main/AndroidManifest.xml`

Se han agregado dos `intent-filter` al `MainActivity`:

1. **App Links (HTTPS):**
   - Permite abrir la app desde URLs HTTPS
   - Requiere verificación del dominio (`android:autoVerify="true"`)
   - Para producción, necesitarás configurar el archivo `assetlinks.json` en tu servidor

2. **Custom URL Scheme:**
   - Permite abrir la app con el esquema `stockletushops://`
   - No requiere verificación de dominio

### iOS

**Archivo:** `ios/Runner/Info.plist`

Se han agregado dos configuraciones:

1. **CFBundleURLTypes (Custom URL Scheme):**
   - Permite abrir la app con el esquema `stockletushops://`
   - Funciona inmediatamente sin configuración adicional

2. **Associated Domains (Universal Links):**
   - Permite abrir la app desde URLs HTTPS de `letushops.com`
   - Requiere configurar el archivo `apple-app-site-association` en tu servidor
   - También necesita habilitar la capacidad "Associated Domains" en Xcode

## Cómo Funciona con GoRouter

GoRouter maneja automáticamente los deep links gracias a su configuración. Las rutas definidas en `app_routes.dart` ya están preparadas para recibir navegación desde deep links:

```dart
// Estas rutas responden automáticamente a deep links
/home
/products
/camera
/inventory
/reports
/profile
/settings
```

## Probar Deep Links

### Android

**Usando ADB:**
```bash
# Custom URL Scheme
adb shell am start -W -a android.intent.action.VIEW -d "stockletushops://products"

# App Link (HTTPS)
adb shell am start -W -a android.intent.action.VIEW -d "https://letushops.com/products"
```

**Usando Chrome DevTools (para emuladores):**
1. Abre Chrome DevTools
2. Ve a la consola
3. Ejecuta: `window.location = "stockletushops://products"`

### iOS

**Usando Terminal (con simulador en ejecución):**
```bash
# Custom URL Scheme
xcrun simctl openurl booted "stockletushops://products"

# Universal Link
xcrun simctl openurl booted "https://letushops.com/products"
```

**Usando Safari en el dispositivo:**
1. Abre Safari
2. Escribe en la barra de direcciones: `stockletushops://products`
3. Presiona Enter

## Configuración Adicional para Producción

### Para App Links (Android)

Necesitarás crear un archivo `assetlinks.json` en tu servidor:

**Ubicación:** `https://letushops.com/.well-known/assetlinks.json`

**Contenido:**
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.letushops.stock_letu_shops",
    "sha256_cert_fingerprints": [
      "XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX"
    ]
  }
}]
```

Para obtener el SHA256 fingerprint:
```bash
keytool -list -v -keystore your-keystore.jks
```

### Para Universal Links (iOS)

Necesitarás crear un archivo `apple-app-site-association` en tu servidor:

**Ubicación:** `https://letushops.com/.well-known/apple-app-site-association`

**Contenido:**
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.letushops.stockLetushops",
        "paths": ["*"]
      }
    ]
  }
}
```

**Nota:** El archivo debe servirse con el tipo de contenido `application/json` y sin extensión de archivo.

## Manejo de Autenticación

El sistema de rutas ya incluye un `RouteGuard` que protege las rutas que requieren autenticación. Cuando un usuario intenta acceder a una ruta protegida mediante deep link:

1. Si está autenticado → se navega directamente a la ruta
2. Si no está autenticado → se redirige a `/login`

## Ejemplos de Uso en Marketing

### Notificaciones Push
```
"Nuevo producto agregado! Ver ahora"
→ stockletushops://products
```

### Emails
```html
<a href="https://letushops.com/inventory">Ver tu inventario</a>
```

### Redes Sociales
```
¡Gestiona tu inventario fácilmente!
👉 https://letushops.com/home
```

### QR Codes
Puedes generar códigos QR que apunten a:
- `stockletushops://camera` (abrir cámara directamente)
- `https://letushops.com/products` (ver productos)

## Solución de Problemas

### Android

**Problema:** Los App Links no abren la app
- Verifica que el archivo `assetlinks.json` esté accesible
- Verifica el SHA256 fingerprint
- Limpia los datos de la app y reinstala

**Comando para verificar:**
```bash
adb shell pm get-app-links com.letushops.stock_letu_shops
```

### iOS

**Problema:** Los Universal Links no funcionan
- Verifica que el archivo `apple-app-site-association` esté accesible
- Verifica que "Associated Domains" esté habilitado en Xcode
- Los Universal Links no funcionan si pegas el link directamente en Safari (debes hacer clic en el link desde otra app)

## Referencias

- [GoRouter Deep Linking](https://pub.dev/documentation/go_router/latest/topics/Deep%20linking-topic.html)
- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
