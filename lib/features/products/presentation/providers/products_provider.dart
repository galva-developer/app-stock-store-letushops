import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/product_usecases.dart';
import '../../../authentication/domain/entities/auth_user.dart';
import '../../../activity/data/services/activity_log_service.dart';

/// Estados del provider de productos
enum ProductsState {
  initial,
  loading,
  loaded,
  error,
  creating,
  updating,
  deleting,
}

/// Provider para gestionar el estado de productos
class ProductsProvider extends ChangeNotifier {
  final GetAllProductsUseCase _getAllProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final GetLowStockProductsUseCase _getLowStockProductsUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final GetProductStatsUseCase _getProductStatsUseCase;
  final ActivityLogService _activityLogService;

  ProductsProvider({
    required GetAllProductsUseCase getAllProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required GetLowStockProductsUseCase getLowStockProductsUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required GetProductStatsUseCase getProductStatsUseCase,
    ActivityLogService? activityLogService,
  }) : _getAllProductsUseCase = getAllProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _getLowStockProductsUseCase = getLowStockProductsUseCase,
       _createProductUseCase = createProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       _getProductStatsUseCase = getProductStatsUseCase,
       _activityLogService = activityLogService ?? ActivityLogService();

  // Estado
  ProductsState _state = ProductsState.initial;
  ProductsState get state => _state;

  // Lista de productos
  List<Product> _products = [];
  List<Product> get products => _products;

  // Producto seleccionado
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  // Estadísticas
  ProductStats? _stats;
  ProductStats? get stats => _stats;

  // Filtros
  ProductCategory? _filterCategory;
  ProductCategory? get filterCategory => _filterCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Getters útiles
  List<Product> get lowStockProducts =>
      _products.where((p) => p.hasLowStock).toList();

  List<Product> get outOfStockProducts =>
      _products.where((p) => p.isOutOfStock).toList();

  List<Product> get activeProducts =>
      _products.where((p) => p.status == ProductStatus.active).toList();

  /// Carga todos los productos
  Future<void> loadProducts() async {
    _state = ProductsState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _getAllProductsUseCase();
      await _loadStats();
      _state = ProductsState.loaded;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Busca productos
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    _state = ProductsState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _searchProductsUseCase(query);
      _state = ProductsState.loaded;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Filtra por categoría
  Future<void> filterByCategory(ProductCategory? category) async {
    _filterCategory = category;
    _state = ProductsState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (category == null) {
        _products = await _getAllProductsUseCase();
      } else {
        _products = await _getProductsByCategoryUseCase(category);
      }
      _state = ProductsState.loaded;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Carga productos con stock bajo
  Future<void> loadLowStockProducts() async {
    _state = ProductsState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _getLowStockProductsUseCase();
      _state = ProductsState.loaded;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Crea un nuevo producto
  Future<bool> createProduct(Product product) async {
    _state = ProductsState.creating;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdProduct = await _createProductUseCase(product);
      _products.insert(0, createdProduct);
      await _loadStats();

      // Registrar actividad
      try {
        final user = firebase_auth.FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _activityLogService.logProductCreated(
            user: AuthUser(
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName,
              photoURL: user.photoURL,
              emailVerified: user.emailVerified,
              role: UserRole.employee,
              status: UserStatus.active,
            ),
            productId: createdProduct.id,
            productName: createdProduct.name,
          );
        }
      } catch (e) {
        // Si falla el logging, no afecta la creación del producto
        debugPrint('Error al registrar actividad: $e');
      }

      _state = ProductsState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualiza un producto
  Future<bool> updateProduct(Product product) async {
    _state = ProductsState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await _updateProductUseCase(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      await _loadStats();

      // Registrar actividad
      try {
        final user = firebase_auth.FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _activityLogService.logProductUpdated(
            user: AuthUser(
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName,
              photoURL: user.photoURL,
              emailVerified: user.emailVerified,
              role: UserRole.employee,
              status: UserStatus.active,
            ),
            productId: updatedProduct.id,
            productName: updatedProduct.name,
          );
        }
      } catch (e) {
        debugPrint('Error al registrar actividad: $e');
      }

      _state = ProductsState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Elimina un producto
  Future<bool> deleteProduct(String id) async {
    _state = ProductsState.deleting;
    _errorMessage = null;
    notifyListeners();

    try {
      // Guardar información del producto antes de eliminarlo
      final product = _products.firstWhere((p) => p.id == id);

      await _deleteProductUseCase(id);
      _products.removeWhere((p) => p.id == id);
      await _loadStats();

      // Registrar actividad
      try {
        final user = firebase_auth.FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _activityLogService.logProductDeleted(
            user: AuthUser(
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName,
              photoURL: user.photoURL,
              emailVerified: user.emailVerified,
              role: UserRole.employee,
              status: UserStatus.active,
            ),
            productId: product.id,
            productName: product.name,
          );
        }
      } catch (e) {
        debugPrint('Error al registrar actividad: $e');
      }

      _state = ProductsState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ProductsState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Selecciona un producto
  void selectProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// Limpia los filtros
  void clearFilters() {
    _filterCategory = null;
    _searchQuery = '';
    loadProducts();
  }

  /// Carga las estadísticas
  Future<void> _loadStats() async {
    try {
      _stats = await _getProductStatsUseCase();
    } catch (e) {
      debugPrint('Error cargando estadísticas: $e');
    }
  }

  /// Limpia el estado
  void clear() {
    _state = ProductsState.initial;
    _products = [];
    _selectedProduct = null;
    _stats = null;
    _filterCategory = null;
    _searchQuery = '';
    _errorMessage = null;
    notifyListeners();
  }
}
