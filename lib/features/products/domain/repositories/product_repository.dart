import '../entities/product.dart';

/// Repositorio de productos
///
/// Define el contrato para todas las operaciones relacionadas con productos
abstract class ProductRepository {
  /// Obtiene todos los productos
  Future<List<Product>> getAllProducts();

  /// Obtiene un producto por ID
  Future<Product?> getProductById(String id);

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(ProductCategory category);

  /// Obtiene productos con stock bajo
  Future<List<Product>> getLowStockProducts();

  /// Obtiene productos agotados
  Future<List<Product>> getOutOfStockProducts();

  /// Busca productos por texto (nombre, descripción, barcode, SKU)
  Future<List<Product>> searchProducts(String query);

  /// Crea un nuevo producto
  Future<Product> createProduct(Product product);

  /// Actualiza un producto existente
  Future<Product> updateProduct(Product product);

  /// Elimina un producto
  Future<void> deleteProduct(String id);

  /// Actualiza el stock de un producto
  Future<void> updateStock(String id, int newStock);

  /// Obtiene productos por estado
  Future<List<Product>> getProductsByStatus(ProductStatus status);

  /// Obtiene productos por rango de precio
  Future<List<Product>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );

  /// Obtiene productos creados por un usuario específico
  Future<List<Product>> getProductsByCreator(String userId);

  /// Stream de productos para actualizaciones en tiempo real
  Stream<List<Product>> watchProducts();

  /// Stream de un producto específico
  Stream<Product?> watchProduct(String id);

  /// Obtiene estadísticas de productos
  Future<ProductStats> getProductStats();
}

/// Estadísticas de productos
class ProductStats {
  final int totalProducts;
  final int activeProducts;
  final int inactiveProducts;
  final int lowStockProducts;
  final int outOfStockProducts;
  final double totalInventoryValue;
  final Map<ProductCategory, int> productsByCategory;

  const ProductStats({
    required this.totalProducts,
    required this.activeProducts,
    required this.inactiveProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.totalInventoryValue,
    required this.productsByCategory,
  });
}
