# 🗺️ HOJA DE RUTA TÉCNICA - Stock LetuShops

**Guía completa de implementación paso a paso para el desarrollo del proyecto**

Este documento detalla la implementación técnica completa del proyecto Stock LetuShops, organizada en fases y tareas específicas para un desarrollo estructurado y eficiente.

---

## 📋 ÍNDICE DE IMPLEMENTACIÓN

### [FASE 1: CONFIGURACIÓN BASE](#fase-1-configuración-base)
### [FASE 2: AUTENTICACIÓN](#fase-2-autenticación)
### [FASE 2.1: SISTEMA DE ROLES Y ADMINISTRACIÓN](#fase-21-sistema-de-roles-y-administración)
### [FASE 3: NÚCLEO DE LA APLICACIÓN](#fase-3-núcleo-de-la-aplicación)
### [FASE 4: GESTIÓN DE PRODUCTOS](#fase-4-gestión-de-productos)
### [FASE 5: MÓDULO DE CÁMARA E IA](#fase-5-módulo-de-cámara-e-ia)
### [FASE 6: GESTIÓN DE INVENTARIO](#fase-6-gestión-de-inventario)
### [FASE 7: REPORTES Y ESTADÍSTICAS](#fase-7-reportes-y-estadísticas)
### [FASE 8: OPTIMIZACIÓN Y PULIDO](#fase-8-optimización-y-pulido)

---

## 🏗️ FASE 1: CONFIGURACIÓN BASE
**Objetivo**: Establecer la infraestructura básica del proyecto

### 1.1 Configuración del Entorno
- [x] **1.1.1** Verificar instalación de Flutter SDK >= 3.7.2
- [x] **1.1.2** Configurar IDE (VS Code/Android Studio) con extensiones Flutter
- [x] **1.1.3** Configurar emuladores Android e iOS
- [x] **1.1.4** Instalar Firebase CLI: `npm install -g firebase-tools`
- [x] **1.1.5** Instalar FlutterFire CLI: `dart pub global activate flutterfire_cli`

### 1.2 Configuración del Proyecto Base
- [x] **1.2.1** Actualizar `pubspec.yaml` con dependencias básicas:
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    cupertino_icons: ^1.0.8
    firebase_core: ^2.24.2
    firebase_auth: ^4.15.3
    cloud_firestore: ^4.13.6
    firebase_storage: ^11.6.0
    provider: ^6.1.1
    go_router: ^12.1.3
    cached_network_image: ^3.3.1
    image_picker: ^1.0.4
    camera: ^0.10.5+5
    google_ml_kit: ^0.16.0
    intl: ^0.19.0
  ```

- [x] **1.2.2** Ejecutar `flutter pub get`
- [x] **1.2.3** Configurar Firebase para el proyecto:
  ```bash
  firebase login
  flutterfire configure
  ```

### 1.3 Configuración de Firebase
- [x] **1.3.1** Crear proyecto en Firebase Console
- [x] **1.3.2** Habilitar Authentication (Email/Password)
- [x] **1.3.3** Crear base de datos Firestore
- [x] **1.3.4** Configurar Firebase Storage
- [x] **1.3.5** Configurar reglas de seguridad básicas:
  
  **Firestore Rules:**
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
  
  **Storage Rules:**
  ```javascript
  rules_version = '2';
  service firebase.storage {
    match /b/{bucket}/o {
      match /{allPaths=**} {
        allow read, write: if request.auth != null;
      }
    }
  }
  ```

### 1.4 Configuración del Main.dart
- [x] **1.4.1** Crear estructura básica del main.dart:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:provider/provider.dart';
  import 'config/themes/app_theme.dart';
  import 'config/routes/app_routes.dart';
  import 'firebase_options.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const StockLetuShopsApp());
  }
  ```

---

## 🔐 FASE 2: AUTENTICACIÓN
**Objetivo**: Implementar sistema completo de autenticación

### 2.1 Modelos de Autenticación
- [x] **2.1.1** Crear `lib/features/authentication/domain/entities/auth_user.dart`
- [x] **2.1.2** Crear `lib/features/authentication/data/models/user_model.dart`
- [x] **2.1.3** Definir excepciones de autenticación en `lib/features/authentication/domain/exceptions/auth_exceptions.dart`

