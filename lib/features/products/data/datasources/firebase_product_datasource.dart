import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

/// DataSource de Firebase para productos
///
/// Maneja todas las operaciones de Firebase Firestore relacionadas con productos
class FirebaseProductDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'products';

  FirebaseProductDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Obtiene todos los productos
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos: $e');
    }
  }

  /// Obtiene un producto por ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return ProductModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Error obteniendo producto: $e');
    }
  }

  /// Obtiene productos por categoría
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('category', isEqualTo: category)
              .orderBy('name')
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos por categoría: $e');
    }
  }

  /// Obtiene productos con stock bajo
  Future<List<ProductModel>> getLowStockProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('status', isEqualTo: 'active')
              .get();

      final products =
          snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .where((product) => product.stock <= product.minStock)
              .toList();

      return products;
    } catch (e) {
      throw Exception('Error obteniendo productos con stock bajo: $e');
    }
  }

  /// Obtiene productos agotados
  Future<List<ProductModel>> getOutOfStockProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('stock', isEqualTo: 0)
              .where('status', isEqualTo: 'active')
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos agotados: $e');
    }
  }

  /// Busca productos por texto
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final queryLower = query.toLowerCase();

      // Obtener todos los productos y filtrar en cliente
      // (Firestore no soporta búsqueda de texto completo nativamente)
      final snapshot = await _firestore.collection(_collection).get();

      final products =
          snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).where((
            product,
          ) {
            final nameLower = product.name.toLowerCase();
            final descLower = product.description.toLowerCase();
            final barcode = product.barcode?.toLowerCase() ?? '';
            final sku = product.sku?.toLowerCase() ?? '';

            return nameLower.contains(queryLower) ||
                descLower.contains(queryLower) ||
                barcode.contains(queryLower) ||
                sku.contains(queryLower);
          }).toList();

      return products;
    } catch (e) {
      throw Exception('Error buscando productos: $e');
    }
  }

  /// Crea un nuevo producto
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(product.toFirestore());

      final doc = await docRef.get();
      return ProductModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Error creando producto: $e');
    }
  }

  /// Actualiza un producto existente
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(product.id)
          .update(product.toFirestore());

      final doc =
          await _firestore.collection(_collection).doc(product.id).get();
      return ProductModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Error actualizando producto: $e');
    }
  }

  /// Elimina un producto
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error eliminando producto: $e');
    }
  }

  /// Actualiza el stock de un producto
  Future<void> updateStock(String id, int newStock) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'stock': newStock,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error actualizando stock: $e');
    }
  }

  /// Obtiene productos por estado
  Future<List<ProductModel>> getProductsByStatus(String status) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('status', isEqualTo: status)
              .orderBy('name')
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos por estado: $e');
    }
  }

  /// Obtiene productos por rango de precio
  Future<List<ProductModel>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('price', isGreaterThanOrEqualTo: minPrice)
              .where('price', isLessThanOrEqualTo: maxPrice)
              .orderBy('price')
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos por precio: $e');
    }
  }

  /// Obtiene productos creados por un usuario específico
  Future<List<ProductModel>> getProductsByCreator(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('createdBy', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo productos por creador: $e');
    }
  }

  /// Stream de productos para actualizaciones en tiempo real
  Stream<List<ProductModel>> watchProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ProductModel.fromFirestore(doc))
                  .toList(),
        );
  }

  /// Stream de un producto específico
  Stream<ProductModel?> watchProduct(String id) {
    return _firestore
        .collection(_collection)
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? ProductModel.fromFirestore(doc) : null);
  }
}
