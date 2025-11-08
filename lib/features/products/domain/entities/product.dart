import 'package:equatable/equatable.dart';

/// Variante de color de un producto
///
/// Representa una variante de color específica de un producto
/// con su propio stock independiente
class ProductVariant extends Equatable {
  final String colorName; // Nombre del color (ej: "Rojo", "Azul Marino")
  final String colorHex; // Código hexadecimal del color (ej: "#FF0000")
  final int stock; // Stock disponible de esta variante
  final String? sku; // SKU específico para esta variante (opcional)

  const ProductVariant({
    required this.colorName,
    required this.colorHex,
    required this.stock,
    this.sku,
  });

  /// Crea una copia de la variante con campos actualizados
  ProductVariant copyWith({
    String? colorName,
    String? colorHex,
    int? stock,
    String? sku,
  }) {
    return ProductVariant(
      colorName: colorName ?? this.colorName,
      colorHex: colorHex ?? this.colorHex,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
    );
  }

  @override
  List<Object?> get props => [colorName, colorHex, stock, sku];

  @override
  String toString() => 'ProductVariant(color: $colorName, stock: $stock)';
}

/// Categorías de productos disponibles en el sistema
enum ProductCategory {
  electronics,
  clothing,
  food,
  beverages,
  homeAppliances,
  beauty,
  sports,
  toys,
  books,
  other;

  String get displayName {
    switch (this) {
      case ProductCategory.electronics:
        return 'Electrónicos';
      case ProductCategory.clothing:
        return 'Ropa';
      case ProductCategory.food:
        return 'Alimentos';
      case ProductCategory.beverages:
        return 'Bebidas';
      case ProductCategory.homeAppliances:
        return 'Electrodomésticos';
      case ProductCategory.beauty:
        return 'Belleza';
      case ProductCategory.sports:
        return 'Deportes';
      case ProductCategory.toys:
        return 'Juguetes';
      case ProductCategory.books:
        return 'Libros';
      case ProductCategory.other:
        return 'Otros';
    }
  }
}

/// Estado del producto en el inventario
enum ProductStatus {
  active,
  inactive,
  discontinued;

  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Activo';
      case ProductStatus.inactive:
        return 'Inactivo';
      case ProductStatus.discontinued:
        return 'Descontinuado';
    }
  }
}

/// Entidad de producto del dominio
///
/// Representa un producto en el sistema de inventario con toda su información
/// relevante como nombre, precio, stock, categoría, imágenes, etc.
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? costPrice; // Precio de costo (opcional)
  final int stock; // Stock total (calculado automáticamente si hay variantes)
  final int minStock; // Stock mínimo para alerta
  final ProductCategory category;
  final ProductStatus status;
  final String? barcode;
  final String? sku; // Stock Keeping Unit
  final List<String> images; // URLs de imágenes
  final String? brand;
  final String? manufacturer;
  final Map<String, dynamic>? specifications; // Especificaciones adicionales
  final List<String> tags; // Etiquetas para búsqueda
  final List<ProductVariant> variants; // Variantes de color del producto
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy; // ID del usuario que creó el producto
  final String? lastModifiedBy; // ID del último usuario que modificó

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.costPrice,
    required this.stock,
    this.minStock = 10,
    required this.category,
    this.status = ProductStatus.active,
    this.barcode,
    this.sku,
    this.images = const [],
    this.brand,
    this.manufacturer,
    this.specifications,
    this.tags = const [],
    this.variants = const [], // Variantes de color (vacío por defecto)
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastModifiedBy,
  });

  /// Verifica si el producto tiene variantes de color
  bool get hasVariants => variants.isNotEmpty;

  /// Obtiene el stock total (suma de todas las variantes si existen, o stock directo)
  int get totalStock {
    if (hasVariants) {
      return variants.fold<int>(0, (sum, variant) => sum + variant.stock);
    }
    return stock;
  }

  /// Verifica si el producto tiene stock bajo
  bool get hasLowStock => totalStock <= minStock;

  /// Verifica si el producto está agotado
  bool get isOutOfStock => totalStock == 0;

  /// Verifica si el producto está activo
  bool get isActive => status == ProductStatus.active;

  /// Calcula el margen de ganancia (si hay precio de costo)
  double? get profitMargin {
    if (costPrice == null || costPrice == 0) return null;
    return ((price - costPrice!) / costPrice!) * 100;
  }

  /// Obtiene la primera imagen o null
  String? get primaryImage => images.isNotEmpty ? images.first : null;

  /// Crea una copia del producto con campos actualizados
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? costPrice,
    int? stock,
    int? minStock,
    ProductCategory? category,
    ProductStatus? status,
    String? barcode,
    String? sku,
    List<String>? images,
    String? brand,
    String? manufacturer,
    Map<String, dynamic>? specifications,
    List<String>? tags,
    List<ProductVariant>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? lastModifiedBy,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      category: category ?? this.category,
      status: status ?? this.status,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      specifications: specifications ?? this.specifications,
      tags: tags ?? this.tags,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    costPrice,
    stock,
    minStock,
    category,
    status,
    barcode,
    sku,
    images,
    brand,
    manufacturer,
    specifications,
    tags,
    variants,
    createdAt,
    updatedAt,
    createdBy,
    lastModifiedBy,
  ];

  @override
  String toString() =>
      'Product(id: $id, name: $name, stock: $totalStock, price: $price, variants: ${variants.length})';
}
