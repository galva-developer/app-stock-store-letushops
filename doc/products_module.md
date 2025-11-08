# Módulo de Productos - Documentación

## Descripción General
El módulo de productos implementa un sistema completo de gestión de productos siguiendo Clean Architecture, permitiendo crear, listar, modificar, eliminar productos y generar estadísticas.

## Arquitectura

### Capa de Dominio
**Ubicación:** `lib/features/products/domain/`

#### Entidades
- **Product** (`entities/product.dart`): Entidad principal con 20+ campos
  - Información básica: id, name, description
  - Precios: price, costPrice, profitMargin (calculado)
  - Inventario: stock, minStock, hasLowStock, isOutOfStock
  - Clasificación: category (ProductCategory), status (ProductStatus)
  - Identificación: barcode, sku
  - Multimedia: images (array de URLs)
  - Metadata: brand, manufacturer, specifications, tags
  - Auditoría: createdAt, updatedAt, createdBy, lastModifiedBy

- **ProductCategory** (enum): electronics, clothing, food, beverages, homeAppliances, beauty, sports, toys, books, other

- **ProductStatus** (enum): active, inactive, discontinued

#### Repositorio
- **ProductRepository** (`repositories/product_repository.dart`): Interfaz con contratos de métodos
  - CRUD: createProduct, getProductById, updateProduct, deleteProduct
  - Búsqueda: getAllProducts, searchProducts
  - Filtros: getProductsByCategory, getProductsByPriceRange, getProductsByStatus, getLowStockProducts, getOutOfStockProducts
  - Streams: watchProducts, watchProductsByCategory
  - Estadísticas: getProductStats (ProductStats con totalProducts, lowStockProducts, outOfStockProducts, totalValue)

#### Use Cases
**Ubicación:** `domain/usecases/product_usecases.dart`
- **CreateProductUseCase**: Crear nuevo producto
- **UpdateProductUseCase**: Actualizar producto existente
- **DeleteProductUseCase**: Eliminar producto
- **GetAllProductsUseCase**: Obtener todos los productos
- **SearchProductsUseCase**: Buscar productos por query
- **GetProductsByCategoryUseCase**: Filtrar por categoría
- **GetLowStockProductsUseCase**: Productos con stock bajo
- **GetProductStatsUseCase**: Estadísticas del inventario

### Capa de Datos
**Ubicación:** `lib/features/products/data/`

#### Modelos
- **ProductModel** (`models/product_model.dart`): Conversión Firestore ↔ Entidad
  - `fromFirestore()`: Convierte DocumentSnapshot a ProductModel
  - `toFirestore()`: Convierte ProductModel a Map para Firestore
  - `fromEntity()`: Convierte Product a ProductModel
  - `toEntity()`: Convierte ProductModel a Product
  - Parsing seguro de enums (category, status)

#### Data Sources
- **FirebaseProductDataSource** (`datasources/firebase_product_datasource.dart`):
  - Colección Firestore: `products`
  - Operaciones CRUD con manejo de errores
  - Búsqueda client-side (toLowerCase, contains)
  - Filtros por categoría, rango de precio, estado
  - Streams para actualizaciones en tiempo real
  - Queries ordenadas por creación

#### Repository Implementation
- **ProductRepositoryImpl** (`repositories/product_repository_impl.dart`):
  - Implementa todos los métodos de ProductRepository
  - Delega operaciones a FirebaseProductDataSource
  - Calcula estadísticas agregadas (getProductStats)
  - Manejo de excepciones

### Capa de Presentación
**Ubicación:** `lib/features/products/presentation/`

