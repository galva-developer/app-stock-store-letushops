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
### [FASE 5: MÓDULO DE VENTAS](#fase-5-módulo-de-ventas)
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

### 2.1.9 Credenciales de Administrador
- [x] **2.1.9.1** Documentar configuración de admin en README.md (sin credenciales hardcodeadas)
- [x] **2.1.9.2** Documentar jerarquía de roles en README.md
- [x] **2.1.9.3** Crear script de inicialización para crear usuario admin en Firebase
- [x] **2.1.9.4** Implementar redirección basada en rol de Firestore (sin verificar contraseñas en código)

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

### 3.3 Layout Principal
- [x] **3.3.1** Crear `lib/features/home/presentation/pages/main_layout.dart`
- [x] **3.3.2** Implementar bottom navigation bar con iconos
- [x] **3.3.3** Configurar transiciones entre pantallas
- [x] **3.3.4** Crear `lib/features/home/presentation/pages/home_page.dart`

### 3.4 Widgets Compartidos
- [x] **3.4.1** Crear widgets de logo en `lib/shared/widgets/app_logo.dart`
- [x] **3.4.2** Crear widgets de tema (ThemeToggleButton, ThemeSelector, ThemeDialog, ThemeSwitch, ThemeSettingsTile)
- [x] **3.4.3** Implementar loading indicators personalizados
- [x] **3.4.4** Crear widgets de error/empty state

### 3.5 Providers Globales
- [x] **3.5.1** Crear `lib/shared/providers/theme_provider.dart`
- [x] **3.5.2** Implementar persistencia de preferencias de tema
- [x] **3.5.3** Configurar MultiProvider en main.dart

---

## 📦 FASE 4: GESTIÓN DE PRODUCTOS
**Objetivo**: Implementar módulo completo de productos con Clean Architecture

### 4.1 Entidades de Dominio
- [x] **4.1.1** Crear `lib/features/products/domain/entities/product.dart`
  - Product class con 20+ campos (id, name, description, price, costPrice, stock, minStock, etc.)
  - ProductCategory enum (electronics, clothing, food, beverages, homeAppliances, beauty, sports, toys, books, other)
  - ProductStatus enum (active, inactive, discontinued)
  - Getters: hasLowStock, isOutOfStock, isActive, profitMargin, primaryImage
  - Método copyWith() para actualizaciones inmutables

### 4.2 Modelos de Datos
- [x] **4.2.1** Crear `lib/features/products/data/models/product_model.dart`
  - Método fromFirestore() para convertir DocumentSnapshot a ProductModel
  - Método toFirestore() para convertir ProductModel a Map para Firestore
  - Método fromEntity() para convertir Product a ProductModel
  - Método toEntity() para convertir ProductModel a Product
  - Parsing seguro de enums (category, status)

### 4.3 Repositorio de Dominio
- [x] **4.3.1** Crear `lib/features/products/domain/repositories/product_repository.dart`
  - Métodos CRUD: createProduct, getProductById, updateProduct, deleteProduct
  - Métodos de búsqueda: getAllProducts, searchProducts
  - Métodos de filtrado: getProductsByCategory, getProductsByPriceRange, getProductsByStatus, getLowStockProducts, getOutOfStockProducts
  - Streams: watchProducts, watchProductsByCategory
  - Estadísticas: getProductStats (clase ProductStats con totalProducts, lowStockProducts, outOfStockProducts, totalValue)

### 4.4 Fuente de Datos Firebase
- [x] **4.4.1** Crear `lib/features/products/data/datasources/firebase_product_datasource.dart`
  - Configurar colección 'products' en Firestore
  - Implementar getAllProducts() con ordenamiento por createdAt
  - Implementar searchProducts() con filtrado client-side (toLowerCase, contains)
  - Implementar getProductsByCategory() con query where
  - Implementar getLowStockProducts() con filtrado client-side
  - Implementar getOutOfStockProducts() con filtrado client-side
  - Implementar CRUD: addProduct(), updateProduct(), deleteProduct()
  - Implementar streams para actualizaciones en tiempo real

### 4.5 Implementación del Repositorio
- [x] **4.5.1** Crear `lib/features/products/data/repositories/product_repository_impl.dart`
  - Implementar todos los métodos de ProductRepository
  - Delegar operaciones al FirebaseProductDataSource
  - Calcular estadísticas agregadas en getProductStats()
  - Manejar excepciones y errores

