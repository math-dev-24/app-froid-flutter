import 'package:flutter/material.dart';

enum EquipmentType {
  recipients('Récipients'),
  tuyauterie('Tuyauterie');

  final String label;
  const EquipmentType(this.label);
}

enum FluidNature {
  liquide('Liquide'),
  gaz('Gaz');

  final String label;
  const FluidNature(this.label);
}

class DespScreen extends StatefulWidget {
  const DespScreen({super.key});

  @override
  State<DespScreen> createState() => _DespScreenState();
}

class _DespScreenState extends State<DespScreen> {
  EquipmentType _type = EquipmentType.recipients;
  FluidNature _nature = FluidNature.gaz;
  int _group = 2;
  double _pressure = 40;
  double _volume = 5;
  double _diamNom = 20;

  final TextEditingController _pressureController = TextEditingController(text: '40');
  final TextEditingController _volumeController = TextEditingController(text: '5');
  final TextEditingController _diamNomController = TextEditingController(text: '20');

  @override
  void dispose() {
    _pressureController.dispose();
    _volumeController.dispose();
    _diamNomController.dispose();
    super.dispose();
  }

  String get _despCategory {
    const art43 = "Art 4§3";
    const catI = "Cat I";
    const catII = "Cat II";
    const catIII = "Cat III";
    const catIV = "Cat IV";

    if (_pressure < 0.5) {
      return "Non soumis";
    }

    final pvs = _pressure * _volume;
    final pvn = _pressure * _diamNom;

    String result = "";

    if (_group == 1) {
      if (_nature == FluidNature.liquide) {
        if (_type == EquipmentType.tuyauterie) {
          // Tuyauterie liquide G1
          if (_diamNom <= 25) result = art43;
          if (pvn <= 2000 && _diamNom >= 25) result = art43;
          if (pvn > 2000 && _pressure <= 10) result = catI;
          if (pvn > 2000 && _diamNom > 25 && _pressure <= 500 && _pressure > 10) result = catII;
          if (_diamNom > 25 && _pressure > 500) result = catIII;
        } else {
          // Récipients liquide G1
          if (_volume < 1 && _pressure <= 500) result = art43;
          if (_volume >= 1 && pvs <= 200) result = art43;
          if (pvs > 200 && _pressure <= 10) result = catI;
          if (pvs > 200 && _volume >= 1 && _pressure <= 500 && _pressure > 10) result = catII;
          if (_volume <= 1 && _pressure > 500) result = catII;
          if (_volume > 1 && _pressure > 500) result = catIII;
        }
      } else {
        // Gaz
        if (_type == EquipmentType.tuyauterie) {
          // Tuyauterie gaz G1
          if (_diamNom <= 25) result = art43;
          if (_pressure > 10 && pvn <= 1000 && _diamNom > 25) result = catI;
          if (_diamNom < 100 && _diamNom >= 25 && _pressure <= 10) result = catI;

          if (_pressure > 40 && _diamNom > 25 && _diamNom <= 100) result = catII;
          if (_pressure < 35 && _pressure > 10 && pvn <= 3500 && pvn > 1000) result = catII;
          if (_pressure > 35 && _pressure <= 40 && _diamNom <= 100 && pvn > 1000) result = catII;
          if (_pressure <= 10 && _diamNom > 100 && _diamNom <= 350) result = catII;

          if (_pressure > 35 && _diamNom > 100) result = catIII;
          if (_pressure <= 10 && _diamNom > 350) result = catIII;
          if (_pressure > 10 && _pressure < 35 && pvn > 3500) result = catIII;
        } else {
          // Récipients gaz G1
          if (_pressure <= 200 && _volume <= 1) result = art43;
          if (_volume > 1 && pvs <= 25) result = art43;
          if (pvs > 25 && pvs <= 50 && _volume > 1) result = catI;
          if (pvs > 50 && pvs <= 200 && _volume > 1) result = catII;
          if (_pressure > 200 && _volume <= 1000 && _volume < 1) result = catIII;
          if (_volume > 1 && pvs > 200 && pvs <= 1000) result = catIII;
          if (_volume <= 1 && _pressure > 1000) result = catIV;
          if (_volume >= 1 && pvs > 1000) result = catIV;
        }
      }
    } else {
      // Groupe 2
      if (_nature == FluidNature.liquide) {
        if (_type == EquipmentType.tuyauterie) {
          // Tuyauterie Liquide G2
          if (_diamNom <= 200) result = art43;
          if (_diamNom <= 500 && _diamNom > 200 && pvn <= 5000) result = art43;
          if (_diamNom > 500 && _pressure <= 10) result = art43;
          if (_diamNom > 200 && pvn > 5000 && _diamNom <= 500 && _pressure <= 500) result = catI;
          if (_diamNom > 500 && _pressure > 10 && _pressure <= 500) result = catI;
          if (_diamNom > 200 && _pressure > 500) result = catII;
        } else {
          // Récipients Liquide G2
          if (_volume < 10 && _pressure <= 1000) result = art43;
          if (_volume >= 10 && pvs <= 10000 && _volume < 1000) result = art43;
          if (_volume >= 1000 && _pressure <= 10) result = art43;
          if (pvs > 10000 && _pressure <= 500 && _volume < 1000 && _pressure > 10) result = catI;
          if (_pressure > 10 && _pressure <= 500 && _volume >= 1000 && pvs > 10000) result = catI;
          if (_pressure > 1000 && _volume <= 10) result = catI;
          if (pvs > 10000 && _pressure > 500 && _volume > 10) result = catII;
        }
      } else {
        // Gaz
        if (_type == EquipmentType.tuyauterie) {
          // Tuyauterie gaz G2
          if (_diamNom <= 32) result = art43;
          if (_diamNom > 32 && pvn <= 1000) result = art43;

          if (_diamNom > 32 && _pressure > 35 && _diamNom <= 100) result = catI;
          if (_pressure <= 35 && _pressure > 31.25 && pvn <= 3500 && _diamNom > 32) result = catI;
          if (_pressure <= 31.25 && pvn > 1000 && pvn <= 3500) result = catI;

          if (_pressure > 35 && _diamNom > 100 && _diamNom <= 250) result = catII;
          if (_pressure > 20 && _pressure <= 35 && _diamNom <= 250 && pvn > 3500) result = catII;
          if (_pressure <= 20 && pvn <= 5000 && pvn > 3500) result = catII;
          if (_pressure > 20 && _diamNom > 250) result = catIII;
          if (_pressure <= 20 && pvn > 5000) result = catIII;
        } else {
          // Récipients Gaz G2
          if (_pressure <= 1000 && _volume <= 1) result = art43;
          if (_volume >= 1 && pvs <= 50) result = art43;
          if (pvs > 50 && pvs <= 200 && _volume > 1) result = catI;
          if (pvs > 200 && pvs <= 1000 && _volume > 1) result = catII;
          if (_pressure > 1000 && _pressure <= 3000 && _volume <= 1) result = catIII;
          if (_volume > 1 && _volume <= 1000 && pvs > 1000 && pvs <= 3000) result = catIII;
          if (_volume > 1000 && _pressure <= 4 && pvs > 1000) result = catIII;
          if (_volume <= 1 && _pressure > 3000) result = catIV;
          if (_volume > 1 && _volume <= 1000 && pvs > 3000) result = catIV;
          if (_volume >= 1000 && _pressure >= 4) result = catIV;
        }
      }
    }

    return result;
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case "Non soumis":
        return "L'équipement n'est pas soumis à la directive DESP";
      case "Art 4§3":
        return "Conception selon les règles de l'art";
      case "Cat I":
        return "Niveau de risque faible";
      case "Cat II":
        return "Niveau de risque modéré";
      case "Cat III":
        return "Niveau de risque élevé";
      case "Cat IV":
        return "Niveau de risque très élevé";
      default:
        return "";
    }
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case "Non soumis":
      case "Art 4§3":
        return colorScheme.outline;
      case "Cat I":
        return Colors.amber;
      case "Cat II":
        return Colors.orange;
      case "Cat III":
      case "Cat IV":
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pvValue = _type == EquipmentType.tuyauterie
        ? (_pressure * _diamNom).toStringAsFixed(1)
        : (_pressure * _volume).toStringAsFixed(1);
    final pvUnit = _type == EquipmentType.tuyauterie ? 'bar·mm' : 'bar·L';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: const Text(
          'Catégorisation DESP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Directive des Équipements Sous Pression (2014/68/UE)',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Configuration
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.settings,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Configuration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Type d'équipement
                  _buildDropdown(
                    label: 'Type d\'équipement',
                    value: _type,
                    items: EquipmentType.values,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  // Nature du fluide
                  _buildDropdown(
                    label: 'Nature du fluide',
                    value: _nature,
                    items: FluidNature.values,
                    onChanged: (value) {
                      setState(() {
                        _nature = value!;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  // Groupe de danger
                  Text(
                    'Groupe de danger',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _group = 1;
                            });
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _group == 1
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            foregroundColor: _group == 1
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                          child: const Text('Groupe 1'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _group = 2;
                            });
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _group == 2
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            foregroundColor: _group == 2
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                          child: const Text('Groupe 2'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Paramètres
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Paramètres',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pression de service
                  _buildTextField(
                    label: 'Pression de service',
                    controller: _pressureController,
                    suffix: 'bar',
                    help: 'PS: Pression maximale pour laquelle l\'équipement est conçu',
                    onChanged: (value) {
                      setState(() {
                        _pressure = double.tryParse(value) ?? 0.0;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  // Volume ou Diamètre nominal selon le type
                  if (_type == EquipmentType.recipients)
                    _buildTextField(
                      label: 'Volume',
                      controller: _volumeController,
                      suffix: 'litres',
                      onChanged: (value) {
                        setState(() {
                          _volume = double.tryParse(value) ?? 0.0;
                        });
                      },
                      colorScheme: colorScheme,
                    )
                  else
                    _buildTextField(
                      label: 'Diamètre nominal',
                      controller: _diamNomController,
                      suffix: 'mm',
                      help: 'DN: Taille de la tuyauterie exprimée en mm',
                      onChanged: (value) {
                        setState(() {
                          _diamNom = double.tryParse(value) ?? 0.0;
                        });
                      },
                      colorScheme: colorScheme,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Résultats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Détails du calcul',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Détails
                  _buildDetailRow('Groupe de danger', _group == 1 ? 'Groupe 1 (dangereux)' : 'Groupe 2 (Non dangereux)', colorScheme),
                  const SizedBox(height: 8),
                  _buildDetailRow('Type', _type.label, colorScheme),
                  const SizedBox(height: 8),
                  _buildDetailRow('Fluide', _nature.label, colorScheme),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    _type == EquipmentType.tuyauterie ? 'PS × DN' : 'PS × V',
                    '$pvValue $pvUnit',
                    colorScheme,
                  ),
                  const SizedBox(height: 20),

                  // Catégorie DESP
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.primaryContainer.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Catégorie DESP',
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _despCategory,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(_despCategory, colorScheme),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryDescription(_despCategory),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cet outil est fourni à titre indicatif. Pour toute application réglementaire officielle, veuillez vous référer au texte complet de la Directive des Équipements Sous Pression 2014/68/UE.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: BorderRadius.circular(12),
              items: items.map((T item) {
                String itemLabel = '';
                if (item is EquipmentType) {
                  itemLabel = item.label;
                } else if (item is FluidNature) {
                  itemLabel = item.label;
                }
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    String? help,
    required void Function(String) onChanged,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (help != null) ...[
          const SizedBox(height: 4),
          Text(
            help,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixText: suffix,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
