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

1. En el menú lateral de Firebase Console, selecciona **Firestore Database**
2. Navega a la colección `users`
   - Si no existe, créala haciendo clic en **Start collection**
   - Nombre de la colección: `users`
3. Crea un nuevo documento:
   - **Document ID**: Pega el UID que copiaste en el paso 2
   - Agrega los siguientes campos:

```javascript
{
  "email": "admin@letushops.com",
  "displayName": "Administrador Principal",
  "photoURL": null,
  "emailVerified": true,
  "role": "admin",
  "status": "active",
  "creationTime": [Timestamp - Usa la hora actual],
  "lastSignInTime": [Timestamp - Usa la hora actual],
  "updatedAt": [Timestamp - Usa la hora actual]
}
```

4. Haz clic en **Save**

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
- Verifica que el usuario existe en Firebase Authentication
- Confirma que el email y password son correctos
- Revisa que el campo `status` en Firestore sea `"active"`

### No veo el panel de administración
- Asegúrate de usar exactamente: `admin@letushops.com` y `password`
- Verifica que el documento en Firestore tenga `role: "admin"`
- Revisa la consola del navegador/app para errores

### Error de permisos en Firestore
- Verifica que las Security Rules estén correctamente configuradas
- Confirma que el documento del usuario existe en la colección `users`
- Verifica que el campo `role` esté correctamente escrito (minúsculas)

---

## 📞 Soporte

Si tienes problemas adicionales, revisa:
- [ACCESS_GUIDE.md](./ACCESS_GUIDE.md) - Guía de acceso general
- [README.md](./README.md) - Documentación principal del proyecto
- [README_TASKS.md](./README_TASKS.md) - Hoja de ruta técnica

---

**Última actualización**: Noviembre 2025  
**Versión**: 1.0.0
