import 'package:equatable/equatable.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';

abstract class LflVolumeEvent extends Equatable {
  const LflVolumeEvent();

  @override
  List<Object> get props => [];
}

class LoadFluidsEvent extends LflVolumeEvent {}

class CalculateLflVolumeEvent extends LflVolumeEvent {
  final LflParameters parameters;
  final double safetyFactor;

  const CalculateLflVolumeEvent({
    required this.parameters,
    required this.safetyFactor,
  });

  @override
  List<Object> get props => [parameters, safetyFactor];
}
