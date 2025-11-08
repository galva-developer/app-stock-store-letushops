# 📱 Stock LetuShops

**Aplicación móvil inteligente para la gestión de inventario de LETUSHOPS**

Una aplicación Flutter revolucionaria que optimiza la gestión de stock mediante el reconocimiento automático de productos a través de fotografías, integrando inteligencia artificial para extraer características y almacenarlas en una base de datos NoSQL en Firebase.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

## 🚀 Características Principales

### � Gestión Completa de Productos
- **CRUD Completo**: Crear, leer, actualizar y eliminar productos
- **Variantes de Color**: Gestión de stock independiente por color
- **Categorización**: 10 categorías predefinidas (Electrónica, Ropa, Alimentos, etc.)
- **Estados de Producto**: Activo, Inactivo, Descontinuado
- **Búsqueda Avanzada**: Filtrado por nombre, descripción y categoría
- **Alertas Inteligentes**: Notificaciones de stock bajo o agotado
- **Gestión de Precios**: Precio de venta, costo y cálculo automático de margen
- **Identificación**: SKU y código de barras
- **Metadatos**: Marca, fabricante, etiquetas personalizadas

### 💰 Sistema de Ventas (En Desarrollo)
- **Punto de Venta Completo**: Interfaz intuitiva para realizar ventas
- **Carrito de Compras**: Selección de productos con variantes
- **Métodos de Pago**: Efectivo, tarjeta, transferencia
- **Actualización Automática**: Stock se reduce al completar venta
- **Numeración Automática**: Formato SALE-YYYYMMDD-XXXX
- **Datos de Cliente**: Información opcional del comprador
- **Estadísticas**: Ventas diarias, semanales y mensuales
- **Cancelación de Ventas**: Reversión de stock incluida

### 📊 Sistema de Actividades Recientes
- **Registro Automático**: Todas las acciones importantes se registran
- **Timeline en Tiempo Real**: Actualización instantánea de actividades
- **Tipos de Actividad**: Productos, ventas, usuarios, stock
- **Información Detallada**: Usuario, timestamp y metadata

### 👥 Sistema de Roles y Permisos
- **Administrador**: Acceso completo, gestión de usuarios
- **Manager**: Gestión de inventario y reportes
- **Employee**: Operaciones básicas de productos y ventas
- **Panel de Administración**: Control completo de usuarios

### �📸 Gestión de Stock Inteligente (Próximamente)
- **Fotografía Automática**: Captura productos con la cámara del dispositivo
- **Reconocimiento IA**: Extracción automática de características del producto
- **Carga Rápida**: Proceso optimizado de menos de 30 segundos por producto
- **Sincronización en Tiempo Real**: Actualización instantánea del inventario

### 🔥 Tecnologías Implementadas
- **Frontend**: Flutter (Dart) - Multiplataforma (iOS/Android)
- **Backend**: Firebase (Firestore NoSQL Database)
- **Almacenamiento**: Firebase Storage para imágenes
- **IA/ML**: Integración con servicios de reconocimiento de imágenes
- **Autenticación**: Firebase Authentication

### 📊 Funcionalidades del Sistema
- ✅ **Gestión completa de productos con variantes de color**
- ✅ **Sistema de ventas (punto de venta)**
- ✅ **Búsqueda avanzada y filtros por categoría**
- ✅ **Registro de actividades recientes en tiempo real**
- ✅ **Alertas de stock bajo y agotado**
- ✅ **Estadísticas de productos y ventas**
- ✅ **Interfaz intuitiva y responsiva**
- ✅ **Sistema de roles y permisos**
- ✅ **Panel de administración de usuarios**
- ✅ **Modo oscuro con persistencia**
- ✅ **Cálculo automático de márgenes de ganancia**
- ✅ **Soporte para múltiples métodos de pago**
- 🚧 **Historial de movimientos de inventario** (En desarrollo)
- 🚧 **Reportes avanzados y exportación** (En desarrollo)

## 🏗️ Arquitectura del Proyecto

