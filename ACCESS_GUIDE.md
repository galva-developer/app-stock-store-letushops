# 🔐 Guía de Acceso - Stock LetuShops

## Primera Vez que Usas la Aplicación

### Crear Usuario desde Firebase Console

Todos los usuarios deben ser creados por el administrador desde la Consola de Firebase:

1. **Ve a [Firebase Console](https://console.firebase.google.com/)**

2. **Selecciona tu proyecto** (stock-letu-shops o el nombre que le hayas dado)

3. **Ve a Authentication > Users**

4. **Haz clic en "Add user"**

5. **Ingresa:**
   - Email: (ejemplo: admin@letushops.com)
   - Password: (mínimo 6 caracteres)

6. **Guarda el usuario**

7. **Usa estas credenciales en la app** para iniciar sesión

> ⚠️ **IMPORTANTE:** No existe una opción de auto-registro en la aplicación. 
> Todos los usuarios deben ser creados desde la Consola de Firebase por el administrador del sistema.

---

## 👨‍💼 Credenciales de Prueba Sugeridas

### Para Desarrollo Local

Puedes crear usuarios de prueba con estas credenciales sugeridas:

**Administrador Principal:**
- Email: `admin@letushops.com`
- Password: `Admin123456`

**Usuario de Prueba 1:**
- Email: `test@letushops.com`
- Password: `Test123456`

**Usuario de Prueba 2:**
- Email: `demo@letushops.com`
- Password: `Demo123456`

> ⚠️ **IMPORTANTE:** Estas son credenciales de ejemplo para desarrollo. 
> En producción, usa contraseñas seguras y únicas.

---

## 🔄 Flujo de Primer Uso

```
1. Abrir App
   ↓
2. Ver Splash Screen (2 segundos)
   ↓
3. Redirigir a Login (si no hay sesión activa)
   ↓
4. Opciones:
   - Login (con credenciales creadas en Firebase Console)
   - Recuperar contraseña (si olvidaste)
   ↓
5. Home Dashboard
```

---

## 📱 Características de Autenticación

### ✅ Inicio de Sesión

- Login con email y password
- Opción "Recordarme"
- Persistencia de sesión
- Validaciones en tiempo real

### ✅ Gestión de Usuarios

- Creación de usuarios desde Firebase Console
- Administración centralizada
- Control de acceso
- Seguridad mejorada

### ✅ Recuperación de Contraseña

- Email de recuperación automático
- Link de Firebase para restablecer
- Confirmación visual

### ✅ Sesión Persistente

- La sesión se mantiene entre reinicios de la app
- Logout manual disponible
- Token de Firebase gestionado automáticamente

---

## 🛠️ Gestión de Usuarios

### Ver Usuarios Registrados

1. **Firebase Console:**
   - Authentication > Users
   - Aquí verás todos los usuarios registrados

2. **Desde la App (Próxima Feature):**
   - Panel de administración (en desarrollo)
   - Gestión de roles y permisos

### Eliminar Usuarios

**Desde Firebase Console:**
1. Authentication > Users
2. Busca el usuario
3. Click en el menú (⋮)
4. Delete user

**Nota:** Por ahora no hay función de eliminar desde la app.

---

## 🔒 Seguridad

### Reglas de Firestore Actuales

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Significado:** Solo usuarios autenticados pueden leer/escribir datos.

### Mejoras de Seguridad Recomendadas (Futuro)

1. **Roles de Usuario:**
   ```javascript
   allow write: if request.auth.token.role == "admin";
   ```

2. **Validación de Datos:**
   ```javascript
   allow write: if request.resource.data.keys().hasAll(['name', 'email']);
   ```

3. **Rate Limiting:**
   - Limitar intentos de login
   - Protección contra fuerza bruta

---

## 🧪 Testing

### Crear Usuario de Prueba Rápidamente

```dart
// Desde el código (solo para testing)
final email = 'test@example.com';
final password = 'Test123456';

await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
```

### Limpiar Usuarios de Prueba

1. Firebase Console > Authentication > Users
2. Selecciona múltiples usuarios
3. Delete selected

---

## ❓ Problemas Comunes

### "Usuario no encontrado"

**Solución:** El email no está registrado. Crea una cuenta nueva.

### "Contraseña incorrecta"

**Solución:** Usa "Olvidé mi contraseña" para restablecerla.

### "Email ya en uso"

**Solución:** Este email ya tiene una cuenta. Usa login o recupera contraseña.

### "Contraseña muy débil"

**Solución:** Firebase requiere mínimo 6 caracteres. Usa una contraseña más fuerte.

### "Error de red"

**Solución:** 
- Verifica tu conexión a internet
- Verifica que Firebase esté configurado correctamente
- Revisa `firebase_options.dart`

---

## 🚀 Próximas Funcionalidades

### En Desarrollo:
- [ ] Login con Google
- [ ] Login con Apple
- [ ] Login biométrico (huella/Face ID)
- [ ] Verificación de email
- [ ] Panel de administración de usuarios
- [ ] Roles y permisos
- [ ] Historial de accesos
- [ ] Autenticación de dos factores (2FA)

---

## 📞 Soporte

Si tienes problemas con el acceso:

1. **Revisa los logs de la consola**
2. **Verifica Firebase Console > Authentication**
3. **Checa las reglas de Firestore**
4. **Revisa la documentación de Firebase Auth**

---

## 📚 Recursos

- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Flutter Firebase Auth Package](https://pub.dev/packages/firebase_auth)
- [Clean Architecture Authentication](./doc/authentication/)

---

**¡Bienvenido a Stock LetuShops! 🎉**

Comienza creando tu cuenta de administrador y explora todas las funcionalidades de gestión de inventario.