### 2.2 Repositorios y Fuentes de Datos
- [x] **2.2.1** Crear interfaz del repositorio: `lib/features/authentication/domain/repositories/auth_repository.dart`
- [x] **2.2.2** Implementar fuente de datos Firebase: `lib/features/authentication/data/datasources/firebase_auth_datasource.dart`
- [x] **2.2.3** Implementar repositorio: `lib/features/authentication/data/repositories/auth_repository_impl.dart`

### 2.3 Casos de Uso
- [x] **2.3.1** Crear `lib/features/authentication/domain/usecases/login_usecase.dart`
- [x] **2.3.2** Crear `lib/features/authentication/domain/usecases/register_usecase.dart`
- [x] **2.3.3** Crear `lib/features/authentication/domain/usecases/logout_usecase.dart`
- [x] **2.3.4** Crear `lib/features/authentication/domain/usecases/reset_password_usecase.dart`
- [x] **2.3.5** Crear `lib/features/authentication/domain/usecases/get_current_user_usecase.dart`

### 2.4 Gestión de Estado
- [x] **2.4.1** Crear `lib/features/authentication/presentation/providers/auth_provider.dart`
- [x] **2.4.2** Implementar estados de autenticación (loading, success, error)
- [x] **2.4.3** Crear `lib/features/authentication/presentation/providers/auth_state.dart`

### 2.5 Pantallas de Autenticación
- [x] **2.5.1** Crear `lib/features/authentication/presentation/pages/login_page.dart`
- [x] **2.5.2** Crear `lib/features/authentication/presentation/pages/register_page.dart`
- [x] **2.5.3** Crear `lib/features/authentication/presentation/pages/forgot_password_page.dart`
- [x] **2.5.4** Crear `lib/features/authentication/presentation/pages/splash_page.dart`

### 2.6 Widgets de Autenticación
- [x] **2.6.1** Crear `lib/features/authentication/presentation/widgets/custom_text_field.dart`
- [x] **2.6.2** Crear `lib/features/authentication/presentation/widgets/auth_button.dart`
- [x] **2.6.3** Crear `lib/features/authentication/presentation/widgets/logo_widget.dart`
- [x] **2.6.4** Crear validadores de formularios

### 2.7 Configuración de Rutas Protegidas
- [x] **2.7.1** Crear `lib/config/routes/route_guard.dart`
- [x] **2.7.2** Implementar redirección automática según estado de autenticación
- [x] **2.7.3** Configurar persistencia de sesión

---

## 👥 FASE 2.1: SISTEMA DE ROLES Y ADMINISTRACIÓN
**Objetivo**: Implementar jerarquía de usuarios y panel de administración

### 2.1.1 Configuración de Roles en Entidades
- [x] **2.1.1.1** Verificar enum `UserRole` en `lib/features/authentication/domain/entities/auth_user.dart`
  - Admin: Acceso completo al sistema
  - Manager: Gestión de inventario y reportes
  - Employee: Operaciones básicas
- [x] **2.1.1.2** Verificar enum `UserStatus` en `lib/features/authentication/domain/entities/auth_user.dart`
  - Active: Usuario activo
  - Suspended: Usuario suspendido temporalmente
  - Inactive: Usuario desactivado/eliminado

### 2.1.2 Casos de Uso de Administración
- [x] **2.1.2.1** Crear `lib/features/authentication/domain/usecases/admin/list_all_users_usecase.dart`
- [x] **2.1.2.2** Crear `lib/features/authentication/domain/usecases/admin/update_user_role_usecase.dart`
- [x] **2.1.2.3** Crear `lib/features/authentication/domain/usecases/admin/update_user_status_usecase.dart`
- [x] **2.1.2.4** Crear `lib/features/authentication/domain/usecases/admin/delete_user_usecase.dart`

### 2.1.3 Implementación en Capa de Datos
- [x] **2.1.3.1** Agregar método `getAllUsers()` en `firebase_auth_datasource.dart`
- [x] **2.1.3.2** Agregar método `deleteUser()` en `firebase_auth_datasource.dart`
- [x] **2.1.3.3** Verificar métodos `updateUserRole()` y `updateUserStatus()` existentes
- [x] **2.1.3.4** Agregar método `deleteUser()` en `auth_repository.dart` (interfaz)
- [x] **2.1.3.5** Implementar `deleteUser()` en `auth_repository_impl.dart`