```
📦 Stock LetuShops
├── 📱 Frontend (Flutter)
│   ├── � Módulo de Autenticación
│   │   ├── Login/Logout
│   │   ├── Recuperación de contraseña
│   │   └── Sistema de roles (Admin/Manager/Employee)
│   ├── 📦 Módulo de Productos
│   │   ├── CRUD completo
│   │   ├── Variantes de color con stock independiente
│   │   ├── Búsqueda y filtros
│   │   └── Estadísticas
│   ├── 💰 Módulo de Ventas
│   │   ├── Carrito de compras
│   │   ├── Punto de venta (POS)
│   │   ├── Múltiples métodos de pago
│   │   └── Actualización de stock
│   ├── � Sistema de Actividades
│   │   ├── Registro automático
│   │   └── Timeline en tiempo real
│   ├── 👥 Panel de Administración
│   │   ├── Gestión de usuarios
│   │   ├── Cambio de roles
│   │   └── Estadísticas de usuarios
│   └── 🎨 Temas y UI
│       ├── Modo claro/oscuro
│       └── Paleta rojo-blanco-negro
├── ☁️ Backend (Firebase)
│   ├── 🔥 Firestore Database
│   │   ├── Colección users
│   │   ├── Colección products
│   │   ├── Colección sales
│   │   └── Colección activity_logs
│   ├── 📦 Storage (imágenes)
│   └── 🔐 Authentication
└── 🤖 Servicios IA (Próximamente)
    ├── 👁️ Reconocimiento de Imágenes
    ├── 📝 Extracción de Texto (OCR)
    └── 🏷️ Clasificación de Productos
```

## 🛠️ Instalación y Configuración

### Prerrequisitos
```bash
# Flutter SDK (versión >= 3.7.2)
flutter --version

# Dart SDK incluido con Flutter
dart --version
```

### Configuración del Proyecto

1. **Clonar el repositorio**
```bash
git clone https://github.com/galva-developer/stock_letu_shops.git
cd stock_letu_shops
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Configurar FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Ejecutar la aplicación**
```bash
# Para Android
flutter run

# Para iOS
flutter run -d ios

# Para Web (desarrollo)
flutter run -d chrome
```

## 🔐 Primer Acceso y Sistema de Roles

### Jerarquía de Usuarios

La aplicación cuenta con un **sistema de roles jerárquico** con tres niveles de permisos:

#### 🔴 Administrador (Admin)
- **Acceso completo** al sistema
- Gestión de usuarios (crear, editar, eliminar)
- Cambio de roles y estados de usuarios
- Acceso al panel de administración
- Todas las funciones de Manager y Employee

#### 🔵 Manager (Gerente)
- Gestión completa de inventario
- Acceso a reportes avanzados
- Supervisión de empleados
- Gestión de productos y stock
- Todas las funciones de Employee

#### ⚪ Employee (Empleado)
- Operaciones básicas de inventario
- Captura de productos con cámara
- Consulta de stock
- Actualización de productos asignados

### Crear tu Usuario en Firebase Console

**Todos los usuarios deben ser creados por el administrador desde Firebase Console:**

1. **Ve a [Firebase Console](https://console.firebase.google.com/)**
2. **Selecciona tu proyecto** (stock-letu-shops)
3. **Navega a Authentication > Users**
4. **Haz clic en "Add user"**
5. **Crea el usuario:**
   - Email: admin@letushops.com
   - Password: password
6. **Configura el rol en Firestore:**
   - Ve a Firestore Database
   - Navega a la colección `users`
   - Encuentra el documento con el UID del usuario creado
   - Agrega/edita el campo `role` con valor `admin`
7. **Inicia sesión en la app** con estas credenciales

### Flujo de Acceso

1. **Verás la pantalla de Splash** (2 segundos)
2. **Serás redirigido a Login**
3. **Ingresa tus credenciales** creadas en Firebase Console
4. **¡Listo!** Ya tienes acceso completo

### Credenciales de Administrador Principal

```
📧 Email: admin@letushops.com
🔑 Password: [Configura tu propia contraseña segura]
👑 Rol: Administrador
```

> **🎯 ACCESO DE ADMINISTRADOR:** 
> Al iniciar sesión con un usuario que tenga `role: "admin"` en Firestore, serás redirigido automáticamente al **Panel de Administración de Usuarios** donde podrás:
> - ➕ **Registrar nuevos usuarios** (Empleados y Gerentes)
> - 👀 Ver todos los usuarios registrados
> - 🔄 Cambiar roles de usuarios (Employee ↔ Manager ↔ Admin)
> - 🎭 Cambiar estados (Activo, Suspendido, Inactivo)
> - 🗑️ Eliminar usuarios
> - 🔍 Filtrar y buscar usuarios
> - 📊 Ver estadísticas en tiempo real
>
> 📖 **Consulta la [Guía de Registro de Usuarios](USER_REGISTRATION_GUIDE.md)** para instrucciones detalladas

### Credenciales de Prueba Adicionales

```
👤 Manager de Prueba:
📧 Email: manager@letushops.com
🔑 Password: [Configura tu propia contraseña]

