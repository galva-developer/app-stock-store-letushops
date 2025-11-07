# 🔒 Guía de Configuración de Firestore Security Rules

Esta guía te ayudará a configurar las reglas de seguridad de Firestore para que el sistema de registro de usuarios funcione correctamente.

## ❌ Error Actual

Si ves este error en la consola:
```
❌ Error inesperado: [cloud_firestore/permission-denied] Missing or insufficient permissions.
```

**Causa:** Las reglas de seguridad de Firestore están bloqueando la creación de documentos de usuarios.

---

## 🛠️ Solución: Actualizar Firestore Security Rules

### Opción 1: Desde Firebase Console (Recomendado)

#### Paso 1: Acceder a Firebase Console
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto: **store-letushops**
3. En el menú lateral, haz clic en **Firestore Database**
4. Ve a la pestaña **Reglas** (Rules)

#### Paso 2: Reemplazar las Reglas
Copia y pega el contenido del archivo `firestore.rules` de este proyecto:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Función auxiliar para verificar si el usuario está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Función auxiliar para obtener datos del usuario actual
    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }
    
    // Función auxiliar para verificar si el usuario es administrador
    function isAdmin() {
      return isAuthenticated() && getUserData().role == 'admin';
    }
    
    // Función auxiliar para verificar si el usuario es manager
    function isManager() {
      return isAuthenticated() && getUserData().role == 'manager';
    }
    
    // Función auxiliar para verificar si el usuario está activo
    function isActive() {
      return isAuthenticated() && getUserData().status == 'active';
    }
    
    // Reglas para la colección de usuarios
    match /users/{userId} {
      // Lectura:
      // - Los usuarios pueden leer su propio documento
      // - Los administradores pueden leer todos los documentos
      allow read: if isAuthenticated() && 
                     (request.auth.uid == userId || isAdmin());
      
      // Creación:
      // - Durante el registro inicial (cuando el documento no existe aún)
      // - Los administradores pueden crear cualquier usuario
      allow create: if (isAuthenticated() && request.auth.uid == userId) ||
                       isAdmin();
      
      // Actualización:
      // - Los usuarios pueden actualizar sus propios datos básicos
      // - Los administradores pueden actualizar cualquier usuario
      // - No se puede cambiar el rol a menos que seas admin
      allow update: if isAuthenticated() && (
                       (request.auth.uid == userId && 
                        request.resource.data.role == resource.data.role) ||
                       isAdmin()
                     );
      
      // Eliminación:
      // - Solo los administradores pueden eliminar usuarios
      allow delete: if isAdmin();
    }
    
    // Reglas para otras colecciones (productos, inventario, etc.)
    match /products/{productId} {
      allow read: if isAuthenticated() && isActive();
      allow write: if isAuthenticated() && isActive() && 
                      (isAdmin() || isManager());
    }
    
    match /inventory/{inventoryId} {
      allow read: if isAuthenticated() && isActive();
      allow write: if isAuthenticated() && isActive() && 
                      (isAdmin() || isManager());
    }
    
    match /reports/{reportId} {
      allow read: if isAuthenticated() && isActive();
      allow write: if isAuthenticated() && isActive() && 
                      (isAdmin() || isManager());
    }
    
    // Por defecto, denegar todo lo demás
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

#### Paso 3: Publicar las Reglas
1. Haz clic en el botón **Publicar** (Publish)
2. Confirma la publicación
3. Espera unos segundos a que se apliquen los cambios

---

### Opción 2: Desde Firebase CLI (Para Desarrolladores)

#### Requisitos Previos
- Node.js instalado
- Firebase CLI instalado (`npm install -g firebase-tools`)
- Autenticado en Firebase (`firebase login`)

#### Paso 1: Inicializar Firebase (si no está inicializado)
```bash
firebase init firestore
```
- Selecciona tu proyecto: **store-letushops**
- Acepta el archivo de reglas predeterminado: `firestore.rules`

#### Paso 2: Desplegar las Reglas
```bash
firebase deploy --only firestore:rules
```

#### Paso 3: Verificar el Despliegue
Verás un mensaje como:
```
✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/store-letushops/overview
```

---

## 🔐 Explicación de las Reglas

### Permisos para la Colección `users`

