# ❓ Preguntas Frecuentes (FAQ) - Stock LetuShops

## 🔐 Autenticación y Acceso

### ¿Cómo ingreso por primera vez a la aplicación?

Los usuarios deben ser creados por el administrador desde la **Consola de Firebase**:

1. El administrador crea el usuario en [Firebase Console](https://console.firebase.google.com/)
2. Ve a **Authentication > Users > Add user**
3. Ingresa email y contraseña
4. Comparte las credenciales contigo
5. Usa esas credenciales en la app para iniciar sesión

**Ver:** [ACCESS_GUIDE.md](./ACCESS_GUIDE.md) para más detalles.

> ⚠️ **Nota importante:** No existe opción de auto-registro en la aplicación. 
> Todos los usuarios son creados desde Firebase Console.

---

### ¿Qué credenciales uso para ingresar?

Usa las credenciales que el administrador creó para ti en Firebase Console. Si olvidaste tu contraseña, usa la opción **"Olvidé mi contraseña"** en la pantalla de login.

**Credenciales de prueba sugeridas (creadas en Firebase Console):**
- Email: `admin@letushops.com`
- Password: `Admin123456`

---

### ¿Cómo se crean nuevos usuarios?

Solo el administrador puede crear usuarios desde Firebase Console:

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar el proyecto
3. Ir a **Authentication > Users**
4. Hacer clic en **"Add user"**
5. Ingresar email y contraseña
6. Compartir las credenciales con el nuevo usuario

> **Importante:** No hay opción de auto-registro en la aplicación por seguridad.

---

### ¿Cómo cierro sesión?

1. Ve a la página de **Home**
2. Haz clic en el ícono de **logout** (puerta con flecha) en la AppBar
3. O ve a **Perfil** y haz clic en "Cerrar sesión"

---

## 📱 Uso de la Aplicación

### ¿Cómo agrego un producto?

**Opción 1: Manual (Actual)**
1. Ve a la página de **Productos**
2. Haz clic en el botón **"+ Agregar Producto"**
3. Completa el formulario
4. Guarda

**Opción 2: Con Cámara (En desarrollo)**
1. Ve a la página de **Cámara**
2. Toma una foto del producto
3. La IA extraerá las características automáticamente
4. Revisa y guarda

---

### ¿Qué navegadores/dispositivos son compatibles?

**Móvil:**
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 11.0+

**Escritorio (Desarrollo):**
- ✅ Windows 10+
- ✅ macOS 10.14+
- ✅ Linux (Ubuntu 18.04+)

**Web (Desarrollo):**
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

---

### ¿La app funciona sin internet?

**Actualmente:** ❌ No. Requiere conexión a internet para sincronizar con Firebase.

**Futuro:** ✅ Sí. Se implementará modo offline con sincronización automática.

---

## 🛠️ Desarrollo y Configuración

### ¿Cómo configuro Firebase?

```bash
# 1. Instala Firebase CLI
npm install -g firebase-tools

# 2. Instala FlutterFire CLI
dart pub global activate flutterfire_cli

# 3. Configura el proyecto
flutterfire configure
```

**Ver:** Sección "Configuración de Firebase" en [README.md](./README.md)

---

### ¿Qué hago si aparece "Firebase not configured"?

1. Verifica que existe el archivo `lib/firebase_options.dart`
2. Ejecuta `flutterfire configure`
3. Selecciona tu proyecto de Firebase
4. Ejecuta `flutter clean && flutter pub get`

---

### ¿Cómo actualizo las dependencias?

```bash
# Ver paquetes desactualizados
flutter pub outdated

# Actualizar paquetes
flutter pub upgrade

# Actualizar paquetes mayores (con precaución)
flutter pub upgrade --major-versions
```

---

## 🐛 Problemas Comunes

### Error: "Null check operator used on a null value"

**Causa:** Intentando acceder a datos antes de que estén cargados.

**Solución:**
1. Verifica que Firebase esté inicializado
2. Usa operadores null-safe (`?.`, `??`)
3. Agrega validaciones de null

---

### Error: "Bad state: No element"

**Causa:** Intentando acceder a un elemento que no existe.

**Solución:**
1. Usa `.firstWhere()` con `orElse`
2. Verifica que la colección tenga elementos
3. Agrega manejo de casos vacíos

---

### Error: "A RenderFlex overflowed by X pixels"

**Causa:** Contenido que excede el espacio disponible.

**Solución:**
1. Envuelve en `SingleChildScrollView`
2. Usa `Expanded` o `Flexible`
3. Reduce el contenido o el tamaño de fuente

---

### La app no compila en iOS

**Soluciones:**
```bash
# 1. Limpia el proyecto
flutter clean

# 2. Actualiza pods
cd ios && pod install && cd ..

# 3. Ejecuta
flutter run -d ios
```

---

### Firebase "Permission denied"

**Causa:** Reglas de seguridad de Firestore/Storage.

**Solución:**
1. Ve a Firebase Console
2. Firestore Database > Rules
3. Verifica que las reglas permitan acceso autenticado:
```javascript
allow read, write: if request.auth != null;
```

---

## 📊 Datos y Almacenamiento

### ¿Dónde se guardan los datos?

- **Base de datos:** Cloud Firestore (Firebase)
- **Imágenes:** Firebase Storage
- **Autenticación:** Firebase Authentication
- **Local (caché):** SharedPreferences (sesión)

---

### ¿Cómo veo los datos en Firestore?

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Firestore Database**
4. Navega por las colecciones: `users`, `products`, etc.

---

### ¿Puedo exportar los datos?

**Manualmente:**
1. Firebase Console > Firestore Database
2. Exportar colección (requiere Cloud Storage bucket)

**Próximamente:**
- Exportación a Excel desde la app
- Exportación a PDF de reportes
- Sincronización con otros sistemas

---

## 🚀 Funcionalidades Futuras

### ¿Cuándo estará lista la función de cámara con IA?

**Estado:** En desarrollo (Fase 5 del roadmap)

**ETA:** 2-3 meses

**Incluirá:**
- Reconocimiento de texto (OCR)
- Detección de objetos
- Clasificación automática
- Extracción de características

---

### ¿Habrá versión web?

**Estado:** En desarrollo para testing

**Uso actual:** Solo para desarrollo

**Producción:** Planeado para versión 2.0

---

### ¿Soportará múltiples idiomas?

**Estado:** Planeado para versión 1.5

**Idiomas iniciales:**
- Español (por defecto)
- Inglés
- Portugués

---

## 💼 Negocios y Uso

### ¿Puedo usar esto para mi negocio?

Sí, la aplicación está diseñada para pequeños y medianos negocios que necesitan gestionar inventario.

---

### ¿Cuántos productos puedo registrar?

**Plan gratuito de Firebase:**
- ✅ Sin límite de documentos
- ⚠️ 50,000 lecturas/día
- ⚠️ 20,000 escrituras/día
- ⚠️ 5GB de almacenamiento

**Para más:** Upgrade a plan Blaze (pago por uso)

---

### ¿Es seguro almacenar datos sensibles?

Sí, Firebase implementa:
- ✅ Cifrado en tránsito (HTTPS)
- ✅ Cifrado en reposo
- ✅ Autenticación obligatoria
- ✅ Reglas de seguridad configurables

**Recomendación:** No almacenes información muy sensible (números de tarjetas, documentos personales completos).

---

## 📚 Recursos Adicionales

### Documentación

- [README.md](./README.md) - Información general del proyecto
- [ACCESS_GUIDE.md](./ACCESS_GUIDE.md) - Guía de acceso y autenticación
- [README_TASKS.md](./README_TASKS.md) - Roadmap técnico completo
- [CHANGELOG.md](./CHANGELOG.md) - Historial de cambios
- [doc/](./doc/) - Documentación técnica detallada

### Enlaces Útiles

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

### Soporte

- **Issues:** [GitHub Issues](https://github.com/galva-developer/stock_letu_shops/issues)
- **Email:** alvaro.gonzales.dev@gmail.com
- **Documentación:** Ver carpeta `/doc`

---

## 🤝 Contribuir

### ¿Puedo contribuir al proyecto?

¡Sí! Las contribuciones son bienvenidas:

1. Fork el repositorio
2. Crea tu feature branch
3. Haz commit de tus cambios
4. Push al branch
5. Abre un Pull Request

**Ver:** Sección "Contribución" en [README.md](./README.md)

---

## 📞 ¿No encontraste tu respuesta?

Si tu pregunta no está aquí:

1. **Revisa la documentación:** [/doc](./doc/)
2. **Busca en Issues:** [GitHub Issues](https://github.com/galva-developer/stock_letu_shops/issues)
3. **Crea un nuevo Issue:** Describe tu problema o pregunta
4. **Contacta al desarrollador:** alvaro.gonzales.dev@gmail.com

---

<div align="center">
  <p><strong>💡 Esta FAQ se actualiza constantemente</strong></p>
  <p>Última actualización: Noviembre 2024</p>
</div>
