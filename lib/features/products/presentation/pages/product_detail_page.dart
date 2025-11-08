import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../providers/products_provider.dart';
import 'add_product_page.dart';

/// Página de detalle de un producto
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddProductPage(productToEdit: product),
                ),
              );
            },
            tooltip: 'Editar',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Eliminar',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Imagen del producto
          Container(
            height: 250,
            color: Colors.grey[200],
            child:
                product.images.isNotEmpty
                    ? Image.network(
                      product.images.first,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                    : _buildPlaceholderImage(),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y estado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildStatusBadge(product.status),
                  ],
                ),
                const SizedBox(height: 8),

                // Categoría
                Chip(
                  avatar: Icon(_getCategoryIcon(product.category), size: 18),
                  label: Text(product.category.displayName),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                ),
                const SizedBox(height: 16),

                // Descripción
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.description),
                const SizedBox(height: 24),

                // Precios
                _buildSectionTitle(context, 'Precios'),
                _buildInfoCard(
                  context,
                  children: [
                    _buildInfoRow(
                      context,
                      'Precio de Venta',
                      currencyFormat.format(product.price),
                      Icons.attach_money,
                    ),
                    if (product.costPrice != null) ...[
                      const Divider(),
                      _buildInfoRow(
                        context,
                        'Precio de Costo',
                        currencyFormat.format(product.costPrice),
                        Icons.money_off,
                      ),
                      if (product.profitMargin != null) ...[
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Margen de Ganancia',
                          '${product.profitMargin!.toStringAsFixed(1)}%',
                          Icons.trending_up,
                          valueColor:
                              product.profitMargin! > 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ],
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Inventario
                _buildSectionTitle(context, 'Inventario'),
                _buildInfoCard(
                  context,
                  children: [
                    _buildInfoRow(
                      context,
                      'Stock Actual',
                      product.stock.toString(),
                      Icons.inventory,
                      valueColor: _getStockColor(product),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Stock Mínimo',
                      product.minStock.toString(),
                      Icons.warning_amber,
                    ),
                  ],
                ),

                // Alertas de stock
                if (product.isOutOfStock) ...[
                  const SizedBox(height: 16),
                  _buildAlert(
                    context,
                    'Producto agotado',
                    'No hay stock disponible',
                    Colors.red,
                  ),
                ] else if (product.hasLowStock) ...[
                  const SizedBox(height: 16),
                  _buildAlert(
                    context,
                    'Stock bajo',
                    'El stock está por debajo del mínimo',
                    Colors.orange,
                  ),
                ],
                const SizedBox(height: 24),

                // Identificación
                if (product.sku != null || product.barcode != null) ...[
                  _buildSectionTitle(context, 'Identificación'),
                  _buildInfoCard(
                    context,
                    children: [
                      if (product.sku != null) ...[
                        _buildInfoRow(
                          context,
                          'SKU',
                          product.sku!,
                          Icons.qr_code,
                        ),
                        if (product.barcode != null) const Divider(),
                      ],
                      if (product.barcode != null)
                        _buildInfoRow(
                          context,
                          'Código de Barras',
                          product.barcode!,
                          Icons.barcode_reader,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Información adicional
                if (product.brand != null || product.manufacturer != null) ...[
                  _buildSectionTitle(context, 'Información Adicional'),
                  _buildInfoCard(
                    context,
                    children: [
                      if (product.brand != null) ...[
                        _buildInfoRow(
                          context,
                          'Marca',
                          product.brand!,
                          Icons.branding_watermark,
                        ),
                        if (product.manufacturer != null) const Divider(),
                      ],
                      if (product.manufacturer != null)
                        _buildInfoRow(
                          context,
                          'Fabricante',
                          product.manufacturer!,
                          Icons.factory,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Etiquetas
                if (product.tags.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Etiquetas'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        product.tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Fechas
                _buildSectionTitle(context, 'Fechas'),
                _buildInfoCard(
                  context,
                  children: [
                    _buildInfoRow(
                      context,
                      'Creado',
                      dateFormat.format(product.createdAt),
                      Icons.calendar_today,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Última Actualización',
                      dateFormat.format(product.updatedAt),
                      Icons.update,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(Icons.inventory_2, size: 100, color: Colors.grey[400]),
    );
  }

  Widget _buildStatusBadge(ProductStatus status) {
    Color color;
    switch (status) {
      case ProductStatus.active:
        color = Colors.green;
        break;
      case ProductStatus.inactive:
        color = Colors.grey;
        break;
      case ProductStatus.discontinued:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAlert(
    BuildContext context,
    String title,
    String message,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(message, style: TextStyle(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStockColor(Product product) {
    if (product.isOutOfStock) return Colors.red;
    if (product.hasLowStock) return Colors.orange;
    return Colors.green;
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.electronics:
        return Icons.devices;
      case ProductCategory.clothing:
        return Icons.checkroom;
      case ProductCategory.food:
        return Icons.restaurant;
      case ProductCategory.books:
        return Icons.book;
      case ProductCategory.toys:
        return Icons.toys;
      case ProductCategory.sports:
        return Icons.sports_soccer;
      case ProductCategory.homeAppliances:
        return Icons.home;
      case ProductCategory.beauty:
        return Icons.face;
      case ProductCategory.beverages:
        return Icons.local_bar;
      case ProductCategory.other:
        return Icons.category;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange),
              SizedBox(width: 12),
              Text('Eliminar Producto'),
            ],
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${product.name}"?\n\nEsta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await context
                    .read<ProductsProvider>()
                    .deleteProduct(product.id);

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto eliminado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
