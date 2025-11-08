import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/product.dart';
import '../../../../core/constants/color_constants.dart';

/// Widget para gestionar variantes de color de un producto
///
/// Permite agregar, editar y eliminar variantes de color con su stock
class VariantManager extends StatefulWidget {
  final List<ProductVariant> initialVariants;
  final ValueChanged<List<ProductVariant>> onVariantsChanged;

  const VariantManager({
    super.key,
    required this.initialVariants,
    required this.onVariantsChanged,
  });

  @override
  State<VariantManager> createState() => _VariantManagerState();
}

class _VariantManagerState extends State<VariantManager> {
  late List<ProductVariant> _variants;

  @override
  void initState() {
    super.initState();
    _variants = List.from(widget.initialVariants);
  }

  void _addVariant() {
    showDialog(
      context: context,
      builder:
          (context) => _VariantDialog(
            title: 'Agregar Variante de Color',
            onSave: (variant) {
              setState(() {
                _variants.add(variant);
                widget.onVariantsChanged(_variants);
              });
            },
          ),
    );
  }

  void _editVariant(int index) {
    showDialog(
      context: context,
      builder:
          (context) => _VariantDialog(
            title: 'Editar Variante de Color',
            variant: _variants[index],
            onSave: (variant) {
              setState(() {
                _variants[index] = variant;
                widget.onVariantsChanged(_variants);
              });
            },
          ),
    );
  }

  void _deleteVariant(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Variante'),
            content: Text(
              '¿Está seguro que desea eliminar la variante "${_variants[index].colorName}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _variants.removeAt(index);
                    widget.onVariantsChanged(_variants);
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  int get _totalStock {
    return _variants.fold<int>(0, (sum, variant) => sum + variant.stock);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Variantes de Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_variants.isNotEmpty)
                  Text(
                    'Stock total: $_totalStock unidades',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _addVariant,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                foregroundColor: ColorConstants.textOnPrimaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Lista de variantes
        if (_variants.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No hay variantes de color',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Agrega variantes si el producto viene en diferentes colores',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _variants.length,
            itemBuilder: (context, index) {
              final variant = _variants[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _parseColor(variant.colorHex),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  ),
                  title: Text(variant.colorName),
                  subtitle: Text(
                    'Stock: ${variant.stock} unidades${variant.sku != null ? ' • SKU: ${variant.sku}' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editVariant(index),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _deleteVariant(index),
                        tooltip: 'Eliminar',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}

/// Diálogo para agregar/editar variante
class _VariantDialog extends StatefulWidget {
  final String title;
  final ProductVariant? variant;
  final ValueChanged<ProductVariant> onSave;

  const _VariantDialog({
    required this.title,
    this.variant,
    required this.onSave,
  });

  @override
  State<_VariantDialog> createState() => _VariantDialogState();
}

class _VariantDialogState extends State<_VariantDialog> {
  late TextEditingController _colorNameController;
  late TextEditingController _stockController;
  late TextEditingController _skuController;
  late Color _selectedColor;
  final _formKey = GlobalKey<FormState>();

  // Colores predefinidos comunes
  final List<Color> _commonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.black,
    Colors.white,
    Colors.cyan,
    Colors.teal,
    Colors.lime,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _colorNameController = TextEditingController(
      text: widget.variant?.colorName ?? '',
    );
    _stockController = TextEditingController(
      text: widget.variant?.stock.toString() ?? '0',
    );
    _skuController = TextEditingController(text: widget.variant?.sku ?? '');
    _selectedColor =
        widget.variant != null
            ? _parseColor(widget.variant!.colorHex)
            : Colors.red;
  }

  @override
  void dispose() {
    _colorNameController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.red;
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final variant = ProductVariant(
        colorName: _colorNameController.text.trim(),
        colorHex: _colorToHex(_selectedColor),
        stock: int.parse(_stockController.text),
        sku:
            _skuController.text.trim().isEmpty
                ? null
                : _skuController.text.trim(),
      );
      widget.onSave(variant);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del color
              TextFormField(
                controller: _colorNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Color *',
                  hintText: 'Ej: Rojo, Azul Marino, Negro',
                  prefixIcon: Icon(Icons.palette),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre del color es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Selector de color
              const Text(
                'Seleccionar Color *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _commonColors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorConstants.primaryColor
                                      : Colors.grey[300]!,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child:
                              isSelected
                                  ? Icon(
                                    Icons.check,
                                    color:
                                        color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                  )
                                  : null,
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),

              // Stock
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock *',
                  hintText: '0',
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El stock es requerido';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return 'Ingrese un stock válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // SKU (opcional)
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU (Opcional)',
                  hintText: 'Ej: PROD-RED-001',
                  prefixIcon: Icon(Icons.qr_code),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.primaryColor,
            foregroundColor: ColorConstants.textOnPrimaryColor,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
