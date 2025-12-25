import 'package:app_froid/data/list_signals.dart';
import 'package:app_froid/data/models/signal.dart';
import 'package:flutter/material.dart';

class SensorConvertScreen extends StatefulWidget {
  const SensorConvertScreen({super.key});

  @override
  State<SensorConvertScreen> createState() => _SensorConvertScreenState();
}

class _SensorConvertScreenState extends State<SensorConvertScreen> {
  int _selectedSignalIndex = 0;
  double _minValue = 0.0;
  double _maxValue = 10.0;
  String _unitValue = '°C';
  SearchType _searchType = SearchType.signal;
  double _searchValue = 4.0;

  String _result = '';
  String _errorMessage = '';
  bool _hasError = false;

  final TextEditingController _minController = TextEditingController(text: '0');
  final TextEditingController _maxController = TextEditingController(text: '10');
  final TextEditingController _searchController = TextEditingController(text: '4');

  @override
  void initState() {
    super.initState();
    _calculateResult();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Signal get _selectedSignal => ListSignals.signals[_selectedSignalIndex];

  void _calculateResult() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _result = '';
    });

    // Vérifications
    if (_minValue >= _maxValue) {
      setState(() {
        _hasError = true;
        _errorMessage = 'La valeur minimale doit être inférieure à la valeur maximale';
      });
      return;
    }

    if (_searchType == SearchType.signal) {
      // Signal → Valeur
      if (_searchValue < _selectedSignal.min || _searchValue > _selectedSignal.max) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Le signal doit être entre ${_selectedSignal.min} et ${_selectedSignal.max} ${_selectedSignal.unit}';
        });
        return;
      }

      final pasSignal = (_maxValue - _minValue) / _selectedSignal.delta;
      final calculValue = (pasSignal * (_searchValue - _selectedSignal.min) + _minValue);
      setState(() {
        _result = '${calculValue.toStringAsFixed(2)} $_unitValue';
      });
    } else {
      // Valeur → Signal
      if (_searchValue < _minValue || _searchValue > _maxValue) {
        setState(() {
          _hasError = true;
          _errorMessage = 'La valeur doit être entre $_minValue et $_maxValue $_unitValue';
        });
        return;
      }

      final pasValeur = _selectedSignal.delta / (_maxValue - _minValue);
      final calcul = (pasValeur * (_searchValue - _minValue)) + _selectedSignal.min;
      setState(() {
        _result = '${calcul.toStringAsFixed(2)} ${_selectedSignal.unit}';
      });
    }
  }

  String get _resultDescription {
    if (_result.isEmpty) return '';

    if (_searchType == SearchType.signal) {
      return 'Pour un signal de ${_searchValue.toStringAsFixed(2)} ${_selectedSignal.unit}, la valeur mesurée est :';
    } else {
      return 'Pour une valeur de ${_searchValue.toStringAsFixed(2)} $_unitValue, le signal de sortie est :';
    }
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T, int) getLabel,
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              items: items.asMap().entries.map((entry) {
                return DropdownMenuItem<T>(
                  value: entry.value,
                  child: Text(getLabel(entry.value, entry.key)),
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
    required void Function(String) onChanged,
    required ColorScheme colorScheme,
    String? suffix,
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
          'Signal Capteur',
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
            // Section Type de signal
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
                          Icons.electric_bolt,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Type de signal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<int>(
                    label: 'Sélectionnez un type de signal',
                    value: _selectedSignalIndex,
                    items: List.generate(ListSignals.signals.length, (i) => i),
                    getLabel: (value, index) => ListSignals.signalLabels[index],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSignalIndex = value;
                          _searchValue = _selectedSignal.min;
                          _searchController.text = _searchValue.toString();
                        });
                        _calculateResult();
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
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
                          size: 16,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Plage: ${_selectedSignal.min} - ${_selectedSignal.max} ${_selectedSignal.unit}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Plage du capteur
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
                          Icons.settings_input_component,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Plage du capteur',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Valeur minimale',
                          controller: _minController,
                          suffix: _unitValue,
                          onChanged: (value) {
                            _minValue = double.tryParse(value) ?? 0.0;
                            _calculateResult();
                          },
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Valeur maximale',
                          controller: _maxController,
                          suffix: _unitValue,
                          onChanged: (value) {
                            _maxValue = double.tryParse(value) ?? 0.0;
                            _calculateResult();
                          },
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown<String>(
                    label: 'Unité de mesure',
                    value: _unitValue,
                    items: ListSignals.units,
                    getLabel: (value, index) => value,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _unitValue = value;
                        });
                        _calculateResult();
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Conversion
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
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.swap_horiz,
                          color: colorScheme.tertiary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Conversion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SegmentedButton<SearchType>(
                    segments: const [
                      ButtonSegment(
                        value: SearchType.signal,
                        label: Text('Signal → Valeur'),
                        icon: Icon(Icons.arrow_forward, size: 16),
                      ),
                      ButtonSegment(
                        value: SearchType.value,
                        label: Text('Valeur → Signal'),
                        icon: Icon(Icons.arrow_back, size: 16),
                      ),
                    ],
                    selected: {_searchType},
                    onSelectionChanged: (Set<SearchType> newSelection) {
                      setState(() {
                        _searchType = newSelection.first;
                        if (_searchType == SearchType.signal) {
                          _searchValue = _selectedSignal.min;
                        } else {
                          _searchValue = _minValue;
                        }
                        _searchController.text = _searchValue.toString();
                      });
                      _calculateResult();
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: _searchType == SearchType.signal
                        ? 'Valeur du signal'
                        : 'Valeur physique',
                    controller: _searchController,
                    suffix: _searchType == SearchType.signal
                        ? _selectedSignal.unit
                        : _unitValue,
                    onChanged: (value) {
                      _searchValue = double.tryParse(value) ?? 0.0;
                      _calculateResult();
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Résultat
            if (_hasError)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _resultDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
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
}
