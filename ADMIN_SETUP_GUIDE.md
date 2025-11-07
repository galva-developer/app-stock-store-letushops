# 👑 Guía de Configuración del Administrador

## Configuración del Usuario Administrador en Firebase

Esta guía te ayudará a configurar el usuario administrador principal de la aplicación Stock LetuShops.

---

## 📋 Pasos para Crear el Usuario Administrador

### 1. Acceder a Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto: **stock-letu-shops**
3. En el menú lateral, selecciona **Authentication**

### 2. Crear el Usuario en Authentication

1. Haz clic en la pestaña **Users**
2. Haz clic en el botón **Add user**
3. Completa el formulario:
   - **Email**: `admin@letushops.com`
   - **Password**: Elige una contraseña segura (mínimo 6 caracteres)
4. Haz clic en **Add user**
5. **Copia el UID** del usuario recién creado (lo necesitarás en el siguiente paso)

### 3. Configurar el Rol en Firestore

**IMPORTANTE:** Este paso es OBLIGATORIO. Sin él, no podrás acceder al panel de administración.

1. En el menú lateral de Firebase Console, selecciona **Firestore Database**
2. Si es la primera vez, haz clic en **Create database**:
   - Selecciona **Start in production mode** (luego configuraremos las reglas)
   - Elige una ubicación cercana (ej: `us-central1` o `southamerica-east1`)
   - Haz clic en **Enable**
3. Una vez creada la base de datos, haz clic en **Start collection**
4. Configura la colección:
   - **Collection ID**: `users`
   - Haz clic en **Next**
5. Crea el primer documento:
   - **Document ID**: Pega el UID que copiaste en el paso 2
   - Agrega los siguientes campos uno por uno haciendo clic en **Add field**:

| Campo | Tipo | Valor |
|-------|------|-------|
| `email` | string | `admin@letushops.com` |
| `displayName` | string | `Administrador Principal` |
| `photoURL` | string | (dejar vacío o null) |
| `emailVerified` | boolean | `true` |
| `role` | string | `admin` |
| `status` | string | `active` |
| `creationTime` | timestamp | Haz clic en el reloj y selecciona la hora actual |
| `lastSignInTime` | timestamp | Haz clic en el reloj y selecciona la hora actual |
| `updatedAt` | timestamp | Haz clic en el reloj y selecciona la hora actual |

6. Haz clic en **Save**

✅ **Verificación:** Deberías ver el documento creado con el UID como ID y todos los campos listados arriba.

---

## 🔐 Credenciales del Administrador

Una vez completados los pasos anteriores, podrás iniciar sesión con:

```
Email: admin@letushops.com
Password: [La contraseña que configuraste en Firebase]
```

### Acceso Automático al Panel

Cuando inicies sesión con un usuario que tenga `role: "admin"` en Firestore, la aplicación te redirigirá **automáticamente** al Panel de Administración de Usuarios, donde podrás:

- ✅ Ver todos los usuarios registrados
- ✅ Cambiar roles (Admin, Manager, Employee)
- ✅ Cambiar estados (Activo, Suspendido, Inactivo)
- ✅ Eliminar usuarios
- ✅ Buscar y filtrar usuarios
- ✅ Ver estadísticas del sistema

---

## 👥 Crear Usuarios Adicionales

### Opción 1: Desde Firebase Console

Repite los pasos 1 y 2 de la sección anterior con diferentes credenciales.

**Ejemplo para Manager:**
```
Email: manager@letushops.com
Password: [Elige una contraseña segura]
```

Luego en Firestore, configura el documento con `role: "manager"`

**Ejemplo para Employee:**
```
Email: empleado@letushops.com
Password: [Elige una contraseña segura]
```

Luego en Firestore, configura el documento con `role: "employee"`

### Opción 2: Desde el Panel de Administración

1. Inicia sesión como administrador
2. En el panel de administración, podrás ver todos los usuarios
3. Para crear nuevos usuarios, primero créalos en Firebase Authentication
4. Luego, usa el panel para cambiar su rol según corresponda

---

## 🔒 Security Rules de Firestore