### 4.6 Casos de Uso
- [x] **4.6.1** Crear `lib/features/products/domain/usecases/product_usecases.dart`
  - CreateProductUseCase: Crear nuevo producto en Firestore
  - UpdateProductUseCase: Actualizar producto existente
  - DeleteProductUseCase: Eliminar producto por ID
  - GetAllProductsUseCase: Obtener lista de todos los productos
  - SearchProductsUseCase: Buscar productos por query (nombre/descripción)
  - GetProductsByCategoryUseCase: Filtrar productos por categoría
  - GetLowStockProductsUseCase: Obtener productos con stock bajo
  - GetProductStatsUseCase: Obtener estadísticas del inventario

### 4.7 Provider de Productos
- [x] **4.7.1** Crear `lib/features/products/presentation/providers/products_provider.dart`
  - Enum ProductsState (initial, loading, loaded, error, updating, deleting)
  - Propiedades: products (List<Product>), stats (ProductStats), filterCategory, errorMessage
  - Métodos de carga: loadProducts(), searchProducts(query), filterByCategory(category)
  - Métodos CRUD: createProduct(product), updateProduct(product), deleteProduct(productId)
  - Método loadStats() para estadísticas
  - Manejo de estados y errores con try-catch

### 4.8 Widgets de Productos
- [x] **4.8.1** Crear `lib/features/products/presentation/widgets/product_card.dart`
  - Card reutilizable para lista de productos
  - Mostrar imagen del producto (network con placeholder)
  - Mostrar nombre, precio, stock
  - Badges de estado según stock (🔴 agotado, 🟠 bajo, 🟢 OK)
  - Botones de acción: editar, eliminar
  - Callback onTap para navegar a detalle
  - Diseño responsive horizontal

- [x] **4.8.2** Crear `lib/features/products/presentation/widgets/category_selector.dart`
  - Selector horizontal de categorías con scroll
  - FilterChip para cada categoría
  - Opción "Todos" para quitar filtro
  - Iconos personalizados por categoría (devices, checkroom, restaurant, etc.)
  - Integración con ProductsProvider para filtrado
  - Estado isSelected visual

### 4.9 Pantallas de Productos
- [x] **4.9.1** Crear `lib/features/products/presentation/pages/products_page.dart`
  - AppBar con título "Productos" y botón de actualizar
  - Integración con ThemeProvider para modo oscuro
  - Barra de búsqueda con TextField y botón de limpiar
  - CategorySelector para filtrado por categoría
  - Panel de estadísticas rápidas (total, stock bajo, agotados) con iconos
  - ListView de productos usando ProductCard
  - Pull-to-refresh para recargar datos
  - Estados: loading (CircularProgressIndicator), error, empty
  - FAB para agregar productos
  - Diálogo de confirmación para eliminar

- [x] **4.9.2** Crear `lib/features/products/presentation/pages/add_product_page.dart`
  - Formulario completo para crear/editar productos
  - Modo dual: creación (productToEdit == null) o edición
  - Secciones del formulario:
    - Información Básica: nombre*, descripción
    - Clasificación: categoría* (dropdown), estado* (dropdown)
    - Precios: precio de venta*, precio de costo
    - Inventario: stock actual*, stock mínimo
    - Identificación: SKU, código de barras
    - Información Adicional: marca, fabricante
    - Etiquetas: tags separados por comas
  - Validación de campos requeridos
  - TextFormField personalizados con iconos
  - Botones: Cancelar, Guardar/Actualizar
  - Estado de carga durante guardado (CircularProgressIndicator)
  - SnackBar para feedback de éxito/error
  - Navegación automática al completar

- [x] **4.9.3** Crear `lib/features/products/presentation/pages/product_detail_page.dart`
  - AppBar con acciones: editar, eliminar
  - Imagen del producto en contenedor de 250px (o placeholder)
  - Header con nombre y badge de estado (Active/Inactive/Discontinued)
  - Chip de categoría con icono
  - Descripción del producto
  - Tarjetas informativas organizadas por sección:
    - Precios: precio venta, precio costo, margen de ganancia (%)
    - Inventario: stock actual, stock mínimo
    - Identificación: SKU, código de barras
    - Información Adicional: marca, fabricante
    - Etiquetas: chips coloridos
    - Fechas: creación, última actualización
  - Alertas visuales de stock (Container con borde y fondo coloreado)
  - Diálogo de confirmación para eliminar
  - Navegación a AddProductPage para editar
  - Integración con DateFormat e intl para fechas
  - Integración con NumberFormat para precios

