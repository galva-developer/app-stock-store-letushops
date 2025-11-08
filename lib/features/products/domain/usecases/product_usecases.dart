import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Caso de uso para crear un producto
class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<Product> call(Product product) async {
    return await _repository.createProduct(product);
  }
}

/// Caso de uso para actualizar un producto
class UpdateProductUseCase {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<Product> call(Product product) async {
    return await _repository.updateProduct(product);
  }
}

/// Caso de uso para eliminar un producto
class DeleteProductUseCase {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteProduct(id);
  }
}

/// Caso de uso para obtener todos los productos
class GetAllProductsUseCase {
  final ProductRepository _repository;

  GetAllProductsUseCase(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getAllProducts();
  }
}

/// Caso de uso para buscar productos
class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<Product>> call(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllProducts();
    }
    return await _repository.searchProducts(query);
  }
}

/// Caso de uso para obtener productos por categoría
class GetProductsByCategoryUseCase {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<List<Product>> call(ProductCategory category) async {
    return await _repository.getProductsByCategory(category);
  }
}

/// Caso de uso para obtener productos con stock bajo
class GetLowStockProductsUseCase {
  final ProductRepository _repository;

  GetLowStockProductsUseCase(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getLowStockProducts();
  }
}

/// Caso de uso para obtener estadísticas de productos
class GetProductStatsUseCase {
  final ProductRepository _repository;

  GetProductStatsUseCase(this._repository);

  Future<ProductStats> call() async {
    return await _repository.getProductStats();
  }
}
