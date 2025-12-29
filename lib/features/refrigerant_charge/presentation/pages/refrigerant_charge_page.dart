import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/core/di/injection_container.dart' as di;
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_bloc.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_event.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_state.dart';

class RefrigerantChargePage extends StatelessWidget {
  const RefrigerantChargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<RefrigerantChargeBloc>()..add(LoadFluidsEvent()),
      child: const RefrigerantChargeView(),
    );
  }
}

class RefrigerantChargeView extends StatefulWidget {
  const RefrigerantChargeView({super.key});

  @override
  State<RefrigerantChargeView> createState() => _RefrigerantChargeViewState();
}

class _RefrigerantChargeViewState extends State<RefrigerantChargeView> {
  Application _application = Application.confort;
  AccessConfort _accessConfort = AccessConfort.general;
  AccessRefrigeration _accessRefrigeration = AccessRefrigeration.general;
  Classification _classification = Classification.un;
  Fluid? _selectedFluid;
  double _volume = 0;

  final TextEditingController _volumeController =
      TextEditingController(text: '0');

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  void _calculate(Fluid fluid) {
    context.read<RefrigerantChargeBloc>().add(
          CalculateChargeEvent(
            ChargeParameters(
              fluidId: fluid.id,
              lfl: fluid.lfl,
              application: _application,
              access: _application == Application.confort
                  ? _accessConfort
                  : _accessRefrigeration,
              classification: _classification,
              volume: _volume > 0 ? _volume : null,
            ),
          ),
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
          'Calcul de Charge',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocConsumer<RefrigerantChargeBloc, RefrigerantChargeState>(
        listener: (context, state) {
          if (state is FluidsLoaded && _selectedFluid == null) {
            setState(() {
              _selectedFluid = state.fluids.first;
            });
          }
        },
        builder: (context, state) {
          if (state is RefrigerantChargeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RefrigerantChargeError) {
            return Center(
              child: Text(
                'Erreur: ${state.message}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          final fluids = state is FluidsLoaded
              ? state.fluids
              : state is ChargeCalculated
                  ? state.fluids
                  : <Fluid>[];

          if (fluids.isEmpty) {
            return const Center(child: Text('Aucun fluide disponible'));
          }

          _selectedFluid ??= fluids.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                _buildSection(
                  colorScheme: colorScheme,
                  title: 'Application',
                  child: _buildDropdown<Application>(
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
                      if (_selectedFluid != null) _calculate(_selectedFluid!);
                    },
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  colorScheme: colorScheme,
                  title: 'Catégorie d\'accès',
                  child: _application == Application.confort
                      ? _buildDropdown<AccessConfort>(
                          value: _accessConfort,
                          items: AccessConfort.values,
                          onChanged: (value) {
                            setState(() => _accessConfort = value!);
                            if (_selectedFluid != null) _calculate(_selectedFluid!);
                          },
                          colorScheme: colorScheme,
                        )
                      : _buildDropdown<AccessRefrigeration>(
                          value: _accessRefrigeration,
                          items: AccessRefrigeration.values,
                          onChanged: (value) {
                            setState(() => _accessRefrigeration = value!);
                            if (_selectedFluid != null) _calculate(_selectedFluid!);
                          },
                          colorScheme: colorScheme,
                        ),
                ),
                const SizedBox(height: 16),
                _buildFluidSection(colorScheme, fluids),
                const SizedBox(height: 16),
                _buildSection(
                  colorScheme: colorScheme,
                  title: 'Classification',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdown<Classification>(
                        value: _classification,
                        items: Classification.values,
                        onChanged: (value) {
                          setState(() => _classification = value!);
                          if (_selectedFluid != null) _calculate(_selectedFluid!);
                        },
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getClassificationDescription(_classification),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (state is ChargeCalculated) ...[
                  if (state.result.message != null)
                    _buildInfoMessage(colorScheme, state.result.message!)
                  else if (state.result.chargeLimit != null)
                    _buildChargeLimit(
                        colorScheme, state.result.chargeLimit!)
                  else
                    _buildVolumeInput(colorScheme),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required ColorScheme colorScheme,
    required String title,
    required Widget child,
  }) {
    return Container(
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
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildFluidSection(ColorScheme colorScheme, List<Fluid> fluids) {
    return _buildSection(
      colorScheme: colorScheme,
      title: 'Fluide frigorigène',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFluidDropdown(fluids, colorScheme),
          const SizedBox(height: 12),
          _buildFluidInfo(colorScheme),
          const SizedBox(height: 12),
          _buildFactorTable(colorScheme),
        ],
      ),
    );
  }

  Widget _buildFluidDropdown(List<Fluid> fluids, ColorScheme colorScheme) {
    return Container(
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
            setState(() => _selectedFluid = value);
            if (value != null) _calculate(value);
          },
        ),
      ),
    );
  }

  Widget _buildFluidInfo(ColorScheme colorScheme) {
    if (_selectedFluid == null) return const SizedBox.shrink();

    return Container(
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
              'LFL = ${_selectedFluid!.lfl} kg/m³ - GWP = ${_selectedFluid!.gwp}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorTable(ColorScheme colorScheme) {
    if (_selectedFluid == null) return const SizedBox.shrink();

    final factorM1 = ((_selectedFluid!.lfl * 4) * 100).round() / 100;
    final factorM2 = ((_selectedFluid!.lfl * 26) * 100).round() / 100;
    final factorM3 = ((_selectedFluid!.lfl * 130) * 100).round() / 100;

    return Container(
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
          _buildFactorRow('M1', factorM1, colorScheme),
          _buildFactorRow('M2', factorM2, colorScheme),
          _buildFactorRow('M3', factorM3, colorScheme),
        ],
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

  Widget _buildInfoMessage(ColorScheme colorScheme, String message) {
    return Container(
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
          const Icon(
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
                  message,
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
    );
  }

  Widget _buildChargeLimit(ColorScheme colorScheme, double chargeLimit) {
    return Container(
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
          const Icon(
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
                  'Charge = $chargeLimit kg',
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
    );
  }

  Widget _buildVolumeInput(ColorScheme colorScheme) {
    return _buildSection(
      colorScheme: colorScheme,
      title: 'Volume',
      child: TextFormField(
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          setState(() => _volume = double.tryParse(value) ?? 0.0);
          if (_selectedFluid != null) _calculate(_selectedFluid!);
        },
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
              itemLabel = _getApplicationLabel(item);
            } else if (item is AccessConfort) {
              itemLabel = _getAccessConfortLabel(item);
            } else if (item is AccessRefrigeration) {
              itemLabel = _getAccessRefrigerationLabel(item);
            } else if (item is Classification) {
              itemLabel = _getClassificationLabel(item);
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

  String _getApplicationLabel(Application app) {
    switch (app) {
      case Application.confort:
        return 'Confort';
      case Application.refrigeration:
        return 'Réfrigération';
    }
  }

  String _getAccessConfortLabel(AccessConfort access) {
    switch (access) {
      case AccessConfort.general:
        return 'Accès général';
      case AccessConfort.surveille:
        return 'Accès surveillé';
      case AccessConfort.reserveD1:
        return 'Accès réserve';
    }
  }

  String _getAccessRefrigerationLabel(AccessRefrigeration access) {
    switch (access) {
      case AccessRefrigeration.general:
        return 'Accès général';
      case AccessRefrigeration.surveille:
        return 'Accès surveillé';
      case AccessRefrigeration.reserveD1:
        return 'Accès réserve ( >= 1 pers / 10m²)';
      case AccessRefrigeration.reserveD2:
        return 'Accès réserve ( < 1 pers / 10m²)';
    }
  }

  String _getClassificationLabel(Classification classification) {
    switch (classification) {
      case Classification.un:
        return 'Classe I';
      case Classification.deux:
        return 'Classe II';
      case Classification.trois:
        return 'Classe III';
      case Classification.quatre:
        return 'Classe IV';
    }
  }

  String _getClassificationDescription(Classification classification) {
    switch (classification) {
      case Classification.un:
        return 'Equipement dans un espace occupé (monobloc, groupe logé, ...)';
      case Classification.deux:
        return 'Compresseur à l\'air libre ou dans salle des machines (groupe de condensation, centrale, ...)';
      case Classification.trois:
        return 'Système complet à l\'air libre ou salle des machines (Chiller, rooftop, ...)';
      case Classification.quatre:
        return 'Enceinte ventilé (fluide maintenu dans une enceinte confinée)';
    }
  }
}
