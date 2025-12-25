import 'package:equatable/equatable.dart';

import '../../domain/entities/desp_result.dart';
import '../../domain/entities/equipment_type.dart';
import '../../domain/entities/fluid_nature.dart';

abstract class DespState extends Equatable {
  const DespState();
  @override
  List<Object> get props => [];
}

class DespInitial extends DespState {
  const DespInitial();
}

class DespLoaded extends DespState {
  final DespResult result;
  final EquipmentType equipmentType;
  final FluidNature fluidNature;
  final int dangerGroup;

  const DespLoaded({
    required this.result,
    required this.equipmentType,
    required this.fluidNature,
    required this.dangerGroup,
  });

  @override
  List<Object> get props => [result, equipmentType, fluidNature, dangerGroup];
}

class DespError extends DespState {
  final String message;

  const DespError({required this.message});

  @override
  List<Object> get props => [message];
}
