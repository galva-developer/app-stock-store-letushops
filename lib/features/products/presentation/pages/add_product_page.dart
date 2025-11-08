import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/products_provider.dart';
import '../../../../core/constants/color_constants.dart';
import '../widgets/variant_manager.dart';

/// Página para agregar o editar un producto
class AddProductPage extends StatefulWidget {
  final Product? productToEdit;

  const AddProductPage({super.key, this.productToEdit});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _skuController = TextEditingController();
  final _brandController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _tagsController = TextEditingController();

  ProductCategory _selectedCategory = ProductCategory.other;
  ProductStatus _selectedStatus = ProductStatus.active;
  List<ProductVariant> _variants = []; // Lista de variantes de color
  bool _isSaving = false;
  String _currentUserId = 'admin'; // TODO: Get from auth

  bool get _isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadProductData();
    }
  }

  void _loadProductData() {
    final product = widget.productToEdit!;
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _costPriceController.text = product.costPrice?.toString() ?? '';
    _stockController.text = product.stock.toString();
    _minStockController.text = product.minStock.toString();
    _barcodeController.text = product.barcode ?? '';
    _skuController.text = product.sku ?? '';
    _brandController.text = product.brand ?? '';
    _manufacturerController.text = product.manufacturer ?? '';
    _tagsController.text = product.tags.join(', ');
    _selectedCategory = product.category;
    _selectedStatus = product.status;
    _variants = List.from(product.variants); // Cargar variantes existentes
    _currentUserId = product.createdBy;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _barcodeController.dispose();
    _skuController.dispose();
    _brandController.dispose();
    _manufacturerController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Agregar Producto'),
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Información básica
            _buildSectionTitle('Información Básica'),
            _buildTextField(
              controller: _nameController,
              label: 'Nombre del Producto *',
              icon: Icons.label,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Descripción *',
              icon: Icons.description,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Categoría
            _buildCategoryDropdown(),
            const SizedBox(height: 16),

            // Estado
            _buildStatusDropdown(),
            const SizedBox(height: 24),

            // Precios
            _buildSectionTitle('Precios'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _priceController,
                    label: 'Precio de Venta *',
                    icon: Icons.attach_money,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El precio es requerido';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Precio inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _costPriceController,
                    label: 'Precio de Costo',
                    icon: Icons.money_off,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Inventario
            _buildSectionTitle('Inventario'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _stockController,
                    label:
                        _variants.isEmpty ? 'Stock Actual *' : 'Stock Actual',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      // Si hay variantes, el stock se calcula automáticamente
                      if (_variants.isNotEmpty) return null;

                      if (value == null || value.isEmpty) {
                        return 'El stock es requerido';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Stock inválido';
                      }
                      return null;
                    },
                    enabled: _variants.isEmpty, // Deshabilitar si hay variantes
                    hint:
                        _variants.isNotEmpty
                            ? 'Se calcula desde variantes'
                            : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _minStockController,
                    label: 'Stock Mínimo',
                    icon: Icons.warning_amber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gestor de variantes
            VariantManager(
              initialVariants: _variants,
              onVariantsChanged: (variants) {
                setState(() {
                  _variants = variants;
                  // Actualizar el stock automáticamente si hay variantes
                  if (_variants.isNotEmpty) {
                    final totalStock = _variants.fold<int>(
                      0,
                      (sum, variant) => sum + variant.stock,
                    );
                    _stockController.text = totalStock.toString();
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            // Identificación
            _buildSectionTitle('Identificación'),
            _buildTextField(
              controller: _skuController,
              label: 'SKU',
              icon: Icons.qr_code,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _barcodeController,
              label: 'Código de Barras',
              icon: Icons.barcode_reader,
            ),
            const SizedBox(height: 24),

            // Información adicional
            _buildSectionTitle('Información Adicional'),
            _buildTextField(
              controller: _brandController,
              label: 'Marca',
              icon: Icons.branding_watermark,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _manufacturerController,
              label: 'Fabricante',
              icon: Icons.factory,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _tagsController,
              label: 'Etiquetas (separadas por comas)',
              icon: Icons.local_offer,
              hint: 'Ej: oferta, nuevo, destacado',
            ),
            const SizedBox(height: 32),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ColorConstants.primaryColor, // Siempre rojo
                      foregroundColor:
                          ColorConstants.textOnPrimaryColor, // Siempre blanco
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ), // Más padding vertical
                    ),
                    child:
                        _isSaving
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              _isEditing ? 'Actualizar' : 'Guardar',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorConstants.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<ProductCategory>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Categoría *',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[50],
      ),
      items:
          ProductCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.displayName),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedCategory = value);
        }
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<ProductStatus>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Estado *',
        prefixIcon: const Icon(Icons.toggle_on),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[50],
      ),
      items:
          ProductStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.displayName),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedStatus = value);
        }
      },
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final provider = context.read<ProductsProvider>();
      final tags =
          _tagsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      final product = Product(
        id: _isEditing ? widget.productToEdit!.id : '',
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? 'Sin descripción'
                : _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        costPrice:
            _costPriceController.text.isEmpty
                ? null
                : double.tryParse(_costPriceController.text),
        stock: int.parse(_stockController.text),
        minStock:
            _minStockController.text.isEmpty
                ? 10
                : int.tryParse(_minStockController.text) ?? 10,
        category: _selectedCategory,
        status: _selectedStatus,
        barcode:
            _barcodeController.text.trim().isEmpty
                ? null
                : _barcodeController.text.trim(),
        sku:
            _skuController.text.trim().isEmpty
                ? null
                : _skuController.text.trim(),
        brand:
            _brandController.text.trim().isEmpty
                ? null
                : _brandController.text.trim(),
        manufacturer:
            _manufacturerController.text.trim().isEmpty
                ? null
                : _manufacturerController.text.trim(),
        tags: tags,
        variants: _variants, // Incluir variantes de color
        createdAt:
            _isEditing ? widget.productToEdit!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy:
            _isEditing ? widget.productToEdit!.createdBy : _currentUserId,
        lastModifiedBy: _isEditing ? _currentUserId : null,
      );

      bool success;
      if (_isEditing) {
        success = await provider.updateProduct(product);
      } else {
        success = await provider.createProduct(product);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Producto actualizado exitosamente'
                  : 'Producto creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Error al guardar el producto',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
