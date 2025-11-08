# Sistema de Registro de Actividades (Activity Logs)

## 📋 Descripción General

El sistema de registro de actividades (Activity Logs) es un módulo completo que rastrea todas las acciones importantes realizadas en la aplicación. Proporciona un historial completo de quién hizo qué, cuándo y con qué datos, permitiendo auditoría y análisis de las operaciones del sistema.

## 🎯 Características Principales

### 1. **Registro Automático de Actividades**
- ✅ Creación de productos
- ✅ Actualización de productos
- ✅ Eliminación de productos
- ✅ Ajustes de stock (preparado para futura implementación)
- 🔄 Gestión de usuarios (estructura preparada)
- 🔄 Eventos de autenticación (estructura preparada)

### 2. **Información Capturada**
Cada registro de actividad contiene:
- **ID único** del registro
- **Tipo de actividad** (productCreated, productUpdated, etc.)
- **Usuario que realizó la acción:**
  - ID del usuario
  - Nombre completo
  - Email
- **Descripción** legible de la actividad
- **Metadata adicional:**
  - ID del producto afectado
  - Nombre del producto
  - Cambios específicos (en actualizaciones)
  - Diferencias de stock (en ajustes)
  - Razones (en ajustes de stock)
- **Timestamp** preciso de cuándo ocurrió

### 3. **Visualización en Tiempo Real**
- Widget dedicado en la página de inicio
- Stream de Firebase para actualizaciones instantáneas
- Muestra las últimas 5 actividades
- Formato de tiempo relativo ("hace 5 minutos", "hace 2 horas")
- Avatar circular con icono representativo de cada tipo
- Información completa del usuario y acción

## 🏗️ Arquitectura

El sistema sigue **Clean Architecture** con separación clara de capas:

```
lib/features/activity/
├── domain/
│   ├── entities/
│   │   └── activity_log.dart          # Entidad pura del dominio
│   └── repositories/
│       └── (No implementado - uso directo de service por simplicidad)
├── data/
│   ├── models/
│   │   └── activity_log_model.dart    # Modelo con conversión Firestore
│   ├── datasources/
│   │   └── firebase_activity_datasource.dart  # Operaciones de Firebase
│   └── services/
│       └── activity_log_service.dart   # Servicio helper de alto nivel
└── presentation/
    └── widgets/
        └── recent_activities_widget.dart  # Widget de visualización
```

## 📊 Tipos de Actividad

### Enum ActivityType

| Tipo | Nombre para Mostrar | Icono | Estado |
|------|-------------------|-------|--------|
| `productCreated` | Producto Creado | 📦 | ✅ Implementado |
| `productUpdated` | Producto Actualizado | ✏️ | ✅ Implementado |
| `productDeleted` | Producto Eliminado | 🗑️ | ✅ Implementado |
| `stockAdjusted` | Stock Ajustado | 📊 | 🔄 Estructura lista |
| `userCreated` | Usuario Creado | 👤 | 🔄 Estructura lista |
| `userUpdated` | Usuario Actualizado | 👤 | 🔄 Estructura lista |
| `userDeleted` | Usuario Eliminado | 👤 | 🔄 Estructura lista |
| `login` | Inicio de Sesión | 🔓 | 🔄 Estructura lista |
| `logout` | Cierre de Sesión | 🔒 | 🔄 Estructura lista |

## 🔧 Componentes Principales

### 1. ActivityLog Entity
**Ubicación:** `lib/features/activity/domain/entities/activity_log.dart`

Entidad del dominio que representa un registro de actividad:

```dart
class ActivityLog extends Equatable {
  final String id;
  final String type;
  final String userId;
  final String userName;
  final String userEmail;
  final String description;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;
}
```

### 2. ActivityLogModel
**Ubicación:** `lib/features/activity/data/models/activity_log_model.dart`

Modelo para conversión Firestore con métodos:
- `fromFirestore()` - Convierte DocumentSnapshot a modelo
- `toFirestore()` - Convierte modelo a Map para Firestore
- `fromEntity()` - Convierte entidad del dominio a modelo
- `toEntity()` - Convierte modelo a entidad del dominio

### 3. FirebaseActivityDataSource
**Ubicación:** `lib/features/activity/data/datasources/firebase_activity_datasource.dart`

**Colección Firestore:** `activity_logs`

