import 'package:flutter/material.dart';

enum Application {
  confort('Confort'),
  refrigeration('Réfrigération');

  final String label;
  const Application(this.label);
}

enum AccessConfort {
  general('Accès général'),
  surveille('Accès surveillé'),
  reserveD1('Accès réserve');

  final String label;
  const AccessConfort(this.label);
}

enum AccessRefrigeration {
  general('Accès général'),
  surveille('Accès surveillé'),
  reserveD1('Accès réserve ( >= 1 pers / 10m²)'),
  reserveD2('Accès réserve ( < 1 pers / 10m²)');

  final String label;
  const AccessRefrigeration(this.label);
}

enum Classification {
  un('Classe I', 'Equipement dans un espace occupé (monobloc, groupe logé, ...)'),
  deux('Classe II', 'Compresseur à l\'air libre ou dans salle des machines (groupe de condensation, centrale, ...)'),
  trois('Classe III', 'Système complet à l\'air libre ou salle des machines (Chiller, rooftop, ...)'),
  quatre('Classe IV', 'Enceinte ventilé (fluide maintenu dans une enceinte confinée)');

  final String label;
  final String description;
  const Classification(this.label, this.description);
}

class Fluid {
  final String id;
  final String label;
  final int desp;
  final double lfl;
  final double gwp;

  const Fluid({
    required this.id,
    required this.label,
    required this.desp,
    required this.lfl,
    required this.gwp,
  });
}

class RefrigerantChargeScreen extends StatefulWidget {
  const RefrigerantChargeScreen({super.key});

  @override
  State<RefrigerantChargeScreen> createState() => _RefrigerantChargeScreenState();
}

class _RefrigerantChargeScreenState extends State<RefrigerantChargeScreen> {
  static const List<Fluid> fluids = [
    Fluid(id: "R1234ze", label: "R1234ze", desp: 2, lfl: 0.303, gwp: 1.37),
    Fluid(id: "R1234yf", label: "R1234yf", desp: 2, lfl: 0.289, gwp: 0.501),
    Fluid(id: "R32", label: "R32", desp: 1, lfl: 0.307, gwp: 675),
    Fluid(id: "R454A", label: "R454A", desp: 1, lfl: 0.289, gwp: 270),
    Fluid(id: "R454B", label: "R454B", desp: 1, lfl: 0.297, gwp: 531),
    Fluid(id: "R454C", label: "R454C", desp: 1, lfl: 0.293, gwp: 145.5),
    Fluid(id: "R455A", label: "R455A", desp: 1, lfl: 0.431, gwp: 145.5),
  ];

  Application _application = Application.confort;
  AccessConfort _accessConfort = AccessConfort.general;
  AccessRefrigeration _accessRefrigeration = AccessRefrigeration.general;
  Classification _classification = Classification.un;
  Fluid _selectedFluid = fluids[0];
  double _volume = 0;

  final TextEditingController _volumeController = TextEditingController(text: '0');

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  double _getFactorM(String factorType) {
    switch (factorType) {
      case 'M1':
        return ((_selectedFluid.lfl * 4) * 100).round() / 100;
      case 'M2':
        return ((_selectedFluid.lfl * 26) * 100).round() / 100;
      case 'M3':
        return ((_selectedFluid.lfl * 130) * 100).round() / 100;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: const Text(
          'Calcul de Charge',
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
            // Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'En cours de développement',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Application
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
                  Text(
                    'Application',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown<Application>(
                    value: _application,
                    items: Application.values,
                    onChanged: (value) {
                      setState(() {
                        _application = value!;
                        if (_application == Application.confort) {
                          _accessConfort = AccessConfort.general;
                        } else {
                          _accessRefrigeration = AccessRefrigeration.general;
                        }
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Catégorie d'accès
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
                  Text(
                    'Catégorie d\'accès',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_application == Application.confort)
                    _buildDropdown<AccessConfort>(
                      value: _accessConfort,
                      items: AccessConfort.values,
                      onChanged: (value) {
                        setState(() {
                          _accessConfort = value!;
                        });
                      },
                      colorScheme: colorScheme,
                    )
                  else
                    _buildDropdown<AccessRefrigeration>(
                      value: _accessRefrigeration,
                      items: AccessRefrigeration.values,
                      onChanged: (value) {
                        setState(() {
                          _accessRefrigeration = value!;
                        });
                      },
                      colorScheme: colorScheme,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Fluide
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
                  Text(
                    'Fluide frigorigène',
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
                      child: DropdownButton<Fluid>(
                        value: _selectedFluid,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        borderRadius: BorderRadius.circular(12),
                        items: fluids.map((fluid) {
                          return DropdownMenuItem<Fluid>(
                            value: fluid,
                            child: Text(fluid.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFluid = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Infos fluide
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'LFL = ${_selectedFluid.lfl} kg/m³ - GWP = ${_selectedFluid.gwp}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tableau facteurs M
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Facteur M',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Plafond de charge (kg)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildFactorRow('M1', _getFactorM('M1'), colorScheme),
                        _buildFactorRow('M2', _getFactorM('M2'), colorScheme),
                        _buildFactorRow('M3', _getFactorM('M3'), colorScheme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Classification
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
                  Text(
                    'Classification',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown<Classification>(
                    value: _classification,
                    items: Classification.values,
                    onChanged: (value) {
                      setState(() {
                        _classification = value!;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _classification.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Résultat selon classification
            if (_classification == Classification.trois)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pas de limite de charge !',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (_classification == Classification.quatre)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Charge = ${_getFactorM('M3')} kg',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
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
                    Text(
                      'Volume',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _volumeController,
                      decoration: InputDecoration(
                        suffixText: 'm³',
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
                      onChanged: (value) {
                        setState(() {
                          _volume = double.tryParse(value) ?? 0.0;
                        });
                      },
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
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required ColorScheme colorScheme,
  }) {
    return Container(
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
            if (item is Application) {
              itemLabel = item.label;
            } else if (item is AccessConfort) {
              itemLabel = item.label;
            } else if (item is AccessRefrigeration) {
              itemLabel = item.label;
            } else if (item is Classification) {
              itemLabel = item.label;
            }
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFactorRow(String factor, double charge, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              factor,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '$charge kg',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
