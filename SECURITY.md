# 🔒 Mejores Prácticas de Seguridad - Stock LetuShops

Este documento describe las prácticas de seguridad implementadas y recomendadas para el proyecto Stock LetuShops.

---

## ✅ Prácticas Implementadas

### 1. **Sin Credenciales en Código Fuente**
- ❌ **No almacenamos** contraseñas, API keys, o tokens en el código
- ✅ Las credenciales solo existen en Firebase Authentication
- ✅ La autenticación se basa en roles de Firestore, no en credenciales hardcodeadas

### 2. **Autenticación Basada en Roles**
- La redirección al panel de administración se determina por el campo `role` en Firestore
- No hay verificación de credenciales específicas en el código de la aplicación
- Cada usuario tiene un rol asignado: `admin`, `manager`, o `employee`

### 3. **Security Rules de Firestore**
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
    
    // Solo usuarios autenticados pueden leer usuarios
    // Solo admins pueden modificar usuarios
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Managers y admins pueden gestionar productos
    match /products/{productId} {
      allow read: if isAuthenticated();
      allow write: if isManagerOrAdmin();
    }
  }
}
```

### 4. **Validación del Lado del Servidor**
- Firebase Authentication maneja la validación de credenciales
- Firestore Security Rules validan permisos en cada operación
- No confiamos en validaciones del lado del cliente únicamente

### 5. **Gestión de Sesiones**
- Firebase Auth maneja automáticamente los tokens de sesión
- Los tokens se renuevan automáticamente
- Implementación de logout seguro

---

## 🛡️ Recomendaciones Adicionales

### Contraseñas Seguras
- **Mínimo 8 caracteres**
- Combinar mayúsculas, minúsculas, números y símbolos especiales
- No reutilizar contraseñas de otros sistemas
- Cambiar contraseñas periódicamente (cada 90 días para admins)

**Ejemplos de contraseñas seguras:**
- ❌ `Admin123` (muy simple)
- ❌ `password` (palabra común)
- ✅ `St0ck@L3tu2024!` (segura)
- ✅ `MyS3cur3P@ssw0rd!` (segura)

### Variables de Entorno
Para información sensible adicional, usar variables de entorno:

1. **Crear archivo `.env` (nunca hacer commit):**
```bash
FIREBASE_API_KEY=your-api-key-here
ADMIN_EMAIL=admin@letushops.com
```

2. **Agregar al `.gitignore`:**
```
*.env
.env.local
.env.*.local
```

3. **Usar en código:**
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load(fileName: ".env");
final apiKey = dotenv.env['FIREBASE_API_KEY'];
```

### Auditoría de Usuarios
- Revisar regularmente los usuarios con rol `admin`
- Desactivar cuentas de usuarios que ya no trabajan en la organización
- Monitorear actividad sospechosa

### Backups Regulares
- Hacer backup diario de Firestore
- Guardar backups en ubicación segura
- Probar restauración de backups periódicamente

---

## 🚨 Qué NO Hacer

### ❌ Nunca Hacer Commit de:
- Contraseñas en archivos de configuración
- Archivos `.env` con credenciales
- Service account keys de Firebase
- API keys en código fuente
- Tokens de autenticación
- Archivos de configuración privados de Firebase

### ❌ No Compartir:
- Credenciales de administrador por email o chat
- Service account keys por mensajería
- URLs de Firebase Admin SDK
- Tokens de acceso personal

---

## 🔐 Gestión de Usuarios Administradores

### Crear Administrador
1. Crear usuario en Firebase Authentication
2. Configurar documento en Firestore con `role: "admin"`
3. Comunicar credenciales de forma segura (nunca por email no cifrado)

### Revocar Acceso de Administrador
1. Cambiar `role` de `admin` a `employee` en Firestore
2. O cambiar `status` a `suspended` o `inactive`
3. Opcionalmente, eliminar usuario de Firebase Authentication

### Rotación de Credenciales
- Cambiar contraseñas de administradores cada 90 días
- Usar contraseñas únicas, no reutilizadas
- Notificar a administradores antes del vencimiento

---

## 📋 Checklist de Seguridad

Antes de hacer commit/push:

- [ ] No hay contraseñas en el código
- [ ] No hay API keys hardcodeadas
- [ ] Los archivos `.env` están en `.gitignore`
- [ ] Las Security Rules de Firestore están actualizadas
- [ ] Los service accounts no están en el repositorio
- [ ] Las credenciales de prueba son genéricas

Antes de deployment:

- [ ] Security Rules de producción están aplicadas
- [ ] Usuarios de prueba están eliminados/desactivados
- [ ] Logs sensibles están deshabilitados
- [ ] HTTPS está habilitado en todas las conexiones
- [ ] Auditoría de permisos completada

---

## 📞 Reportar Problemas de Seguridad

Si encuentras una vulnerabilidad de seguridad:

1. **NO la publiques** en issues públicos de GitHub
2. Contacta directamente al equipo de desarrollo
3. Proporciona detalles del problema y pasos para reproducirlo
4. Espera confirmación antes de hacer pública la información

---

## 🔗 Recursos Adicionales

- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Firebase Authentication Best Practices](https://firebase.google.com/docs/auth/best-practices)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)

---

## 📝 Historial de Cambios

### v1.1.0 (Noviembre 2025)
- ✅ Removidas credenciales hardcodeadas del código
- ✅ Implementada autenticación basada en roles de Firestore
- ✅ Agregadas Security Rules mejoradas
- ✅ Actualizado `.gitignore` para seguridad

### v1.0.0 (Octubre 2025)
- ✅ Implementación inicial con Firebase Auth
- ✅ Sistema básico de roles

---

**Última actualización**: Noviembre 2025  
**Responsable**: Equipo de Desarrollo Stock LetuShops