| Operación | Quién puede | Condiciones |
|-----------|-------------|-------------|
| **Leer** | Usuario mismo | Puede leer su propio documento |
| **Leer** | Admin | Puede leer todos los documentos |
| **Crear** | Usuario mismo | Durante registro inicial |
| **Crear** | Admin | Puede crear cualquier usuario |
| **Actualizar** | Usuario mismo | Solo datos básicos, NO puede cambiar su rol |
| **Actualizar** | Admin | Puede actualizar cualquier campo |
| **Eliminar** | Admin | Solo administradores |

### Permisos para Otras Colecciones

| Colección | Lectura | Escritura |
|-----------|---------|-----------|
| `products` | Todos los usuarios activos | Admin y Manager |
| `inventory` | Todos los usuarios activos | Admin y Manager |
| `reports` | Todos los usuarios activos | Admin y Manager |

---

## ✅ Verificar que Funciona

### Prueba 1: Registro de Usuario
1. Inicia sesión como admin: `admin@letushops.com`
2. Ve al panel de administración
3. Haz clic en "Nuevo Usuario"
4. Completa el formulario y registra un usuario
5. **Resultado esperado:** ✅ Usuario creado exitosamente

### Prueba 2: Logs en la Consola
Deberías ver:
```
🔐 Iniciando sesión para: admin@letushops.com
✅ Autenticación exitosa. UID: aN76Wf8sZAPJ8ausN9m8S1B3XOA2
📄 Obteniendo datos de Firestore...
✅ Documento encontrado en Firestore
📋 Datos de Firestore: role=admin, status=active
👤 Usuario final: role=admin, status=active
🔴 Redirigiendo a panel de administración...
📝 Registrando nuevo usuario: nuevo@letushops.com con rol: employee
✅ Usuario creado en Authentication. UID: glJCZO3Nu7QSfK7GjfUyjTrAwOW2
✅ Documento creado en Firestore con rol: employee
📧 Email de verificación enviado a: nuevo@letushops.com
```

**SIN errores de permisos** ❌ `[cloud_firestore/permission-denied]`

---

## 🚨 Solución de Problemas

### Error: "Missing or insufficient permissions"

**Causa:** Las reglas no están desplegadas correctamente

**Solución:**
1. Verifica que las reglas estén publicadas en Firebase Console
2. Espera 1-2 minutos para que se propaguen
3. Recarga la aplicación y vuelve a intentar

### Error: "Error getting document"

**Causa:** El usuario admin no tiene un documento en Firestore

**Solución:**
1. Verifica que el documento del admin existe en Firestore
2. Debe estar en `users/{uid}` con campo `role: "admin"`
3. Consulta `ADMIN_SETUP_GUIDE.md` para crear el documento

### Las reglas no se aplican

**Causa:** Cache del navegador o demora en propagación

**Solución:**
1. Limpia el cache del navegador (Ctrl+Shift+Del)
2. Cierra y vuelve a abrir la aplicación
3. Espera 2-3 minutos después de publicar las reglas

---

## 📊 Monitoreo de Seguridad

### Ver Solicitudes Denegadas
1. Ve a Firebase Console → Firestore Database
2. Pestaña **Uso** (Usage)
3. Revisa las solicitudes denegadas

### Logs en Tiempo Real
1. Ve a Firebase Console → Firestore Database
2. Habilita **Firestore Debug Mode** si es necesario
3. Observa las solicitudes en tiempo real

---

## 🔒 Mejores Prácticas de Seguridad

### ✅ Hacer
- ✅ Usar reglas de seguridad en producción
- ✅ Validar permisos en el backend (Firestore rules)
- ✅ Revisar periódicamente los logs de seguridad
- ✅ Mantener actualizadas las reglas según evolucione la app

### ❌ Evitar
- ❌ **NUNCA** usar reglas permisivas en producción:
  ```javascript
  // ❌ MAL - NO USAR EN PRODUCCIÓN
  allow read, write: if true;
  ```
- ❌ Confiar solo en validaciones del cliente
- ❌ Exponer datos sensibles sin validación

---

## 📝 Resumen de Comandos

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Iniciar sesión
firebase login

# Inicializar Firestore
firebase init firestore

# Desplegar reglas
firebase deploy --only firestore:rules

# Ver proyectos
firebase projects:list

# Seleccionar proyecto
firebase use store-letushops
```

---

## 📖 Referencias

- [Firestore Security Rules Documentation](https://firebase.google.com/docs/firestore/security/get-started)
- [Security Rules Reference](https://firebase.google.com/docs/rules/rules-language)
- [Best Practices](https://firebase.google.com/docs/firestore/security/rules-conditions)

---

**Última actualización:** Noviembre 7, 2025  
**Versión:** 1.0.0
