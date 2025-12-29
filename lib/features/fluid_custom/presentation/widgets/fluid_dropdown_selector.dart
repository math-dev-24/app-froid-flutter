import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../ruler/data/datasources/fluids_local_data.dart';
import '../../../ruler/domain/entities/fluid.dart';
import '../../domain/entities/fluid_custom.dart';
import '../bloc/fluid_custom_bloc.dart';
import '../bloc/fluid_custom_event.dart';
import '../bloc/fluid_custom_state.dart';

/// Sélecteur de fluide universel pour toute l'application
///
/// Combine les fluides de base (59 fluides) ET les fluides personnalisés
/// S'utilise comme un DropdownButton classique mais avec fluides + customs
class FluidDropdownSelector extends StatefulWidget {
  /// Fluide actuellement sélectionné
  final Fluid value;

  /// Callback appelé quand le fluide change
  final ValueChanged<Fluid> onChanged;

  /// Style du dropdown (optionnel)
  final TextStyle? textStyle;

  /// Couleur de l'icône (optionnel)
  final Color? iconColor;

  /// Afficher le bouton pour créer un fluide custom
  final bool showCustomButton;

  const FluidDropdownSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.textStyle,
    this.iconColor,
    this.showCustomButton = true,
  });

  @override
  State<FluidDropdownSelector> createState() => _FluidDropdownSelectorState();
}

class _FluidDropdownSelectorState extends State<FluidDropdownSelector> {
  late FluidCustomBloc _fluidCustomBloc;

  @override
  void initState() {
    super.initState();
    _fluidCustomBloc = getIt<FluidCustomBloc>()
      ..add(const LoadFluidCustomsEvent());
  }

  @override
  void dispose() {
    _fluidCustomBloc.close();
    super.dispose();
  }

  /// Convertit un FluidCustom en Fluid standard
  Fluid _fluidCustomToFluid(FluidCustom custom) {
    // Créer le refName à partir des composants
    final refName = List.generate(custom.fluids.length, (i) {
      return '${custom.fluidsRef[i]}[${custom.quantities[i]}]';
    }).join('&');

    return Fluid(
      name: custom.label,
      refName: refName,
      group: 2, // Par défaut
      classification: 'A1', // Par défaut
      pCrit: null,
      pTriple: null,
      tCrit: null,
      tTriple: null,
    );
  }

  /// Construit la liste combinée : fluides de base + customs
  List<Fluid> _buildCombinedFluidList(List<FluidCustom> customFluids) {
    final baseFluids = FluidsLocalData.fluids;
    final convertedCustoms = customFluids.map(_fluidCustomToFluid).toList();

    return [...baseFluids, ...convertedCustoms];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FluidCustomBloc, FluidCustomState>(
      bloc: _fluidCustomBloc,
      builder: (context, state) {
        List<FluidCustom> customFluids = [];

        if (state is FluidCustomLoaded) {
          customFluids = state.fluids;
        }

        final allFluids = _buildCombinedFluidList(customFluids);

        // Vérifier si la valeur actuelle existe dans la liste
        final currentValue =
            allFluids.any((f) => f.refName == widget.value.refName)
            ? widget.value
            : allFluids.first;

        return Row(
          children: [
            Expanded(
              child: DropdownButton<Fluid>(
                value: currentValue,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: widget.iconColor),
                style: widget.textStyle,
                items: [
                  // Fluides de base
                  ...FluidsLocalData.fluids.map((fluid) {
                    return DropdownMenuItem<Fluid>(
                      value: fluid,
                      child: Text(fluid.name, overflow: TextOverflow.ellipsis),
                    );
                  }),

                  // Séparateur si il y a des customs
                  if (customFluids.isNotEmpty)
                    const DropdownMenuItem<Fluid>(
                      enabled: false,
                      value: null,
                      child: Divider(),
                    ),

                  // Titre "Fluides personnalisés" si il y en a
                  if (customFluids.isNotEmpty)
                    DropdownMenuItem<Fluid>(
                      enabled: false,
                      value: null,
                      child: Text(
                        '── Fluides personnalisés ──',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                  // Fluides personnalisés
                  ...customFluids.map((customFluid) {
                    final fluid = _fluidCustomToFluid(customFluid);
                    return DropdownMenuItem<Fluid>(
                      value: fluid,
                      child: Row(
                        children: [
                          const Icon(Icons.science, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              customFluid.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                onChanged: (Fluid? newValue) {
                  if (newValue != null) {
                    widget.onChanged(newValue);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Version styled pour un usage dans un Container/Card
class StyledFluidDropdownSelector extends StatelessWidget {
  final Fluid value;
  final ValueChanged<Fluid> onChanged;
  final bool showCustomButton;

  const StyledFluidDropdownSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.showCustomButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: FluidDropdownSelector(
          value: value,
          onChanged: onChanged,
          textStyle: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          iconColor: colorScheme.primary,
          showCustomButton: showCustomButton,
        ),
      ),
    );
  }
}
