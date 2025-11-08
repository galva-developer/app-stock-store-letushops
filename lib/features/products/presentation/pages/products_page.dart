import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_selector.dart';
import 'add_product_page.dart';
import 'product_detail_page.dart';

/// Página de lista de productos
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Botón de tema
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.themeIcon),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.themeName,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductsProvider>().loadProducts();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),

          // Selector de categorías
          Consumer<ProductsProvider>(
            builder: (context, provider, _) {
              return CategorySelector(
                selectedCategory: provider.filterCategory,
                onCategorySelected: (category) {
                  provider.filterByCategory(category);
                },
              );
            },
          ),

          // Estadísticas rápidas
          _buildQuickStats(),

          const Divider(height: 1),

          // Lista de productos
          Expanded(
            child: Consumer<ProductsProvider>(
              builder: (context, provider, _) {
                if (provider.state == ProductsState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.state == ProductsState.error) {
                  return _buildErrorState(provider.errorMessage);
                }

                if (provider.products.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadProducts(),
                  child: ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailPage(product: product),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AddProductPage(productToEdit: product),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteDialog(context, product.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar Producto'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ProductsProvider>().loadProducts();
                    },
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[100],
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            context.read<ProductsProvider>().loadProducts();
          }
        },
        onSubmitted: (value) {
          context.read<ProductsProvider>().searchProducts(value);
        },
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        if (stats == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total',
                stats.totalProducts.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
              _buildStatItem(
                'Stock Bajo',
                stats.lowStockProducts.toString(),
                Icons.warning_amber,
                Colors.orange,
              ),
              _buildStatItem(
                'Agotados',
                stats.outOfStockProducts.toString(),
                Icons.error_outline,
                Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay productos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer producto',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar productos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductsProvider>().loadProducts();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String productId) {
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
          content: const Text(
            '¿Estás seguro de que deseas eliminar este producto?\n\nEsta acción no se puede deshacer.',
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
                    .deleteProduct(productId);

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto eliminado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
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