### 2.1.4 Provider de Administración
- [x] **2.1.4.1** Crear `lib/features/authentication/presentation/providers/admin_users_provider.dart`
- [x] **2.1.4.2** Implementar estados: initial, loading, loaded, error, updating, deleting
- [x] **2.1.4.3** Implementar métodos: loadUsers, updateUserRole, updateUserStatus, deleteUser
- [x] **2.1.4.4** Implementar filtros: búsqueda por texto, filtro por rol, filtro por estado
- [x] **2.1.4.5** Implementar estadísticas de usuarios

### 2.1.5 Widgets de Administración
- [x] **2.1.5.1** Crear `lib/features/authentication/presentation/widgets/admin/user_status_badge.dart`
- [x] **2.1.5.2** Crear `lib/features/authentication/presentation/widgets/admin/user_role_selector.dart`
- [x] **2.1.5.3** Crear `lib/features/authentication/presentation/widgets/admin/user_list_item.dart`

### 2.1.6 Pantalla de Administración
- [x] **2.1.6.1** Crear `lib/features/authentication/presentation/pages/admin/admin_users_page.dart`
- [x] **2.1.6.2** Implementar panel de estadísticas de usuarios
- [x] **2.1.6.3** Implementar barra de búsqueda
- [x] **2.1.6.4** Implementar lista de usuarios con UserListItem
- [x] **2.1.6.5** Implementar diálogo de filtros
- [x] **2.1.6.6** Implementar pull-to-refresh

### 2.1.7 Configuración de Rutas y Login
- [x] **2.1.7.1** Agregar ruta `/admin/users` en `app_routes.dart`
- [x] **2.1.7.2** Modificar `login_page.dart` para redirigir a panel admin basándose en el rol de Firestore
- [x] **2.1.7.3** Configurar AdminUsersProvider en `main.dart` con MultiProvider

### 2.1.8 Configuración de Firestore
- [x] **2.1.8.1** Actualizar estructura de colección `users` en Firestore con campos:
  ```javascript
  {
    email: string,
    displayName: string,
    photoURL: string,
    emailVerified: boolean,
    role: string,              // 'admin', 'manager', 'employee'
    status: string,            // 'active', 'suspended', 'inactive'
    creationTime: timestamp,
    lastSignInTime: timestamp,
    updatedAt: timestamp
  }
  ```
- [x] **2.1.8.2** Actualizar Security Rules de Firestore para permisos basados en roles
- [ ] **2.1.8.3** Crear índice compuesto en Firestore para búsquedas eficientes

### 2.1.9 Credenciales de Administrador
- [x] **2.1.9.1** Documentar configuración de admin en README.md (sin credenciales hardcodeadas)
- [x] **2.1.9.2** Documentar jerarquía de roles en README.md
- [ ] **2.1.9.3** Crear script de inicialización para crear usuario admin en Firebase
- [x] **2.1.9.4** Implementar redirección basada en rol de Firestore (sin verificar contraseñas en código)

### 2.1.10 Testing del Sistema de Roles
- [ ] **2.1.10.1** Crear tests unitarios para casos de uso de admin
- [ ] **2.1.10.2** Crear tests de integración para AdminUsersProvider
- [ ] **2.1.10.3** Crear tests de widget para AdminUsersPage
- [ ] **2.1.10.4** Verificar flujo completo: login admin → panel usuarios → cambio de rol

---

## 🎨 FASE 3: NÚCLEO DE LA APLICACIÓN
**Objetivo**: Desarrollar la estructura central de la app

### 3.1 Configuración de Temas
- [x] **3.1.1** Crear `lib/config/themes/app_theme.dart` con paleta rojo-blanco-negro
- [x] **3.1.1** Crear `lib/config/themes/app_theme.dart` con paleta rojo-blanco-negro
- [x] **3.1.2** Implementar tema claro y oscuro
- [x] **3.1.3** Configurar tipografías responsive
- [x] **3.1.4** Definir estilos de componentes (botones, cards, inputs)

### 3.2 Sistema de Rutas
- [x] **3.2.1** Crear `lib/config/routes/app_routes.dart` con GoRouter
- [x] **3.2.2** Definir rutas principales:
  - `/splash`
  - `/login`
  - `/register`
  - `/home`
  - `/products`
  - `/camera` 
  - `/inventory`
  - `/reports`
  - `/profile`
- [x] **3.2.3** Implementar navegación con bottom navigation responsive
- [x] **3.2.4** Configurar deep linking

