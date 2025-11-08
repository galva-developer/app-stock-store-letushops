import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

/// Selector de categoría de productos
class CategorySelector extends StatelessWidget {
  final ProductCategory? selectedCategory;
  final Function(ProductCategory?) onCategorySelected;
  final bool showAllOption;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (showAllOption)
            _buildCategoryChip(
              context,
              label: 'Todos',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
              icon: Icons.all_inclusive,
            ),
          ...ProductCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildCategoryChip(
                context,
                label: category.displayName,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
                icon: _getCategoryIcon(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.electronics:
        return Icons.devices;
      case ProductCategory.clothing:
        return Icons.checkroom;
      case ProductCategory.food:
        return Icons.restaurant;
      case ProductCategory.beverages:
        return Icons.local_drink;
      case ProductCategory.homeAppliances:
        return Icons.home;
      case ProductCategory.beauty:
        return Icons.face;
      case ProductCategory.sports:
        return Icons.sports_soccer;
      case ProductCategory.toys:
        return Icons.toys;
      case ProductCategory.books:
        return Icons.book;
      case ProductCategory.other:
        return Icons.category;
    }
  }
}
