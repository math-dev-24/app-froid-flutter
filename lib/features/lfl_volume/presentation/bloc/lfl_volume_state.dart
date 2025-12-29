import 'package:equatable/equatable.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';

abstract class LflVolumeState extends Equatable {
  const LflVolumeState();

  @override
  List<Object?> get props => [];
}

class LflVolumeInitial extends LflVolumeState {}

class LflVolumeLoading extends LflVolumeState {}

class FluidsLoaded extends LflVolumeState {
  final List<FlammableFluid> fluids;

  const FluidsLoaded(this.fluids);

  @override
  List<Object> get props => [fluids];
}

class LflVolumeCalculated extends LflVolumeState {
  final List<FlammableFluid> fluids;
  final LflResult result;

  const LflVolumeCalculated({
    required this.fluids,
    required this.result,
  });

  @override
  List<Object> get props => [fluids, result];
}

class LflVolumeError extends LflVolumeState {
  final String message;

  const LflVolumeError(this.message);

  @override
  List<Object> get props => [message];
}
