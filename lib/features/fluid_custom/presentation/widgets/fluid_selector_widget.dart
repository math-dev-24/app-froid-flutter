import 'package:flutter/material.dart';
import '../../domain/entities/fluid_custom.dart';
import '../../../ruler/data/datasources/fluids_local_data.dart';

/// Widget de sélection et édition d'un fluide personnalisé
///
/// Affiche un fluide personnalisé avec deux modes:
/// - Mode lecture: Visualisation des fluides et de leurs quantités
/// - Mode édition: Modification du fluide et de ses composants
class FluidSelectorWidget extends StatefulWidget {
  final FluidCustom fluidCustom;
  final int index;
  final Function(FluidCustom) onUpdate;
  final Function(int) onDelete;

  const FluidSelectorWidget({
    super.key,
    required this.fluidCustom,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<FluidSelectorWidget> createState() => _FluidSelectorWidgetState();
}

class _FluidSelectorWidgetState extends State<FluidSelectorWidget> {
  bool _isEditing = false;
  late FluidCustom _editedFluid;
  final _labelController = TextEditingController();
  final List<TextEditingController> _quantityControllers = [];

  // Configuration
  static const int maxFluids = 5;
  static const int minFluids = 2;

  // Couleurs pour la visualisation
  static const List<Color> fluidColors = [
    Color(0xFF3B82F6), // Bleu
    Color(0xFF10B981), // Vert
    Color(0xFFF59E0B), // Orange
    Color(0xFFEF4444), // Rouge
    Color(0xFF8B5CF6), // Violet
  ];

  @override
  void initState() {
    super.initState();
    _initializeEditing();
  }

  @override
  void dispose() {
    _labelController.dispose();
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeEditing() {
    _editedFluid = widget.fluidCustom;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _labelController.text = widget.fluidCustom.label;

      // Initialiser les contrôleurs de quantité
      _quantityControllers.clear();
      for (var quantity in widget.fluidCustom.quantities) {
        _quantityControllers.add(
          TextEditingController(text: _decimalToPercentage(quantity).toString()),
        );
      }

      _editedFluid = widget.fluidCustom.copyWith();
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _quantityControllers.clear();
    });
  }

  void _saveChanges() {
    if (_isValidTotal() && _validationErrors().isEmpty) {
      // Récupérer les fluids_ref
      final List<String> fluidsRef = [];
      for (var fluidName in _editedFluid.fluids) {
        final fluid = FluidsLocalData.getFluidByName(fluidName);
        if (fluid != null) {
          fluidsRef.add(fluid.refName);
        }
      }

      // Convertir les pourcentages en décimaux
      final quantities = _quantityControllers
          .map((c) => _percentageToDecimal(double.tryParse(c.text) ?? 0))
          .toList();

      final updatedFluid = FluidCustom(
        label: _labelController.text,
        fluids: List.from(_editedFluid.fluids),
        fluidsRef: fluidsRef,
        quantities: quantities,
      );

      widget.onUpdate(updatedFluid);
      setState(() {
        _isEditing = false;
        _quantityControllers.clear();
      });
    }
  }

  // Utilitaires de conversion
  String _formatPercentage(double decimal) {
    return (decimal * 100).toStringAsFixed(1);
  }

  double _percentageToDecimal(double percentage) {
    return percentage / 100;
  }

  double _decimalToPercentage(double decimal) {
    return decimal * 100;
  }

  // Calcul du total
  double _getTotalDecimal() {
    return widget.fluidCustom.quantities.fold(0.0, (sum, qty) => sum + qty);
  }

  double _getEditedTotalDecimal() {
    return _quantityControllers.fold(
      0.0,
      (sum, controller) =>
          sum + _percentageToDecimal(double.tryParse(controller.text) ?? 0),
    );
  }

  // Validation
  bool _isValidTotal() {
    final total = _getEditedTotalDecimal();
    return (total - 1.0).abs() < 0.001; // Tolérance de 0.1%
  }

  List<String> _validationErrors() {
    final errors = <String>[];

    if (_labelController.text.trim().isEmpty) {
      errors.add("Le nom du mélange est requis");
    }

    final emptyFluids =
        _editedFluid.fluids.where((f) => f.trim().isEmpty).length;
    if (emptyFluids > 0) {
      errors.add("$emptyFluids fluide(s) non sélectionné(s)");
    }

    if (!_isValidTotal()) {
      final total = _getEditedTotalDecimal();
      errors.add(
          "Le total doit être 100% (actuellement ${_formatPercentage(total)}%)");
    }

    return errors;
  }

  // Gestion des fluides
  void _addFluid() {
    if (_editedFluid.fluids.length >= maxFluids) return;

    setState(() {
      _editedFluid = _editedFluid.copyWith(
        fluids: [..._editedFluid.fluids, ''],
        quantities: [..._editedFluid.quantities, 0.0],
      );
      _quantityControllers.add(TextEditingController(text: '0'));
    });
  }

  void _removeFluid(int index) {
    if (_editedFluid.fluids.length <= minFluids) return;

    setState(() {
      final newFluids = List<String>.from(_editedFluid.fluids);
      final newQuantities = List<double>.from(_editedFluid.quantities);

      newFluids.removeAt(index);
      newQuantities.removeAt(index);

      _editedFluid = _editedFluid.copyWith(
        fluids: newFluids,
        quantities: newQuantities,
      );

      _quantityControllers[index].dispose();
      _quantityControllers.removeAt(index);
    });
  }

  void _autoBalance() {
    if (!_editedFluid.hasAllFluidsSelected) return;

    final validCount = _editedFluid.fluids.where((f) => f.trim().isNotEmpty).length;
    final equalPercentage = 100.0 / validCount;

    setState(() {
      for (int i = 0; i < _quantityControllers.length; i++) {
        if (_editedFluid.fluids[i].trim().isNotEmpty) {
          _quantityControllers[i].text = equalPercentage.toStringAsFixed(1);
        }
      }
    });
  }

  // Gestion des couleurs
  Color _getFluidColor(int index) {
    return fluidColors[index % fluidColors.length];
  }

  Color _getQuantityColor(double quantity) {
    final percentage = quantity * 100;
    if (percentage > 70) return Colors.red.shade100;
    if (percentage > 40) return Colors.orange.shade100;
    if (percentage > 20) return Colors.blue.shade100;
    return Colors.grey.shade100;
  }

  Color _getTotalBadgeColor() {
    final total = _isEditing ? _getEditedTotalDecimal() : _getTotalDecimal();
    final isValid = (total - 1.0).abs() < 0.001;
    return isValid ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _isEditing ? _buildEditMode() : _buildReadMode(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  widget.fluidCustom.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!_isEditing) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTotalBadgeColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_formatPercentage(_getTotalDecimal())}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: _isEditing ? _buildEditActions() : _buildReadActions(),
        ),
      ],
    );
  }

  List<Widget> _buildReadActions() {
    return [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: _startEditing,
        tooltip: 'Modifier',
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.red,
        onPressed: () => widget.onDelete(widget.index),
        tooltip: 'Supprimer',
      ),
    ];
  }

  List<Widget> _buildEditActions() {
    return [
      IconButton(
        icon: const Icon(Icons.check),
        color: Colors.green,
        onPressed: _isValidTotal() ? _saveChanges : null,
        tooltip: 'Valider',
      ),
      IconButton(
        icon: const Icon(Icons.close),
        color: Colors.red,
        onPressed: _cancelEditing,
        tooltip: 'Annuler',
      ),
    ];
  }

  Widget _buildReadMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Liste des fluides
        ...List.generate(widget.fluidCustom.fluids.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getFluidColor(index),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.fluidCustom.fluids[index],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getQuantityColor(
                        widget.fluidCustom.quantities[index]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_formatPercentage(widget.fluidCustom.quantities[index])}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }),

        // Barre de progression
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: List.generate(
                widget.fluidCustom.quantities.length,
                (index) {
                  return Expanded(
                    flex: (widget.fluidCustom.quantities[index] * 1000).toInt(),
                    child: Container(
                      color: _getFluidColor(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    final availableFluids = FluidsLocalData.fluids
        .where((f) => f.name.isNotEmpty)
        .map((f) => f.name)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom du mélange
        TextField(
          controller: _labelController,
          decoration: const InputDecoration(
            labelText: 'Nom du mélange',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Liste des fluides
        ...List.generate(_editedFluid.fluids.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getFluidColor(index),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _editedFluid.fluids[index].isEmpty
                        ? null
                        : _editedFluid.fluids[index],
                    decoration: const InputDecoration(
                      labelText: 'Fluide',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: availableFluids.map((fluid) {
                      return DropdownMenuItem(
                        value: fluid,
                        child: Text(
                          fluid,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          final newFluids = List<String>.from(_editedFluid.fluids);
                          newFluids[index] = value;
                          _editedFluid = _editedFluid.copyWith(fluids: newFluids);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _quantityControllers[index],
                    decoration: const InputDecoration(
                      labelText: '%',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (_editedFluid.fluids.length > minFluids) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFluid(index),
                  ),
                ],
              ],
            ),
          );
        }),

        // Actions et validation
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (_editedFluid.fluids.length < maxFluids)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter'),
                    onPressed: _addFluid,
                  ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.balance),
                  label: const Text('Équilibrer'),
                  onPressed:
                      _editedFluid.hasAllFluidsSelected ? _autoBalance : null,
                ),
              ],
            ),
            Row(
              children: [
                const Text('Total: '),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getTotalBadgeColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_formatPercentage(_getEditedTotalDecimal())}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Messages de validation
        if (_validationErrors().isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._validationErrors().map((error) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
