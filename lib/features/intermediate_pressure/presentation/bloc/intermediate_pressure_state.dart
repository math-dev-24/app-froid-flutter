import 'package:equatable/equatable.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';

abstract class IntermediatePressureState extends Equatable {
  const IntermediatePressureState();

  @override
  List<Object> get props => [];
}

class IntermediatePressureInitial extends IntermediatePressureState {}

class IntermediatePressureLoading extends IntermediatePressureState {}

class IntermediatePressureLoaded extends IntermediatePressureState {
  final PressureResult result;

  const IntermediatePressureLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class IntermediatePressureError extends IntermediatePressureState {
  final String message;

  const IntermediatePressureError(this.message);

  @override
  List<Object> get props => [message];
}
