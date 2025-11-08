import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/firebase_product_datasource.dart';
import '../models/product_model.dart';

/// Implementación del repositorio de productos
class ProductRepositoryImpl implements ProductRepository {
  final FirebaseProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final models = await _dataSource.getAllProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final model = await _dataSource.getProductById(id);
      return model?.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    try {
      final models = await _dataSource.getProductsByCategory(category.name);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    try {
      final models = await _dataSource.getLowStockProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getOutOfStockProducts() async {
    try {
      final models = await _dataSource.getOutOfStockProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final models = await _dataSource.searchProducts(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final createdModel = await _dataSource.createProduct(model);
      return createdModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final updatedModel = await _dataSource.updateProduct(model);
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _dataSource.deleteProduct(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateStock(String id, int newStock) async {
    try {
      await _dataSource.updateStock(id, newStock);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByStatus(ProductStatus status) async {
    try {
      final models = await _dataSource.getProductsByStatus(status.name);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final models = await _dataSource.getProductsByPriceRange(
        minPrice,
        maxPrice,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCreator(String userId) async {
    try {
      final models = await _dataSource.getProductsByCreator(userId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Product>> watchProducts() {
    return _dataSource.watchProducts().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Stream<Product?> watchProduct(String id) {
    return _dataSource.watchProduct(id).map((model) => model?.toEntity());
  }

  @override
  Future<ProductStats> getProductStats() async {
    try {
      final products = await getAllProducts();

      final totalProducts = products.length;
      final activeProducts =
          products.where((p) => p.status == ProductStatus.active).length;
      final inactiveProducts =
          products.where((p) => p.status == ProductStatus.inactive).length;
      final lowStockProducts = products.where((p) => p.hasLowStock).length;
      final outOfStockProducts = products.where((p) => p.isOutOfStock).length;

      final totalInventoryValue = products.fold<double>(
        0,
        (sum, product) => sum + (product.price * product.stock),
      );

      final productsByCategory = <ProductCategory, int>{};
      for (final category in ProductCategory.values) {
        productsByCategory[category] =
            products.where((p) => p.category == category).length;
      }

      return ProductStats(
        totalProducts: totalProducts,
        activeProducts: activeProducts,
        inactiveProducts: inactiveProducts,
        lowStockProducts: lowStockProducts,
        outOfStockProducts: outOfStockProducts,
        totalInventoryValue: totalInventoryValue,
        productsByCategory: productsByCategory,
      );
    } catch (e) {
      rethrow;
    }
  }
}