### 4.10 Configuración e Integración
- [x] **4.10.1** Configurar ProductsProvider en `lib/main.dart`
  - Agregar imports de products (ProductsProvider, ProductRepository, etc.)
  - Crear instancias de productDataSource y productRepository
  - Agregar ChangeNotifierProvider<ProductsProvider> al MultiProvider
  - Inyectar los 8 use cases al ProductsProvider

- [x] **4.10.2** Configurar rutas de productos en `lib/config/routes/app_routes.dart`
  - Ruta '/products' ya configurada con ProductsPage
  - Navegación programática a AddProductPage (con/sin productToEdit)
  - Navegación programática a ProductDetailPage (con product)

- [x] **4.10.3** Actualizar reglas de Firestore para colección products
  ```javascript
  match /products/{productId} {
    allow read: if request.auth != null;
    allow write: if request.auth != null && 
      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager'];
  }
  ```

### 4.11 Documentación
- [x] **4.11.1** Crear `doc/products_module.md` con documentación completa
  - Arquitectura del módulo (Domain, Data, Presentation)
  - Estructura de datos en Firestore
  - Flujo de casos de uso
  - Características implementadas
  - Pendientes y mejoras futuras
  - Configuración requerida

- [x] **4.11.2** Actualizar CHANGELOG.md con cambios de FASE 4
  - Sección "Unreleased" con módulo de productos completo
  - Detalles de cada capa (Domain, Data, Presentation)
  - Funcionalidades implementadas
  - Configuración realizada

### 4.12 Optimizaciones y Correcciones
- [x] **4.12.1** Corregir errores de índice compuesto en Firestore
  - Remover `.orderBy()` después de `.where()` en getProductsByCategory()
  - Remover `.orderBy()` después de `.where()` en getProductsByStatus()
  - Remover `.orderBy()` después de `.where()` en getProductsByPriceRange()
  - Remover `.orderBy()` después de `.where()` en getProductsByCreator()
  - Implementar ordenamiento client-side con `.sort()` en los 4 métodos

- [x] **4.12.2** Mejorar diseño responsive en HomePage
  - Ajustar childAspectRatio de 1.5 a 1.3 en GridView de acciones rápidas
  - Agregar maxLines: 2 y overflow: TextOverflow.ellipsis a textos de ActionCard

- [x] **4.12.3** Optimizar botón de agregar producto
  - Cambiar FloatingActionButton.extended a FloatingActionButton circular
  - Usar ícono "+" con tamaño 28px
  - Agregar tooltip "Agregar Producto"
  - Configurar colores: backgroundColor y foregroundColor con ColorConstants

