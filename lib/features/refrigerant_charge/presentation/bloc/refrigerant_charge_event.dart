import 'package:equatable/equatable.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';

abstract class RefrigerantChargeEvent extends Equatable {
  const RefrigerantChargeEvent();

  @override
  List<Object> get props => [];
}

class LoadFluidsEvent extends RefrigerantChargeEvent {}

class CalculateChargeEvent extends RefrigerantChargeEvent {
  final ChargeParameters parameters;

  const CalculateChargeEvent(this.parameters);

  @override
  List<Object> get props => [parameters];
}