Asegúrate de tener las siguientes reglas de seguridad configuradas en Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    function isAdmin() {
      return isAuthenticated() && getUserRole() == 'admin';
    }
    
    function isManagerOrAdmin() {
      return isAuthenticated() && (getUserRole() == 'admin' || getUserRole() == 'manager');
    }
    
    // Reglas para usuarios
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Reglas para productos
    match /products/{productId} {
      allow read: if isAuthenticated();
      allow write: if isManagerOrAdmin();
    }
  }
}
```

Para aplicar estas reglas:

1. Ve a **Firestore Database** en Firebase Console
2. Selecciona la pestaña **Rules**
3. Copia y pega las reglas anteriores
4. Haz clic en **Publish**

---

## 🎯 Jerarquía de Roles

### 🔴 Admin (Administrador)
- Acceso completo al sistema
- Gestión de usuarios
- Cambio de roles y estados
- Todas las funciones de Manager y Employee

### 🔵 Manager (Gerente)
- Gestión completa de inventario
- Acceso a reportes avanzados
- Gestión de productos
- Todas las funciones de Employee

### ⚪ Employee (Empleado)
- Operaciones básicas de inventario
- Captura de productos
- Consulta de stock
- Actualización de productos asignados

---

## ⚠️ Notas Importantes

1. **No compartas las credenciales de administrador** - Son de acceso crítico al sistema
2. **Usa contraseñas seguras** - Mínimo 8 caracteres, combinando letras, números y símbolos
3. **No almacenes credenciales en el código** - Las contraseñas solo existen en Firebase Authentication
4. **No elimines al usuario admin** - Mantén al menos un usuario con rol de administrador
5. **Respaldo regular** - Haz backups periódicos de Firestore para prevenir pérdida de datos
6. **Auditoría de accesos** - Revisa regularmente los usuarios activos y sus roles

---

## 🆘 Solución de Problemas

### No puedo iniciar sesión
**Síntomas:** La app muestra error de credenciales incorrectas.

**Soluciones:**
1. Verifica que el usuario existe en **Firebase Authentication > Users**
2. Confirma que estás usando el email y password correctos
3. Intenta hacer reset de contraseña desde Firebase Console
4. Verifica que el campo `status` en Firestore sea `"active"` (no `"suspended"` o `"inactive"`)

### La app se queda en pantalla de carga (Splash)
**Síntomas:** Después del login, la app muestra la pantalla de splash y no avanza.

**Soluciones:**
1. **Verifica que el documento existe en Firestore:**
   - Ve a **Firestore Database > users**
   - Busca el documento con el UID del usuario
   - Si no existe, créalo siguiendo el paso 3

2. **Verifica que el campo `role` está correctamente escrito:**
   - Debe ser exactamente: `admin` (en minúsculas)
   - No debe tener espacios adicionales
   - El tipo de campo debe ser `string`

3. **Verifica la consola de la app:**
   - En VS Code, abre la terminal de Debug Console
   - Busca mensajes de error relacionados con Firestore
   - Si ves errores de permisos, revisa las Security Rules

### No veo el panel de administración
**Síntomas:** La app me lleva al Home en lugar del panel de admin.

**Soluciones:**
1. **Verifica el rol en Firestore:**
   ```
   Firestore Database > users > [tu-uid] > role
   ```
   - Debe decir exactamente: `admin`
   
2. **Verifica el código del usuario:**
   - Cierra sesión
   - Vuelve a iniciar sesión
   - Si aún no funciona, elimina y vuelve a crear el documento en Firestore

3. **Limpia la caché de la app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Error de permisos en Firestore
**Síntomas:** Errores como "Missing or insufficient permissions"

**Soluciones:**
1. **Verifica las Security Rules:**
   - Ve a **Firestore Database > Rules**
   - Asegúrate de que las reglas están publicadas (ver sección anterior)
   - Las reglas deben incluir las funciones helper

2. **Verifica que el documento del usuario existe:**
   - El documento debe existir en `users/{uid}`
   - El UID debe coincidir con el del usuario autenticado

3. **Verifica que el campo `role` existe:**
   - Abre el documento del usuario en Firestore
   - Debe tener un campo `role` de tipo string

### Debug paso a paso

Si sigues teniendo problemas, sigue estos pasos:

1. **Paso 1: Verificar Authentication**
   ```
   Firebase Console > Authentication > Users
   ```
   - ✅ El usuario debe aparecer en la lista
   - ✅ Debe tener un UID único
   - ✅ El email debe ser correcto

2. **Paso 2: Verificar Firestore**
   ```
   Firebase Console > Firestore Database > users > [UID]
   ```
   - ✅ Debe existir un documento con el UID del usuario
   - ✅ Debe tener el campo `role: "admin"`
   - ✅ Debe tener el campo `status: "active"`

3. **Paso 3: Verificar Security Rules**
   ```
   Firebase Console > Firestore Database > Rules
   ```
   - ✅ Las reglas deben estar publicadas
   - ✅ Deben incluir las funciones isAuthenticated(), getUserRole(), isAdmin()

4. **Paso 4: Probar el login**
   - Cierra la app completamente
   - Vuelve a ejecutar: `flutter run`
   - Intenta iniciar sesión
   - Observa los logs en la consola de VS Code

5. **Paso 5: Verificar los logs**
   En la consola deberías ver:
   ```
   RouteGuard: User authenticated as admin
   RouteGuard: Redirecting to /admin/users
   ```

Si no ves estos mensajes, hay un problema con la carga del usuario desde Firestore.

---

## 📞 Soporte

Si tienes problemas adicionales, revisa:
- [ACCESS_GUIDE.md](./ACCESS_GUIDE.md) - Guía de acceso general
- [README.md](./README.md) - Documentación principal del proyecto
- [README_TASKS.md](./README_TASKS.md) - Hoja de ruta técnica

---

**Última actualización**: Noviembre 2025  
**Versión**: 1.0.0