**Métodos disponibles:**

| Método | Descripción | Parámetros | Retorno |
|--------|-------------|------------|---------|
| `logActivity()` | Crear nuevo registro | ActivityLogModel | Future\<void\> |
| `getRecentActivities()` | Últimas N actividades | limit (default: 10) | Future\<List\<ActivityLogModel\>\> |
| `getActivitiesByUser()` | Actividades de usuario | userId, limit (default: 50) | Future\<List\<ActivityLogModel\>\> |
| `getActivitiesByType()` | Actividades por tipo | ActivityType, limit (default: 50) | Future\<List\<ActivityLogModel\>\> |
| `watchRecentActivities()` | Stream en tiempo real | limit (default: 10) | Stream\<List\<ActivityLogModel\>\> |
| `deleteOldActivities()` | Limpieza de registros | olderThan DateTime | Future\<void\> |

### 4. ActivityLogService
**Ubicación:** `lib/features/activity/data/services/activity_log_service.dart`

Servicio de alto nivel con métodos helpers:

```dart
// Registrar creación de producto
await activityLogService.logProductCreated(
  user: authUser,
  productId: 'prod123',
  productName: 'Laptop Dell',
);

// Registrar actualización de producto
await activityLogService.logProductUpdated(
  user: authUser,
  productId: 'prod123',
  productName: 'Laptop Dell',
  changes: {'price': 'Cambio de \$1000 a \$900'},
);

// Registrar eliminación de producto
await activityLogService.logProductDeleted(
  user: authUser,
  productId: 'prod123',
  productName: 'Laptop Dell',
);

// Registrar ajuste de stock
await activityLogService.logStockAdjusted(
  user: authUser,
  productId: 'prod123',
  productName: 'Laptop Dell',
  oldStock: 10,
  newStock: 15,
  reason: 'Restock semanal',
);

// Obtener actividades recientes
final activities = await activityLogService.getRecentActivities(limit: 10);

// Stream de actividades en tiempo real
activityLogService.watchRecentActivities(limit: 10).listen((activities) {
  print('${activities.length} actividades recientes');
});
```

### 5. RecentActivitiesWidget
**Ubicación:** `lib/features/activity/presentation/widgets/recent_activities_widget.dart`

Widget que muestra actividades recientes en tiempo real:

**Características:**
- ✅ Stream builder para actualizaciones en vivo
- ✅ Muestra últimas 5 actividades
- ✅ Formato de tiempo relativo personalizado
- ✅ Avatar circular con icono de tipo de actividad
- ✅ Nombre de usuario destacado en negrita
- ✅ Descripción completa de la actividad
- ✅ Timestamp formateado ("hace X minutos")
- ✅ Estados de loading, error y vacío
- ✅ Diseño responsivo con Material 3

**Integración en HomePage:**
```dart
// En lib/features/home/presentation/pages/home_page.dart
RecentActivitiesWidget(),
```

## 🔐 Reglas de Seguridad Firestore

```javascript
// En firestore.rules
match /activity_logs/{logId} {
  // Lectura: Todos los usuarios autenticados
  allow read: if isAuthenticated();
  
  // Creación: Todos los usuarios autenticados pueden crear logs
  allow create: if isAuthenticated();
  
  // Actualización y eliminación: Solo administradores
  allow update, delete: if isAdmin();
}
```

## 🔄 Integración con ProductsProvider

El `ProductsProvider` registra automáticamente actividades en los siguientes métodos:

### createProduct()
```dart
// Después de crear el producto exitosamente
await _activityLogService.logProductCreated(
  user: currentAuthUser,
  productId: createdProduct.id,
  productName: createdProduct.name,
);
```

### updateProduct()
```dart
// Después de actualizar el producto exitosamente
await _activityLogService.logProductUpdated(
  user: currentAuthUser,
  productId: updatedProduct.id,
  productName: updatedProduct.name,
);
```

### deleteProduct()
```dart
// Después de eliminar el producto exitosamente
await _activityLogService.logProductDeleted(
  user: currentAuthUser,
  productId: product.id,
  productName: product.name,
);
```

**Nota:** El registro de actividades se hace en un bloque try-catch independiente para que si falla el logging, no afecte la operación principal del producto.

## 📱 Ejemplo de Uso

### Flujo Completo

