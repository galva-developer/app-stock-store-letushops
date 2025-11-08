import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

/// Modelo de datos para Product
///
/// Maneja la conversión entre la entidad de dominio y Firestore
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? costPrice;
  final int stock;
  final int minStock;
  final String category;
  final String status;
  final String? barcode;
  final String? sku;
  final List<String> images;
  final String? brand;
  final String? manufacturer;
  final Map<String, dynamic>? specifications;
  final List<String> tags;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;
  final String? lastModifiedBy;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.costPrice,
    required this.stock,
    required this.minStock,
    required this.category,
    required this.status,
    this.barcode,
    this.sku,
    required this.images,
    this.brand,
    this.manufacturer,
    this.specifications,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastModifiedBy,
  });

  /// Convierte desde Firestore DocumentSnapshot
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      costPrice: (data['costPrice'] as num?)?.toDouble(),
      stock: data['stock'] as int? ?? 0,
      minStock: data['minStock'] as int? ?? 10,
      category: data['category'] as String? ?? 'other',
      status: data['status'] as String? ?? 'active',
      barcode: data['barcode'] as String?,
      sku: data['sku'] as String?,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      brand: data['brand'] as String?,
      manufacturer: data['manufacturer'] as String?,
      specifications: data['specifications'] as Map<String, dynamic>?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
      createdBy: data['createdBy'] as String? ?? '',
      lastModifiedBy: data['lastModifiedBy'] as String?,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'costPrice': costPrice,
      'stock': stock,
      'minStock': minStock,
      'category': category,
      'status': status,
      'barcode': barcode,
      'sku': sku,
      'images': images,
      'brand': brand,
      'manufacturer': manufacturer,
      'specifications': specifications,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
    };
  }

  /// Convierte desde la entidad de dominio
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      costPrice: product.costPrice,
      stock: product.stock,
      minStock: product.minStock,
      category: product.category.name,
      status: product.status.name,
      barcode: product.barcode,
      sku: product.sku,
      images: product.images,
      brand: product.brand,
      manufacturer: product.manufacturer,
      specifications: product.specifications,
      tags: product.tags,
      createdAt: Timestamp.fromDate(product.createdAt),
      updatedAt: Timestamp.fromDate(product.updatedAt),
      createdBy: product.createdBy,
      lastModifiedBy: product.lastModifiedBy,
    );
  }

  /// Convierte a la entidad de dominio
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      costPrice: costPrice,
      stock: stock,
      minStock: minStock,
      category: _parseCategory(category),
      status: _parseStatus(status),
      barcode: barcode,
      sku: sku,
      images: images,
      brand: brand,
      manufacturer: manufacturer,
      specifications: specifications,
      tags: tags,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
    );
  }

  /// Parsea la categoría desde string
  ProductCategory _parseCategory(String category) {
    try {
      return ProductCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ProductCategory.other,
      );
    } catch (e) {
      return ProductCategory.other;
    }
  }

  /// Parsea el estado desde string
  ProductStatus _parseStatus(String status) {
    try {
      return ProductStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ProductStatus.active,
      );
    } catch (e) {
      return ProductStatus.active;
    }
  }
}
