# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Añadido
- **FASE 4: Módulo completo de Gestión de Productos**
  - **Capa de Dominio:**
    - `Product` entity con 20+ campos (nombre, precio, stock, categoría, barcode, SKU, imágenes, etc.)
    - `ProductCategory` enum con 10 categorías (Electronics, Clothing, Food, Beverages, etc.)
    - `ProductStatus` enum (Active, Inactive, Discontinued)
    - `ProductRepository` interface con 15+ métodos (CRUD, búsqueda, filtros, estadísticas)
    - 8 Use Cases: CreateProduct, UpdateProduct, DeleteProduct, GetAllProducts, SearchProducts, GetProductsByCategory, GetLowStockProducts, GetProductStats
  - **Capa de Datos:**
    - `ProductModel` con conversión bidireccional entre Firestore y entidad
    - `FirebaseProductDataSource` con operaciones completas de Firebase
    - `ProductRepositoryImpl` con implementación de todos los métodos
    - Real-time streams para actualizaciones en vivo
    - Client-side filtering para búsqueda (workaround de limitaciones de Firestore)
  - **Capa de Presentación:**
    - `ProductsProvider` con gestión de estado completa (loading, loaded, error)
    - `ProductsPage` - Lista de productos con búsqueda, filtros, estadísticas y pull-to-refresh
    - `AddProductPage` - Formulario completo para agregar/editar productos con validación
    - `ProductDetailPage` - Vista detallada con toda la información del producto
    - `ProductCard` - Widget reutilizable para mostrar productos en lista
    - `CategorySelector` - Selector horizontal de categorías con FilterChips
  - **Funcionalidades:**
    - CRUD completo de productos (Crear, Leer, Actualizar, Eliminar)
    - Búsqueda de productos por nombre o descripción
    - Filtrado por categoría
    - Alertas de stock bajo/agotado
    - Cálculo automático de margen de ganancia
    - Estadísticas rápidas (total productos, stock bajo, agotados)
    - Integración con ThemeProvider para modo oscuro
  - **Configuración:**
    - ProductsProvider agregado a MultiProvider en main.dart
    - Rutas configuradas en app_routes.dart
    - Clean Architecture completa con separación de capas

- **Modo oscuro completo con persistencia**
  - `ThemeProvider` para gestionar el estado del tema
  - Tres modos: Claro, Oscuro y Automático (Sistema)
  - Persistencia del tema seleccionado usando SharedPreferences
  - Widgets reutilizables para cambio de tema:
    - `ThemeToggleButton` - Botón simple de toggle
    - `ThemeSelector` - Selector con opciones de radio
    - `ThemeDialog` - Diálogo completo para cambiar tema
    - `ThemeSwitch` - Switch para alternar modo oscuro
    - `ThemeSettingsTile` - ListTile para página de configuración
  - Integración en páginas principales:
    - HomePage con botón de tema en AppBar
    - AdminUsersPage con botón de tema en AppBar
  - Tema oscuro completo en `AppTheme.darkTheme`
  - Documentación completa en `DARK_MODE_DOCUMENTATION.md`

### Eliminado
- **Funcionalidad de auto-registro removida completamente**
- `RegisterPage` eliminada de la aplicación
- Enlace "Crear cuenta" removido de `LoginPage`
- `register_usecase.dart` eliminado del dominio
- Método `register()` eliminado de `AuthProvider`
- Método `registerWithEmailAndPassword()` eliminado de `FirebaseAuthDataSource`
- Método `registerWithEmailAndPassword()` eliminado de `AuthRepository` y `AuthRepositoryImpl`
- Ruta `/register` eliminada de `app_routes.dart`
- Documentación de auto-registro actualizada en `ACCESS_GUIDE.md`, `FAQ.md` y `README.md`

### Añadido
- Widget reutilizable `AppLogo` para mostrar el logo de la aplicación
- Integración de assets de imágenes (logo transparente y logo blanco)
- Logo personalizado en todas las pantallas de la aplicación:
  - Splash screen con logo prominente
  - Login page con logo en header
  - Forgot password page con logo condicional
  - Home page con logo en sección de bienvenida
  - Navigation drawer en desktop con logo en header
- Sistema de navegación adaptativa con soporte para móvil, tablet y desktop
- Bottom Navigation Bar para dispositivos móviles (< 600px)
- Navigation Rail para tablets (600-1200px)
- Navigation Drawer persistente para desktop (> 1200px)
- Configuración completa de deep linking para Android e iOS
- Soporte para Custom URL Scheme (`stockletushops://`)
- Soporte para Universal Links/App Links (`https://letushops.com`)
- Página principal (Home) con dashboard interactivo
- Página de productos con estado vacío y FAB
- Página de cámara (preparada para integración ML Kit)
- Página de inventario con resumen de estadísticas
- Página de reportes con selector de tipos
- Página de perfil mejorada con información del usuario
- Página de configuración con opciones de personalización
- Documentación completa del sistema de navegación (`doc/navigation_system.md`)
- Documentación completa de deep linking (`doc/deep_linking.md`)
- Preservación de estado en navegación entre páginas principales

### Modificado
- **Sistema de autenticación:** Ahora solo permite login con credenciales creadas en Firebase Console
- **Documentación actualizada:** `ACCESS_GUIDE.md`, `FAQ.md` y `README.md` reflejan el nuevo flujo de gestión de usuarios
- `pubspec.yaml` actualizado con assets de imágenes del logo
- Todas las pantallas de autenticación ahora usan el logo real de la aplicación
- Splash screen mejorado con logo corporativo y mejores sombras
- Navigation Drawer con logo profesional en lugar de icono genérico
- HomePage con logo en tarjeta de bienvenida
- `lib/config/routes/app_routes.dart` actualizado para usar `StatefulShellRoute`
- Reorganización de rutas principales en branches separadas
- Mejora de transiciones entre páginas con animaciones suaves
- `android/app/src/main/AndroidManifest.xml` con intent-filters para deep linking
- `ios/Runner/Info.plist` con configuración de Universal Links
- Páginas placeholder convertidas en componentes funcionales
- Separación de páginas en archivos individuales por feature

