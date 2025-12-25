import 'package:equatable/equatable.dart';

import 'equipment_type.dart';
import 'fluid_nature.dart';

/// Paramètres pour le calcul DESP
class DespParameters extends Equatable {
  final EquipmentType equipmentType;
  final FluidNature fluidNature;
  final int dangerGroup;
  final double pressure;
  final double volume;
  final double nominalDiameter;

  const DespParameters({
    required this.equipmentType,
    required this.fluidNature,
    required this.dangerGroup,
    required this.pressure,
    required this.volume,
    required this.nominalDiameter,
  });

  @override
  List<Object> get props => [
        equipmentType,
        fluidNature,
        dangerGroup,
        pressure,
        volume,
        nominalDiameter,
      ];
}