#### Provider
- **ProductsProvider** (`providers/products_provider.dart`):
  - **Estados**: ProductsState (initial, loading, loaded, error, updating, deleting)
  - **Propiedades**:
    - `products`: Lista de productos cargados
    - `stats`: Estadísticas del inventario (ProductStats)
    - `filterCategory`: Categoría seleccionada para filtro
    - `errorMessage`: Mensaje de error si existe
  - **Métodos**:
    - `loadProducts()`: Cargar todos los productos
    - `searchProducts(query)`: Buscar productos
    - `filterByCategory(category)`: Filtrar por categoría
    - `createProduct(product)`: Crear producto
    - `updateProduct(product)`: Actualizar producto
    - `deleteProduct(productId)`: Eliminar producto
    - `loadStats()`: Cargar estadísticas

#### Páginas
- **ProductsPage** (`pages/products_page.dart`):
  - Lista de productos con ProductCard
  - Barra de búsqueda con TextField
  - Selector de categorías (CategorySelector)
  - Estadísticas rápidas (total, stock bajo, agotados)
  - Pull-to-refresh
  - FAB para agregar productos
  - Estados: loading, error, empty
  - Integración con ThemeProvider para modo oscuro

- **AddProductPage** (`pages/add_product_page.dart`):
  - Formulario completo para crear/editar productos
  - **Campos**:
    - Información Básica: nombre*, descripción
    - Clasificación: categoría*, estado*
    - Precios: precio de venta*, precio de costo
    - Inventario: stock actual*, stock mínimo
    - Identificación: SKU, código de barras
    - Adicional: marca, fabricante, etiquetas
  - Validación de formularios
  - Modo creación y edición
  - Botones: Cancelar, Guardar/Actualizar
  - Estados de carga durante guardado

- **ProductDetailPage** (`pages/product_detail_page.dart`):
  - Vista detallada del producto
  - Imagen principal (o placeholder)
  - Badge de estado (Active, Inactive, Discontinued)
  - Chip de categoría con icono
  - Secciones organizadas:
    - Descripción
    - Precios (venta, costo, margen de ganancia)
    - Inventario (stock actual, stock mínimo, alertas)
    - Identificación (SKU, código de barras)
    - Información adicional (marca, fabricante)
    - Etiquetas
    - Fechas (creación, última actualización)
  - Alertas visuales de stock bajo/agotado
  - Acciones: Editar, Eliminar
  - Diálogo de confirmación para eliminar

#### Widgets
- **ProductCard** (`widgets/product_card.dart`):
  - Card reutilizable para lista de productos
  - Imagen del producto (network con placeholder)
  - Nombre y precio destacados
  - Badges de estado:
    - 🔴 Rojo: Sin stock
    - 🟠 Naranja: Stock bajo
    - 🟢 Verde: Stock OK
  - Botones de acción: Editar, Eliminar
  - onTap para navegar a detalle
  - Responsive con diseño horizontal

- **CategorySelector** (`widgets/category_selector.dart`):
  - Selector horizontal de categorías
  - FilterChip para cada categoría
  - Opción "Todos" para quitar filtro
  - Scroll horizontal
  - Iconos por categoría:
    - Electronics: devices
    - Clothing: checkroom
    - Food: restaurant
    - Beverages: local_bar
    - HomeAppliances: home
    - Beauty: face
    - Sports: sports_soccer
    - Toys: toys
    - Books: book
    - Other: category
  - Integración con ProductsProvider

## Flujo de Uso

### 1. Listar Productos
```
ProductsPage → ProductsProvider.loadProducts() → GetAllProductsUseCase → 
ProductRepository → FirebaseProductDataSource → Firestore
```

### 2. Crear Producto
```
AddProductPage (Form) → ProductsProvider.createProduct() → CreateProductUseCase →
ProductRepository → FirebaseProductDataSource → Firestore.add()
```

### 3. Editar Producto
```
ProductDetailPage (Edit button) → AddProductPage (edit mode) → 
ProductsProvider.updateProduct() → UpdateProductUseCase → 
ProductRepository → FirebaseProductDataSource → Firestore.update()
```

### 4. Eliminar Producto
```
ProductDetailPage/ProductCard (Delete) → Confirmation Dialog → 
ProductsProvider.deleteProduct() → DeleteProductUseCase → 
ProductRepository → FirebaseProductDataSource → Firestore.delete()
```