### 4.13 Consistencia de Tema y Colores
- [x] **4.13.1** Actualizar tema oscuro para consistencia de colores rojos
  - Actualizar ColorScheme en darkTheme:
    - primary: ColorConstants.primaryColor (#D32F2F)
    - onPrimary: ColorConstants.textOnPrimaryColor (blanco)
  - Actualizar appBarTheme en darkTheme:
    - backgroundColor: ColorConstants.primaryColor
    - foregroundColor, iconTheme, actionsIconTheme: blanco
  - Agregar/actualizar temas de componentes en darkTheme:
    - elevatedButtonTheme: backgroundColor primaryColor
    - outlinedButtonTheme: foregroundColor primaryColor
    - textButtonTheme: foregroundColor primaryColor
    - floatingActionButtonTheme: backgroundColor primaryColor
    - inputDecorationTheme: focusedBorder primaryColor
    - bottomNavigationBarTheme: selectedItemColor primaryColor
    - chipTheme: selectedColor primaryColor
    - switchTheme: activeColor primaryColor
    - checkboxTheme: fillColor primaryColor
    - radioTheme: fillColor primaryColor
    - progressIndicatorTheme: color primaryColor
    - tabBarTheme: indicatorColor, labelColor primaryColor
    - listTileTheme: selectedTileColor primaryColor con opacidad

- [x] **4.13.2** Actualizar AppBar en páginas para usar ColorConstants
  - ProductsPage: backgroundColor ColorConstants.primaryColor, foregroundColor textOnPrimaryColor
  - CameraPage: backgroundColor ColorConstants.primaryColor, foregroundColor textOnPrimaryColor
  - ProductDetailPage: backgroundColor ColorConstants.primaryColor, foregroundColor textOnPrimaryColor
  - AddProductPage: Ya usa ElevatedButton con ColorConstants

- [x] **4.13.3** Actualizar CategorySelector para consistencia en ambos modos
  - Agregar detección de tema: `theme.brightness == Brightness.dark`
  - selectedColor: ColorConstants.primaryColor (siempre rojo #D32F2F)
  - backgroundColor: Adaptativo (grey800 en oscuro, grey200 en claro)
  - Icon color: textOnPrimaryColor cuando seleccionado, primaryColor cuando no
  - Label color: Adaptativo según tema
  - checkmarkColor: blanco
  - shape con bordes adaptativos

- [x] **4.13.4** Actualizar títulos en ProductDetailPage
  - _buildSectionTitle(): color ColorConstants.primaryColor (siempre rojo en ambos modos)
  - Títulos afectados: "Descripción", "Precios", "Inventario", "Identificación", "Información Adicional", "Etiquetas", "Fechas"

- [x] **4.13.5** Corregir visibilidad de títulos de sección en AddProductPage
  - Actualizar _buildSectionTitle() para usar ColorConstants.primaryColor
  - Títulos afectados: "Información Básica", "Clasificación", "Precios", "Inventario", "Identificación", "Información Adicional", "Etiquetas", "Variantes de Color"
  - Solución: Cambiar de Theme.of(context).colorScheme.onSurface a ColorConstants.primaryColor
  - Asegurar visibilidad en modo oscuro (evitar color gris sobre fondo gris)

- [x] **4.13.6** Mejorar contraste en ProductCard para modo oscuro
  - Actualizar precio para usar ColorConstants.primaryColor (en lugar de Theme.of(context).primaryColor)
  - Actualizar badge de variantes para usar ColorConstants.primaryColor:
    - Container background: ColorConstants.primaryColor.withOpacity(0.1)
    - Palette icon: ColorConstants.primaryColor
    - Text count: ColorConstants.primaryColor
  - Mejorar visibilidad y estética en modo oscuro
  - Mantener consistencia visual con otros elementos de la UI

### 4.14 Sistema de Variantes de Color
- [x] **4.14.1** Crear ProductVariant entity en product.dart
  - Campos: colorName (String), colorHex (String), stock (int), sku (String? opcional)
  - Método copyWith() para actualizaciones inmutables
  - Equatable para comparaciones
  - toString() para debugging

- [x] **4.14.2** Actualizar Product entity para soportar variantes
  - Agregar campo: variants (List<ProductVariant>)
  - Agregar getters: hasVariants (bool), totalStock (int)
  - Modificar getters existentes: hasLowStock, isOutOfStock (usan totalStock)
  - Actualizar copyWith() para incluir variants
  - Actualizar props y toString()

- [x] **4.14.3** Crear ProductVariantModel para serialización Firestore
  - Métodos: fromMap(), toMap() para conversión con Firestore
  - Métodos: fromEntity(), toEntity() para conversión con domain
  - Parsing seguro de datos desde Firestore

- [x] **4.14.4** Actualizar ProductModel para soportar variantes
  - Agregar campo: variants (List<ProductVariantModel>)
  - fromFirestore(): Parsear array de variantes desde Firestore
  - toFirestore(): Serializar variantes a array de maps
  - fromEntity(): Convertir variantes de Product a ProductModel
  - toEntity(): Convertir variantes de ProductModel a Product

- [x] **4.14.5** Crear VariantManager widget
  - Gestión completa de variantes: agregar, editar, eliminar
  - Lista visual con cards mostrando color, stock, SKU
  - Cálculo y visualización de stock total
  - Estado vacío con mensaje informativo
  - Callback onVariantsChanged para actualizar parent

- [x] **4.14.6** Crear _VariantDialog para agregar/editar variantes
  - Formulario con validación: colorName* (TextField), stock* (número), sku (opcional)
  - Selector visual de colores con 15 colores predefinidos comunes
  - Indicador visual de color seleccionado (check icon)
  - Parsing seguro de color hex desde/hacia Color
  - Botones: Cancelar, Guardar (rojo con ColorConstants)

- [x] **4.14.7** Integrar VariantManager en AddProductPage
  - Agregar import de variant_manager.dart
  - Agregar estado: _variants (List<ProductVariant>)
  - Cargar variantes existentes en _loadProductData()
  - Integrar VariantManager widget en sección de Inventario
  - Deshabilitar campo stock si hay variantes (enabled: _variants.isEmpty)
  - Actualizar stock automáticamente al cambiar variantes
  - Validación condicional: stock requerido solo si no hay variantes
  - Incluir variants al guardar producto en _saveProduct()
  - Agregar parámetro enabled a _buildTextField()

- [x] **4.14.8** Actualizar ProductDetailPage para mostrar variantes
  - Modificar "Stock Actual" a "Stock Total" cuando hasVariants
  - Usar product.totalStock en lugar de product.stock
  - Agregar sección "Variantes de Color" (solo si hasVariants)
  - Crear método _buildVariantRow() para mostrar cada variante:
    - Container visual con color (40x40px, bordeado, redondeado)
    - Nombre del color (Text bold)
    - Stock de la variante (con icono inventory)
    - SKU de la variante (opcional, con icono qr_code)
    - Layout responsive con Row y Column

- [x] **4.14.9** Actualizar ProductCard para indicar variantes
  - Modificar _buildStockBadge() para usar product.totalStock
  - Agregar badge de variantes (si hasVariants):
    - Ícono palette + número de variantes
    - Color: primaryColor con opacidad
    - Posicionado antes del badge de stock
  - Ajustar texto del badge: "Bajo: X" si hasVariants y hasLowStock
  - Mantener Row para layout horizontal de badges

- [x] **4.14.10** Testing de funcionalidad
  - Compilación exitosa sin errores
  - Product entity con variantes funciona correctamente
  - ProductModel serializa/deserializa variantes correctamente
  - VariantManager permite CRUD completo de variantes
  - AddProductPage gestiona variantes correctamente
  - ProductDetailPage muestra variantes visualmente
  - ProductCard indica presencia de variantes
  - Stock total se calcula correctamente
  - hasLowStock/isOutOfStock usan totalStock

---

## 💰 FASE 5: MÓDULO DE VENTAS
**Objetivo**: Implementar sistema completo de gestión de ventas con Clean Architecture

### 5.1 Entidades de Dominio
- [ ] **5.1.1** Crear `lib/features/sales/domain/entities/sale.dart`
  - Sale class con campos: id, saleNumber, items, subtotal, tax, discount, total, paymentMethod, customerName, customerEmail, customerPhone, notes, soldBy, createdAt, updatedAt
  - PaymentMethod enum (cash, card, transfer, other)
  - SaleStatus enum (completed, cancelled, refunded)
  - Getters: totalItems, itemCount, netProfit
  - Método copyWith() para actualizaciones inmutables

- [ ] **5.1.2** Crear `lib/features/sales/domain/entities/sale_item.dart`
  - SaleItem class con campos: productId, productName, variantColorName, variantColorHex, quantity, unitPrice, unitCost, subtotal, discount
  - Getters: totalPrice, profit
  - Método copyWith() para actualizaciones inmutables
  - Equatable para comparaciones

### 5.2 Modelos de Datos
- [ ] **5.2.1** Crear `lib/features/sales/data/models/sale_item_model.dart`
  - Métodos: fromMap(), toMap() para conversión con Firestore
  - Métodos: fromEntity(), toEntity() para conversión con domain
  - Parsing seguro de datos numéricos

- [ ] **5.2.2** Crear `lib/features/sales/data/models/sale_model.dart`
  - Método fromFirestore() para convertir DocumentSnapshot a SaleModel
  - Método toFirestore() para convertir SaleModel a Map para Firestore
  - Método fromEntity() para convertir Sale a SaleModel
  - Método toEntity() para convertir SaleModel a Sale
  - Parsing seguro de enums (paymentMethod, status)
  - Conversión de array de items con SaleItemModel

### 5.3 Repositorio de Dominio
- [ ] **5.3.1** Crear `lib/features/sales/domain/repositories/sale_repository.dart`
  - Métodos CRUD: createSale, getSaleById, updateSale, deleteSale
  - Métodos de consulta: getAllSales, getSalesByDateRange, getSalesBySeller, getSalesByCustomer
  - Métodos de estadísticas: getTodaySales, getSalesStats, getSalesByPaymentMethod
  - Streams: watchSales, watchTodaySales
  - Clase SalesStats con: totalSales, totalRevenue, totalProfit, averageTicket, salesCount, topProducts

### 5.4 Fuente de Datos Firebase
- [ ] **5.4.1** Crear `lib/features/sales/data/datasources/firebase_sale_datasource.dart`
  - Configurar colección 'sales' en Firestore
  - Implementar addSale() con generación automática de saleNumber (formato: SALE-YYYYMMDD-XXXX)
  - Implementar getAllSales() con ordenamiento por createdAt descendente
  - Implementar getSalesByDateRange() con queries where para timestamps
  - Implementar getTodaySales() filtrando por fecha actual
  - Implementar updateSale() y deleteSale()
  - Implementar streams para actualizaciones en tiempo real
  - Método para actualizar stock de productos al crear venta

### 5.5 Implementación del Repositorio
- [ ] **5.5.1** Crear `lib/features/sales/data/repositories/sale_repository_impl.dart`
  - Implementar todos los métodos de SaleRepository
  - Delegar operaciones al FirebaseSaleDataSource
  - Calcular estadísticas agregadas en getSalesStats()
  - Manejar transacciones para garantizar consistencia de datos
  - Integrar actualización de stock de productos

### 5.6 Casos de Uso
- [ ] **5.6.1** Crear `lib/features/sales/domain/usecases/sale_usecases.dart`
  - CreateSaleUseCase: Crear nueva venta y actualizar stock de productos
  - GetAllSalesUseCase: Obtener lista de todas las ventas
  - GetSaleByIdUseCase: Obtener detalles de una venta específica
  - GetTodaySalesUseCase: Obtener ventas del día actual
  - GetSalesStatsUseCase: Obtener estadísticas de ventas
  - GetSalesByDateRangeUseCase: Filtrar ventas por rango de fechas
  - CancelSaleUseCase: Cancelar venta y revertir stock
  - UpdateSaleUseCase: Actualizar datos de venta (solo antes de completar)

### 5.7 Provider de Ventas
- [ ] **5.7.1** Crear `lib/features/sales/presentation/providers/sales_provider.dart`
  - Enum SalesState (initial, loading, loaded, error, creating, updating)
  - Propiedades: sales (List<Sale>), stats (SalesStats), selectedDateRange, errorMessage
  - Métodos de carga: loadSales(), loadTodaySales(), loadSalesByDateRange(start, end)
  - Métodos CRUD: createSale(sale), updateSale(sale), cancelSale(saleId)
  - Método loadStats() para estadísticas
  - Método getSaleById(id) para obtener detalles
  - Manejo de estados y errores con try-catch

- [ ] **5.7.2** Crear `lib/features/sales/presentation/providers/sale_cart_provider.dart`
  - Gestión del carrito de venta temporal
  - Propiedades: items (List<SaleItem>), customer (CustomerInfo), paymentMethod, discount, notes
  - Métodos: addItem(), removeItem(), updateQuantity(), clearCart()
  - Getters calculados: subtotal, taxAmount, discountAmount, total, itemCount
  - Validaciones: stock disponible, cantidades mínimas
  - Método buildSale() para crear entity Sale desde el carrito

### 5.8 Widgets de Ventas
- [ ] **5.8.1** Crear `lib/features/sales/presentation/widgets/sale_card.dart`
  - Card para lista de ventas con información resumida
  - Mostrar: número de venta, fecha/hora, total, método de pago, cliente
  - Badge de estado (completada, cancelada, reembolsada)
  - Iconos según método de pago (efectivo, tarjeta, transferencia)
  - Callback onTap para ver detalles
  - Diseño responsive con colores distintivos

- [ ] **5.8.2** Crear `lib/features/sales/presentation/widgets/sale_item_card.dart`
  - Card para items dentro del carrito/detalle de venta
  - Mostrar: nombre producto, variante (si aplica), cantidad, precio unitario, subtotal
  - Indicador visual de color de variante
  - Botones para ajustar cantidad (+/-)
  - Botón eliminar item
  - Mostrar descuento si aplica

- [ ] **5.8.3** Crear `lib/features/sales/presentation/widgets/product_selector.dart`
  - Widget para buscar y seleccionar productos
  - Barra de búsqueda con filtrado en tiempo real
  - Lista de productos disponibles con stock
  - Mostrar variantes de color si el producto las tiene
  - Selector de cantidad con validación de stock
  - Botón "Agregar al carrito"
  - Indicadores visuales de stock bajo/agotado

- [ ] **5.8.4** Crear `lib/features/sales/presentation/widgets/payment_method_selector.dart`
  - Selector visual de métodos de pago
  - Chips/Cards con iconos para cada método (cash, card, transfer, other)
  - Estado seleccionado visual
  - Callback onChange

- [ ] **5.8.5** Crear `lib/features/sales/presentation/widgets/sales_stats_card.dart`
  - Tarjeta de estadísticas con iconos
  - Mostrar: ventas totales, ingresos, ganancia, ticket promedio
  - Formato de números con separadores de miles
  - Colores distintivos por tipo de métrica
  - Animaciones opcionales

### 5.9 Pantallas de Ventas
- [ ] **5.9.1** Crear `lib/features/sales/presentation/pages/sales_page.dart`
  - AppBar con título "Ventas" y acciones (filtros, estadísticas)
  - Panel de estadísticas del día (SalesStatsCard)
  - Pestañas/Segmentos: "Hoy", "Esta Semana", "Este Mes", "Todas"
  - Lista de ventas usando SaleCard
  - Pull-to-refresh para recargar datos
  - Estados: loading, error, empty
  - FAB para crear nueva venta (navegar a NewSalePage)
  - Selector de rango de fechas personalizado

- [ ] **5.9.2** Crear `lib/features/sales/presentation/pages/new_sale_page.dart`
  - AppBar con título "Nueva Venta" y botón cancelar
  - Sección de productos: ProductSelector integrado
  - Lista de items en carrito (SaleItemCard)
  - Panel de resumen: subtotal, descuento, impuesto, total
  - Sección de cliente (opcional): nombre, email, teléfono
  - PaymentMethodSelector
  - Campo de descuento (porcentaje o monto fijo)
  - Campo de notas adicionales
  - Botón "Completar Venta" (validación de carrito no vacío)
  - Diálogo de confirmación antes de guardar
  - Navegación a detalle de venta al completar

- [ ] **5.9.3** Crear `lib/features/sales/presentation/pages/sale_detail_page.dart`
  - AppBar con título "Detalle de Venta #XXXX"
  - Header con información general: fecha, hora, vendedor, estado
  - Sección de cliente (si existe)
  - Lista de items vendidos (SaleItemCard en modo solo lectura)
  - Resumen financiero: subtotal, descuento, impuesto, total
  - Método de pago con icono
  - Notas adicionales (si existen)
  - Botón "Cancelar Venta" (solo si status = completed y fecha < 24h)
  - Botón "Compartir" (futuro: generar PDF/recibo)
  - Integración con DateFormat para fechas
  - Integración con NumberFormat para montos

### 5.10 Integración con Actividades Recientes
- [ ] **5.10.1** Actualizar `lib/features/home/domain/entities/activity.dart`
  - Agregar ActivityType: saleCreated, saleCancelled, saleRefunded
  - Agregar campos opcionales para ventas: saleId, saleNumber, saleTotal, saleItems

- [ ] **5.10.2** Actualizar `lib/features/home/data/datasources/firebase_activity_datasource.dart`
  - Método logSaleActivity() para registrar venta
  - Formato de mensaje: "Venta #SALE-XXX realizada por $userName - Total: $XX.XX"
  - Incluir datos relevantes: número de venta, total, cantidad de items, método de pago

- [ ] **5.10.3** Integrar registro de actividad en CreateSaleUseCase
  - Llamar a logSaleActivity() después de crear venta exitosamente
  - Manejar errores sin bloquear la creación de venta
  - Registrar también cancelaciones de venta

### 5.11 Actualización de Stock
- [ ] **5.11.1** Crear lógica de reducción de stock en FirebaseSaleDataSource
  - Al crear venta: reducir stock de cada producto/variante vendido
  - Usar transacciones de Firestore para garantizar atomicidad
  - Validar stock disponible antes de confirmar venta
  - Revertir stock al cancelar venta

- [ ] **5.11.2** Manejar productos con variantes
  - Reducir stock de la variante específica seleccionada
  - Si producto no tiene variantes, reducir stock general
  - Actualizar campo totalStock del producto
  - Validar que hasLowStock y isOutOfStock se actualicen correctamente

### 5.12 Configuración e Integración
- [ ] **5.12.1** Configurar SalesProvider en `lib/main.dart`
  - Agregar imports de sales (SalesProvider, SaleRepository, etc.)
  - Crear instancias de saleDataSource y saleRepository
  - Agregar ChangeNotifierProvider<SalesProvider> al MultiProvider
  - Agregar ChangeNotifierProvider<SaleCartProvider> al MultiProvider
  - Inyectar los casos de uso necesarios

- [ ] **5.12.2** Actualizar rutas en `lib/config/routes/app_routes.dart`
  - Cambiar ruta '/camera' por '/sales' con SalesPage
  - Agregar ruta '/sales/new' con NewSalePage
  - Agregar ruta '/sales/:id' con SaleDetailPage (parámetro saleId)
  - Actualizar navegación del BottomNavigationBar

- [ ] **5.12.3** Actualizar `lib/features/home/presentation/pages/main_layout.dart`
  - Cambiar icono y label de "Cámara" a "Ventas"
  - Usar icono: Icons.point_of_sale o Icons.shopping_cart
  - Actualizar índice de navegación
  - Remover imports de camera_page.dart
  - Agregar imports de sales_page.dart

- [ ] **5.12.4** Actualizar reglas de Firestore para colección sales
  ```javascript
  match /sales/{saleId} {
    allow read: if request.auth != null;
    allow create: if request.auth != null && 
      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager', 'employee'];
    allow update, delete: if request.auth != null && 
      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager'];
  }
  ```

### 5.13 Características Adicionales
- [ ] **5.13.1** Implementar generación de número de venta único
  - Formato: SALE-YYYYMMDD-0001
  - Autoincremental por día
  - Consultar último número del día en Firestore
  - Manejar concurrencia con transacciones

- [ ] **5.13.2** Implementar cálculo de impuestos
  - Configurar porcentaje de impuesto (configurable)
  - Aplicar a subtotal después de descuento
  - Mostrar desglose en resumen de venta

- [ ] **5.13.3** Implementar validaciones de negocio
  - Stock disponible antes de agregar al carrito
  - Cantidades mínimas (>0) y máximas (stock disponible)
  - Total de venta > 0
  - Al menos un item en carrito para completar venta
  - Validar que productos existan y estén activos

- [ ] **5.13.4** Implementar búsqueda y filtros de ventas
  - Buscar por número de venta
  - Filtrar por rango de fechas
  - Filtrar por método de pago
  - Filtrar por vendedor
  - Filtrar por cliente

### 5.14 Documentación y Pruebas
- [ ] **5.14.1** Crear `doc/sales_module.md` con documentación completa
  - Arquitectura del módulo (Domain, Data, Presentation)
  - Flujo de creación de venta paso a paso
  - Estructura de datos en Firestore
  - Diagramas de flujo
  - Manejo de transacciones y stock
  - Integración con productos y actividades

- [ ] **5.14.2** Actualizar CHANGELOG.md con cambios de FASE 5
  - Sección con módulo de ventas completo
  - Detalles de funcionalidades
  - Cambios en navegación (camera → sales)
  - Integración con sistema de actividades

- [ ] **5.14.3** Testing de funcionalidad
  - Compilación exitosa sin errores
  - Creación de venta reduce stock correctamente
  - Cancelación de venta revierte stock
  - Estadísticas calculan correctamente
  - Validaciones de stock funcionan
  - Registro en actividades recientes funciona
  - Navegación entre pantallas funciona
  - Estados loading/error/empty se muestran correctamente
  - Formato de números y fechas correcto

- [ ] **5.14.4** Actualizar README.md
  - Agregar módulo de Ventas en características
  - Actualizar capturas de pantalla
  - Documentar funcionalidades de ventas
  - Actualizar guía de uso