### Técnico
- Creación de widget `AppLogo` con múltiples constructores (normal, circular, simple)
- Soporte para dos variantes de logo (transparente y blanco)
- Implementación de `StatefulShellRoute.indexedStack` para gestión de estado
- Uso de `LayoutBuilder` para navegación responsive
- Integración de Material 3 Navigation components
- Configuración de App Links verification para Android
- Configuración de Associated Domains para iOS

---

## [0.1.0] - 2024-11-02

### Añadido
- Sistema completo de autenticación con Firebase
- Login con email y password
- Registro de nuevos usuarios
- Recuperación de contraseña
- Persistencia de sesión
- Rutas protegidas con RouteGuard
- Tema personalizado con paleta rojo-blanco-negro
- Tema claro y oscuro
- Configuración inicial de GoRouter
- Página de splash con animación
- Provider para gestión de estado de autenticación
- Validación de formularios
- Widgets personalizados de autenticación

### Configuración
- Proyecto Flutter inicializado
- Firebase Core configurado
- Firebase Authentication habilitado
- Cloud Firestore configurado
- Firebase Storage configurado
- Estructura de carpetas según Clean Architecture
- Dependencias base instaladas

### Documentación
- README principal del proyecto
- README_TASKS con roadmap técnico completo
- Documentación de autenticación (`doc/authentication/`)
- Instrucciones de Clean Architecture

---

## Estructura de Versiones

### [No Publicado]
Cambios que están en desarrollo pero no han sido lanzados.

### [0.1.0] - 2024-11-02
Primera versión funcional con autenticación y navegación básica.

---

## Tipos de Cambios

- **Añadido**: para nuevas funcionalidades
- **Modificado**: para cambios en funcionalidades existentes
- **Obsoleto**: para funcionalidades que pronto serán removidas
- **Eliminado**: para funcionalidades removidas
- **Corregido**: para corrección de bugs
- **Seguridad**: en caso de vulnerabilidades
- **Técnico**: para cambios técnicos internos
- **Configuración**: para cambios en configuración del proyecto

---

## Próximas Versiones Planeadas

### [0.2.0] - Gestión de Productos (Planeado)
- CRUD completo de productos
- Búsqueda y filtros avanzados
- Subida de imágenes a Firebase Storage
- Categorización de productos
- Sistema de características de productos

### [0.3.0] - Módulo de Cámara e IA (Planeado)
- Captura de fotos con cámara
- Integración con Google ML Kit
- Text Recognition (OCR)
- Object Detection
- Label Detection
- Análisis automático de productos
- Sugerencias basadas en IA

### [0.4.0] - Gestión de Inventario (Planeado)
- Control de stock en tiempo real
- Movimientos de inventario
- Alertas de stock bajo
- Historial de movimientos
- Ajustes de inventario

### [0.5.0] - Reportes y Estadísticas (Planeado)
- Dashboard de analytics
- Gráficos interactivos
- Reportes de ventas
- Reportes de inventario
- Exportación de datos (PDF/Excel)
- KPIs en tiempo real

### [1.0.0] - Release Producción (Planeado)
- Optimización de performance
- Modo offline completo
- Tests completos (unit, widget, integration)
- Seguridad reforzada
- Accesibilidad completa
- Soporte multi-idioma
- CI/CD configurado
- Publicación en stores

---

## Historial de Desarrollo

### Fase 1: Configuración Base ✅ Completada
- Entorno de desarrollo configurado
- Firebase inicializado
- Estructura de proyecto establecida
- Dependencias instaladas

### Fase 2: Autenticación ✅ Completada
- Sistema de autenticación implementado
- Páginas de login/registro
- Gestión de estado con Provider
- Rutas protegidas funcionando

### Fase 3: Núcleo de la Aplicación 🚧 En Progreso
- [x] Temas configurados
- [x] Sistema de rutas con GoRouter
- [x] Navegación responsive implementada
- [x] Deep linking configurado
- [ ] Pantalla principal y navegación completa
- [ ] Widgets base compartidos
- [ ] Servicios base

### Fase 4: Gestión de Productos 📋 Pendiente
### Fase 5: Módulo de Cámara e IA 📋 Pendiente
### Fase 6: Gestión de Inventario 📋 Pendiente
### Fase 7: Reportes y Estadísticas 📋 Pendiente
### Fase 8: Optimización y Pulido 📋 Pendiente

---

## Colaboradores

- **Galva Developer** - Desarrollo principal

---

## Notas de Desarrollo

### Decisiones Técnicas

**¿Por qué StatefulShellRoute?**
- Permite preservar el estado de cada página
- Mejor experiencia de usuario al navegar
- Evita recargas innecesarias de datos

**¿Por qué navegación adaptativa?**
- Maximiza la usabilidad en cada tipo de dispositivo
- Sigue las guías de Material Design 3
- Proporciona mejor UX según el tamaño de pantalla

**¿Por qué Clean Architecture?**
- Separación clara de responsabilidades
- Código más mantenible y testeable
- Facilita el trabajo en equipo
- Escalabilidad del proyecto

### Convenciones

- Nombres de archivos en `snake_case`
- Nombres de clases en `PascalCase`
- Commits siguiendo Conventional Commits
- Branches: `feature/`, `bugfix/`, `hotfix/`

---

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo LICENSE para más detalles.

---

## Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
