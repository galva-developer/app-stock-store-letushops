# Guía de Registro de Usuarios - Panel de Administración

Esta guía explica cómo utilizar el sistema de registro de usuarios desde el panel de administración.

## 📋 Tabla de Contenidos

1. [Acceso al Panel de Administración](#acceso-al-panel-de-administración)
2. [Registrar Nuevo Usuario](#registrar-nuevo-usuario)
3. [Roles Disponibles](#roles-disponibles)
4. [Proceso de Verificación](#proceso-de-verificación)
5. [Solución de Problemas](#solución-de-problemas)

---

## 🔐 Acceso al Panel de Administración

### Requisitos Previos
- Tener una cuenta de administrador activa
- Iniciar sesión con credenciales de admin

### Cómo Acceder
1. Inicia sesión con tu cuenta de administrador
2. Serás redirigido automáticamente a `/admin/users`
3. Verás el panel de gestión de usuarios

---

## ➕ Registrar Nuevo Usuario

### Pasos para Crear un Usuario

#### 1. Abrir el Diálogo de Registro
- En el panel de administración, haz clic en el botón **"Nuevo Usuario"** (botón flotante rojo en la esquina inferior derecha)

#### 2. Completar el Formulario
El diálogo solicitará la siguiente información:

| Campo | Descripción | Validación |
|-------|-------------|------------|
| **Nombre Completo** | Nombre y apellido del usuario | Mínimo 3 caracteres |
| **Email** | Correo electrónico único | Formato válido de email |
| **Contraseña Temporal** | Contraseña inicial para el usuario | Mínimo 8 caracteres |
| **Rol** | Rol asignado (Empleado o Gerente) | Selección requerida |

#### 3. Seleccionar el Rol

**Opciones disponibles:**
- 🔵 **Gerente (Manager)**: Permisos intermedios de gestión
- ⚪ **Empleado (Employee)**: Permisos básicos de operación

> ⚠️ **Nota**: No se pueden crear usuarios administradores desde esta interfaz por razones de seguridad.

#### 4. Confirmar el Registro
- Haz clic en el botón **"Registrar"**
- Espera a que se complete el proceso (verás un indicador de carga)
- Si todo es correcto, verás un mensaje de éxito

---

## 🎭 Roles Disponibles

### Empleado (Employee)
**Permisos:**
- Acceso a funciones básicas de la aplicación
- Consulta de inventario
- Registro de productos

**Limitaciones:**
- No puede gestionar usuarios
- No puede modificar configuraciones críticas

### Gerente (Manager)
**Permisos:**
- Todos los permisos de Empleado
- Gestión de inventario avanzada
- Generación de reportes
- Supervisión de operaciones

**Limitaciones:**
- No puede crear, modificar o eliminar usuarios
- No puede acceder al panel de administración

### Administrador (Admin)
**Permisos:**
- Acceso completo a todas las funciones
- Gestión de usuarios (crear, modificar, eliminar)
- Configuración del sistema
- Acceso al panel de administración

> 🔴 **Los administradores solo pueden ser creados manualmente en Firebase Console**

---

## 📧 Proceso de Verificación

### ¿Qué Sucede Después del Registro?

1. **Usuario Creado en Firebase Authentication**
   - Se crea la cuenta con el email y contraseña proporcionados

2. **Documento Creado en Firestore**
   - Se almacenan los datos del usuario:
     - UID (identificador único)
     - Email
     - Nombre completo
     - Rol asignado
     - Estado: Activo
     - Fecha de creación

3. **Email de Verificación Enviado**
   - El usuario recibe automáticamente un email
   - Debe verificar su cuenta antes del primer inicio de sesión
   - El link de verificación expira en 24 horas

4. **Usuario Aparece en la Lista**
   - El nuevo usuario se muestra inmediatamente en el panel
   - Estado inicial: **Activo**
   - Email verificado: **No** (hasta que verifique)

---

## ❌ Errores Comunes y Soluciones

### "El email ya está registrado"
**Causa:** Ya existe una cuenta con ese email

**Solución:**
- Verifica que el email no esté ya registrado
- Usa la función de búsqueda para encontrar usuarios existentes
- Si el usuario ya existe, puedes modificar su rol en lugar de crear uno nuevo

### "Contraseña muy débil"
**Causa:** La contraseña no cumple con los requisitos de seguridad

**Solución:**
- Usa al menos 8 caracteres
- Incluye mayúsculas, minúsculas y números
- Ejemplo de contraseña segura: `Temp2024!`

### "Email inválido"
**Causa:** El formato del email no es correcto

**Solución:**
- Verifica que el email tenga formato válido
- Debe incluir `@` y un dominio
- Ejemplo: `usuario@letushops.com`

### "Permisos insuficientes"
**Causa:** Tu cuenta no tiene permisos de administrador

**Solución:**
- Verifica que estés usando una cuenta de administrador
- Cierra sesión e inicia con credenciales de admin
- Si el problema persiste, contacta al administrador del sistema

### "Error de red"
**Causa:** Problemas de conectividad con Firebase

**Solución:**
- Verifica tu conexión a internet
- Intenta nuevamente después de unos segundos
- Si persiste, revisa la consola de Firebase

---

## 📊 Estadísticas y Monitoreo

Después de registrar usuarios, puedes:

- **Ver estadísticas en tiempo real** en el panel superior
- **Filtrar usuarios** por rol o estado
- **Buscar usuarios** por nombre o email
- **Modificar roles** si es necesario
- **Cambiar estados** (Activo/Suspendido/Inactivo)

---

## 🔒 Mejores Prácticas de Seguridad

### Contraseñas Temporales
1. ✅ Usa contraseñas fuertes y únicas
2. ✅ Informa al usuario que debe cambiarla en su primer inicio de sesión
3. ✅ No compartas contraseñas por canales inseguros

### Gestión de Roles
1. ✅ Asigna el rol mínimo necesario (principio de menor privilegio)
2. ✅ Revisa periódicamente los roles asignados
3. ✅ Suspende cuentas en lugar de eliminarlas

### Auditoría
1. ✅ El sistema registra quién creó cada usuario
2. ✅ Se almacenan fechas de creación y modificación
3. ✅ Revisa regularmente la lista de usuarios activos

---

## 🆘 Soporte

Si encuentras problemas no cubiertos en esta guía:

1. Verifica los logs en la consola del navegador (F12)
2. Revisa los logs de Firebase en la consola de Firebase
3. Consulta la documentación técnica en `doc/authentication/`

---

## 📝 Ejemplo Completo

### Registro de un Gerente

```
Nombre Completo: María González
Email: maria.gonzalez@letushops.com
Contraseña Temporal: Manager2024!
Rol: Gerente (Manager)
```

**Resultado esperado:**
- ✅ Usuario creado en Firebase Authentication
- ✅ Documento creado en Firestore con rol "manager"
- ✅ Email de verificación enviado a maria.gonzalez@letushops.com
- ✅ Usuario visible en el panel con estado "Activo"
- ✅ Mensaje de éxito mostrado

---

## 🎯 Flujo Completo del Usuario Nuevo

```
1. Admin crea usuario
   ↓
2. Sistema envía email de verificación
   ↓
3. Usuario recibe email y verifica cuenta
   ↓
4. Usuario inicia sesión con contraseña temporal
   ↓
5. (Recomendado) Usuario cambia su contraseña
   ↓
6. Usuario accede según su rol asignado
```

---

**Última actualización:** Noviembre 7, 2025  
**Versión del sistema:** 1.0.0