👤 Empleado de Prueba:
📧 Email: empleado@letushops.com
🔑 Password: [Configura tu propia contraseña]
```

> 🔒 **Seguridad:** Las contraseñas no se almacenan en el código fuente.
> Todos los usuarios deben ser creados en Firebase Authentication y
> configurados en Firestore con el rol correspondiente.

> ⚠️ **IMPORTANTE:** No existe opción de auto-registro en la aplicación.
> Todos los usuarios deben ser creados desde Firebase Console por el administrador.
> 
> 📖 Ver **[ACCESS_GUIDE.md](./ACCESS_GUIDE.md)** para instrucciones detalladas.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── core/                     # Funcionalidades centrales
│   ├── constants/           # Constantes globales (colores, configuración)
│   ├── utils/              # Utilidades y helpers
│   └── services/           # Servicios base
├── features/               # Características principales (Clean Architecture)
│   ├── authentication/    # ✅ Módulo de autenticación
│   │   ├── domain/       # Entidades, repositorios, casos de uso
│   │   ├── data/         # Modelos, datasources, repositorios impl
│   │   └── presentation/ # Páginas, widgets, providers
│   ├── products/         # ✅ Gestión de productos
│   │   ├── domain/       # Product, ProductVariant, repository
│   │   ├── data/         # ProductModel, Firebase datasource
│   │   └── presentation/ # ProductsPage, AddProductPage, widgets
│   ├── sales/            # 🚧 Módulo de ventas (En desarrollo)
│   │   ├── domain/       # Sale, SaleItem, repository
│   │   ├── data/         # SaleModel, Firebase datasource
│   │   └── presentation/ # SalesPage, NewSalePage, cart
│   ├── home/             # ✅ Pantalla principal y actividades
│   │   ├── domain/       # ActivityLog entity
│   │   ├── data/         # ActivityLog datasource
│   │   └── presentation/ # HomePage, widgets
│   ├── inventory/        # 📋 Gestión de inventario (Planeado)
│   └── reports/          # 📋 Reportes y estadísticas (Planeado)
├── shared/               # Componentes compartidos
│   ├── widgets/         # Widgets reutilizables (AppLogo, ThemeWidgets)
│   ├── models/          # Modelos de datos compartidos
│   └── providers/       # Gestores de estado (ThemeProvider)
└── config/              # Configuraciones
    ├── routes/          # Rutas de navegación (GoRouter)
    ├── themes/          # Temas y estilos (claro/oscuro)
    └── firebase/        # Configuración Firebase
```

## 🔧 Configuración de Firebase

### 1. Firestore Database
```javascript
// Estructura de la base de datos

// Colección de usuarios
users: {
  userId: {
    email: string,
    displayName: string,
    photoURL: string,
    emailVerified: boolean,
    role: string,              // 'admin', 'manager', 'employee'
    status: string,            // 'active', 'suspended', 'inactive'
    creationTime: timestamp,
    lastSignInTime: timestamp,
    updatedAt: timestamp,
  }
}

// Colección de productos
products: {
  productId: {
    name: string,
    description: string,
    category: string,          // 'electronics', 'clothing', 'food', etc.
    status: string,            // 'active', 'inactive', 'discontinued'
    price: number,
    costPrice: number,
    stock: number,
    minStock: number,
    sku: string,
    barcode: string,
    brand: string,
    manufacturer: string,
    tags: [string],
    images: [string],
    variants: [               // Variantes de color con stock independiente
      {
        colorName: string,
        colorHex: string,
        stock: number,
        sku: string,
      }
    ],
    createdBy: string,
    createdAt: timestamp,
    updatedAt: timestamp
  }
}

// Colección de ventas
sales: {
  saleId: {
    saleNumber: string,        // 'SALE-YYYYMMDD-0001'
    items: [
      {
        productId: string,
        productName: string,
        variantColorName: string,
        variantColorHex: string,
        quantity: number,
        unitPrice: number,
        unitCost: number,
        subtotal: number,
        discount: number,
      }
    ],
    subtotal: number,
    tax: number,
    discount: number,
    total: number,
    paymentMethod: string,     // 'cash', 'card', 'transfer', 'other'
    status: string,            // 'completed', 'cancelled', 'refunded'
    customerName: string,
    customerEmail: string,
    customerPhone: string,
    notes: string,
    soldBy: string,
    createdAt: timestamp,
    updatedAt: timestamp
  }
}

// Colección de actividades
activity_logs: {
  activityId: {
    type: string,              // 'productCreated', 'saleCreated', etc.
    userId: string,
    userName: string,
    userEmail: string,
    description: string,
    metadata: {
      productId: string,
      productName: string,
      saleId: string,
      saleNumber: string,
      // ... más metadata según tipo
    },
    timestamp: timestamp
  }
}
```

