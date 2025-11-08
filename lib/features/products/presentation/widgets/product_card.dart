import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

/// Card para mostrar información de un producto
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              _buildProductImage(),

              const SizedBox(width: 12),

              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Categoría
                    Text(
                      product.category.displayName,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 8),

                    // Precio y Stock
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Spacer(),
                        _buildStockBadge(context),
                      ],
                    ),
                  ],
                ),
              ),

              // Botones de acción
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(width: 8),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          product.primaryImage != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.primaryImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              )
              : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey);
  }

  Widget _buildStockBadge(BuildContext context) {
    Color badgeColor;
    String badgeText;
    IconData icon;

    if (product.isOutOfStock) {
      badgeColor = Colors.red;
      badgeText = 'Agotado';
      icon = Icons.error_outline;
    } else if (product.hasLowStock) {
      badgeColor = Colors.orange;
      badgeText = 'Stock Bajo: ${product.stock}';
      icon = Icons.warning_amber;
    } else {
      badgeColor = Colors.green;
      badgeText = 'Stock: ${product.stock}';
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
            color: Colors.blue,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (onDelete != null) ...[
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: onDelete,
            color: Colors.red,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }
}
