import 'package:equatable/equatable.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';

abstract class RefrigerantChargeState extends Equatable {
  const RefrigerantChargeState();

  @override
  List<Object?> get props => [];
}

class RefrigerantChargeInitial extends RefrigerantChargeState {}

class RefrigerantChargeLoading extends RefrigerantChargeState {}

class FluidsLoaded extends RefrigerantChargeState {
  final List<Fluid> fluids;

  const FluidsLoaded(this.fluids);

  @override
  List<Object> get props => [fluids];
}

class ChargeCalculated extends RefrigerantChargeState {
  final List<Fluid> fluids;
  final ChargeResult result;

  const ChargeCalculated({
    required this.fluids,
    required this.result,
  });

  @override
  List<Object> get props => [fluids, result];
}

class RefrigerantChargeError extends RefrigerantChargeState {
  final String message;

  const RefrigerantChargeError(this.message);

  @override
  List<Object> get props => [message];
}