### 2. Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{productId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 3. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function para verificar si el usuario está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function para verificar el rol del usuario
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    // Helper function para verificar si es admin
    function isAdmin() {
      return isAuthenticated() && getUserRole() == 'admin';
    }
    
    // Helper function para verificar si es manager o admin
    function isManagerOrAdmin() {
      return isAuthenticated() && (getUserRole() == 'admin' || getUserRole() == 'manager');
    }
    
    // Reglas para usuarios (solo admins pueden escribir)
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Reglas para productos (managers y admins pueden escribir)
    match /products/{productId} {
      allow read: if isAuthenticated();
      allow write: if isManagerOrAdmin();
    }
    
    // Reglas para ventas (todos pueden crear, managers/admins pueden modificar)
    match /sales/{saleId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if isManagerOrAdmin();
    }
    
    // Reglas para actividades (todos pueden crear, solo admins pueden eliminar)
    match /activity_logs/{activityId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update, delete: if isAdmin();
    }
    }
  }
}
```

## 🤖 Integración de IA (Próximamente)

### Servicios de Reconocimiento Planeados
- **Google ML Kit**: Reconocimiento de texto (OCR)
- **TensorFlow Lite**: Clasificación de productos
- **Cloud Vision API**: Análisis avanzado de imágenes

### Flujo de Procesamiento
1. 📸 **Captura** → Usuario toma foto del producto
2. 🔍 **Análisis** → IA extrae características visibles
3. 📝 **OCR** → Extracción de texto de etiquetas/códigos
4. 🏷️ **Clasificación** → Identificación de categoría de producto
5. 💾 **Almacenamiento** → Guardado automático en Firestore

## 📱 Capturas de Pantalla

| Pantalla Principal | Productos | Gestión de Ventas |
|:--:|:--:|:--:|
| ![Home](assets/screenshots/home.png) | ![Products](assets/screenshots/products.png) | ![Sales](assets/screenshots/sales.png) |

## 🚀 Roadmap

### Versión 0.2.0 - Gestión de Productos ✅ COMPLETADO
- [x] CRUD completo de productos
- [x] Sistema de variantes de color con stock independiente
- [x] Búsqueda y filtros por categoría
- [x] Alertas de stock bajo/agotado
- [x] Estadísticas en tiempo real
- [x] Integración con actividades recientes
- [x] Gestión de precios y márgenes
- [x] Validaciones completas

### Versión 0.3.0 - Módulo de Ventas 🚧 EN DESARROLLO
- [x] Sistema de roles (Admin, Manager, Employee)
- [x] Panel de administración de usuarios
- [x] **Modo oscuro con persistencia**
- [x] Sistema de actividades recientes
- [ ] Punto de venta completo
- [ ] Carrito de compras
- [ ] Actualización automática de stock
- [ ] Múltiples métodos de pago
- [ ] Estadísticas de ventas

### Versión 0.4.0 - Módulo de Cámara e IA (Planeado)
- [ ] Captura de fotos con cámara
- [ ] Integración con Google ML Kit
- [ ] Text Recognition (OCR)
- [ ] Object Detection
- [ ] Label Detection
- [ ] Análisis automático de productos

### Versión 0.5.0 - Gestión de Inventario (Planeado)
- [ ] Control de stock en tiempo real
- [ ] Movimientos de inventario
- [ ] Alertas de stock bajo
- [ ] Historial de movimientos
- [ ] Ajustes de inventario
- [ ] Transferencias entre ubicaciones

### Versión 0.6.0 - Reportes y Estadísticas (Planeado)
- [ ] Dashboard de analytics
- [ ] Gráficos interactivos
- [ ] Reportes de ventas
- [ ] Reportes de inventario
- [ ] Exportación de datos (PDF/Excel)
- [ ] KPIs en tiempo real

### Versión 1.0.0 - Release Producción (Futuro)
### Versión 1.0.0 - Release Producción (Futuro)
- [ ] Optimización de performance
- [ ] Modo offline completo
- [ ] Tests completos (unit, widget, integration)
- [ ] Seguridad reforzada
- [ ] Accesibilidad completa
- [ ] Soporte multi-idioma
- [ ] CI/CD configurado
- [ ] Publicación en stores
- [ ] Análisis predictivo de stock
- [ ] Integración con sistemas ERP
- [ ] API para terceros
- [ ] Dashboard web administrativo
- [ ] Tema AMOLED para pantallas OLED

## 👥 Contribución

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📧 Contacto

**Desarrollador**: Galva Developer  
**Email**: [alvaro.gonzales.dev@gmail.com]  
**GitHub**: [@galva-developer](https://github.com/galva-developer)
**GitHub**: [@alvaro-developer](https://github.com/alvaro-developer)

## 🙏 Agradecimientos

- Equipo de LETUSHOPS por la confianza en el proyecto
- Comunidad Flutter por las increíbles herramientas
- Firebase por la infraestructura en la nube
- Contributors y testers del proyecto

---

<div align="center">
  <h3>🛒 Hecho con ❤️ para LETUSHOPS</h3>
  <p>Revolucionando la gestión de inventario con tecnología de vanguardia</p>
</div>
