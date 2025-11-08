import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

/// Modelo de datos para ProductVariant
///
/// Maneja la conversión de variantes entre dominio y Firestore
class ProductVariantModel {
  final String colorName;
  final String colorHex;
  final int stock;
  final String? sku;

  ProductVariantModel({
    required this.colorName,
    required this.colorHex,
    required this.stock,
    this.sku,
  });

  /// Convierte desde Map de Firestore
  factory ProductVariantModel.fromMap(Map<String, dynamic> data) {
    return ProductVariantModel(
      colorName: data['colorName'] as String? ?? '',
      colorHex: data['colorHex'] as String? ?? '#000000',
      stock: data['stock'] as int? ?? 0,
      sku: data['sku'] as String?,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'colorName': colorName,
      'colorHex': colorHex,
      'stock': stock,
      'sku': sku,
    };
  }

  /// Convierte desde la entidad de dominio
  factory ProductVariantModel.fromEntity(ProductVariant variant) {
    return ProductVariantModel(
      colorName: variant.colorName,
      colorHex: variant.colorHex,
      stock: variant.stock,
      sku: variant.sku,
    );
  }

  /// Convierte a la entidad de dominio
  ProductVariant toEntity() {
    return ProductVariant(
      colorName: colorName,
      colorHex: colorHex,
      stock: stock,
      sku: sku,
    );
  }
}

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
  final List<ProductVariantModel> variants;
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
    this.variants = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastModifiedBy,
  });

  /// Convierte desde Firestore DocumentSnapshot
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parsear variantes
    final List<ProductVariantModel> variants = [];
    if (data['variants'] != null && data['variants'] is List) {
      for (final variantData in (data['variants'] as List)) {
        if (variantData is Map<String, dynamic>) {
          variants.add(ProductVariantModel.fromMap(variantData));
        }
      }
    }

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
      variants: variants,
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
      'variants': variants.map((v) => v.toMap()).toList(),
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
      variants:
          product.variants
              .map((v) => ProductVariantModel.fromEntity(v))
              .toList(),
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
      variants: variants.map((v) => v.toEntity()).toList(),
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