1. **Usuario crea un producto:**
   ```
   Usuario: Juan Pérez (juan@example.com)
   Acción: Agrega "Laptop Dell Inspiron 15"
   ```

2. **Sistema registra automáticamente:**
   ```json
   {
     "id": "auto-generated-id",
     "type": "productCreated",
     "userId": "uid-123",
     "userName": "Juan Pérez",
     "userEmail": "juan@example.com",
     "description": "Creó el producto \"Laptop Dell Inspiron 15\"",
     "metadata": {
       "productId": "prod-456",
       "productName": "Laptop Dell Inspiron 15"
     },
     "timestamp": "2024-01-15T10:30:00Z"
   }
   ```

3. **Widget muestra en tiempo real:**
   ```
   📦 Juan Pérez
      Creó el producto "Laptop Dell Inspiron 15"
      hace 2 minutos
   ```

## 🎨 Formato de Tiempo Relativo

El widget utiliza una función personalizada para formatear timestamps:

| Diferencia | Formato |
|------------|---------|
| < 60 segundos | "hace X segundos" |
| < 60 minutos | "hace X minutos" |
| < 24 horas | "hace X horas" |
| < 7 días | "hace X días" |
| < 30 días | "hace X semanas" |
| < 365 días | "hace X meses" |
| ≥ 365 días | "hace X años" |

## 🔮 Expansiones Futuras

### Características Planeadas

1. **Filtros Avanzados:**
   - Filtrar por tipo de actividad
   - Filtrar por usuario
   - Filtrar por rango de fechas
   - Búsqueda en descripciones

2. **Página Completa de Actividades:**
   - Lista completa con paginación
   - Exportar a CSV/Excel
   - Gráficos de actividad
   - Estadísticas de uso

3. **Notificaciones:**
   - Alertas de actividades críticas
   - Notificaciones push para admins
   - Email digest diario/semanal

4. **Auditoría Avanzada:**
   - Comparación de cambios (diff)
   - Restauración de versiones anteriores
   - Logs de acceso a datos sensibles

5. **Integración con Otros Módulos:**
   - Registro de ventas
   - Registro de devoluciones
   - Registro de transferencias de inventario
   - Registro de cambios de configuración

## 📚 Dependencias

- `cloud_firestore`: ^5.4.3 - Base de datos en tiempo real
- `firebase_auth`: ^5.3.1 - Autenticación de usuarios
- `equatable`: ^2.0.5 - Comparación de entidades
- Flutter SDK: ^3.7.2

## 🎓 Buenas Prácticas Implementadas

1. ✅ **Clean Architecture** - Separación clara de capas
2. ✅ **SOLID Principles** - Responsabilidad única por clase
3. ✅ **Error Handling** - Manejo robusto de errores sin afectar operaciones principales
4. ✅ **Real-time Updates** - Streams de Firebase para sincronización instantánea
5. ✅ **Type Safety** - Uso de enums para tipos de actividad
6. ✅ **Documentation** - Código bien documentado con comentarios claros
7. ✅ **Security** - Reglas de Firestore restrictivas
8. ✅ **Scalability** - Método de limpieza para registros antiguos
9. ✅ **User Experience** - Tiempo relativo legible, iconos claros
10. ✅ **Maintainability** - Código modular y reutilizable

## 📝 Notas Importantes

- Los registros de actividad **no afectan** las operaciones principales si fallan
- El sistema usa el usuario actualmente autenticado de Firebase
- Todos los timestamps se almacenan en formato UTC
- La metadata es flexible (Map) para diferentes tipos de información
- El widget se actualiza automáticamente con streams
- Las reglas de Firestore previenen modificaciones no autorizadas

## 🚀 Estado de Implementación

| Característica | Estado |
|----------------|--------|
| Entidades y Modelos | ✅ Completo |
| Firebase DataSource | ✅ Completo |
| Service Helper | ✅ Completo |
| Widget de Visualización | ✅ Completo |
| Integración con Productos | ✅ Completo |
| Firestore Rules | ✅ Desplegado |
| Documentación | ✅ Completo |
| Tests Unitarios | ❌ Pendiente |
| Tests de Integración | ❌ Pendiente |

---

**Última actualización:** 15 de Enero, 2024
**Autor:** Sistema de Desarrollo
**Versión:** 1.0.0