### 5. Buscar Productos
```
ProductsPage (Search TextField) → ProductsProvider.searchProducts(query) → 
SearchProductsUseCase → ProductRepository → FirebaseProductDataSource 
(client-side filter)
```

### 6. Filtrar por Categoría
```
CategorySelector (Chip selected) → ProductsProvider.filterByCategory(category) → 
GetProductsByCategoryUseCase → ProductRepository → 
FirebaseProductDataSource.getProductsByCategory()
```

## Estructura de Datos en Firestore

### Colección: `products`
```json
{
  "id": "auto-generated",
  "name": "Producto de ejemplo",
  "description": "Descripción del producto",
  "price": 99.99,
  "costPrice": 50.00,
  "stock": 100,
  "minStock": 10,
  "category": "electronics",
  "status": "active",
  "barcode": "1234567890",
  "sku": "PROD-001",
  "images": ["url1", "url2"],
  "brand": "Marca X",
  "manufacturer": "Fabricante Y",
  "specifications": {
    "key": "value"
  },
  "tags": ["tag1", "tag2"],
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z",
  "createdBy": "userId",
  "lastModifiedBy": "userId"
}
```

## Características Implementadas

✅ CRUD completo de productos
✅ Búsqueda de productos
✅ Filtrado por categoría
✅ Alertas de stock bajo/agotado
✅ Cálculo automático de margen de ganancia
✅ Estadísticas del inventario
✅ Real-time updates con streams
✅ Modo oscuro completo
✅ Validación de formularios
✅ Manejo de errores
✅ Estados de carga
✅ Confirmaciones para acciones destructivas
✅ Responsive design

## Pendientes / Mejoras Futuras

⏳ Upload de imágenes (ImagePicker + Firebase Storage)
⏳ Scan de código de barras (Google ML Kit)
⏳ Exportar productos a CSV/Excel
⏳ Importar productos desde archivo
⏳ Historial de cambios de stock
⏳ Reportes avanzados
⏳ Paginación para listas grandes
⏳ Cache local con Hive/Isar
⏳ Sincronización offline

## Configuración Requerida

### 1. Firebase Firestore
```javascript
// Reglas de seguridad (ejemplo básico)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager'];
    }
  }
}
```

### 2. Main.dart
```dart
// Ya configurado en MultiProvider
ChangeNotifierProvider<ProductsProvider>(
  create: (context) => ProductsProvider(
    createProductUseCase: CreateProductUseCase(productRepository),
    updateProductUseCase: UpdateProductUseCase(productRepository),
    deleteProductUseCase: DeleteProductUseCase(productRepository),
    getAllProductsUseCase: GetAllProductsUseCase(productRepository),
    searchProductsUseCase: SearchProductsUseCase(productRepository),
    getProductsByCategoryUseCase: GetProductsByCategoryUseCase(productRepository),
    getLowStockProductsUseCase: GetLowStockProductsUseCase(productRepository),
    getProductStatsUseCase: GetProductStatsUseCase(productRepository),
  ),
),
```

### 3. Navegación
```dart
// Ruta ya configurada en app_routes.dart
GoRoute(
  path: '/products',
  name: 'products',
  builder: (context, state) => const ProductsPage(),
),
```

## Testing

### Unit Tests (Pendiente)
- [ ] Product entity tests
- [ ] ProductModel serialization tests
- [ ] Use cases tests
- [ ] Repository tests

### Widget Tests (Pendiente)
- [ ] ProductCard tests
- [ ] CategorySelector tests
- [ ] ProductsPage tests

### Integration Tests (Pendiente)
- [ ] CRUD flow tests
- [ ] Search and filter tests

## Mantenimiento

- Mantener sincronizado ProductModel con Product entity
- Actualizar índices de Firestore si se agregan búsquedas complejas
- Optimizar queries para listas grandes (paginación)
- Revisar reglas de seguridad de Firestore periódicamente
