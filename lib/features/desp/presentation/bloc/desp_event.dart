import 'package:equatable/equatable.dart';

import '../../domain/entities/equipment_type.dart';
import '../../domain/entities/fluid_nature.dart';

abstract class DespEvent extends Equatable {
  const DespEvent();
  @override
  List<Object> get props => [];
}

class CalculateDespEvent extends DespEvent {
  final EquipmentType equipmentType;
  final FluidNature fluidNature;
  final int dangerGroup;
  final double pressure;
  final double volume;
  final double nominalDiameter;

  const CalculateDespEvent({
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
