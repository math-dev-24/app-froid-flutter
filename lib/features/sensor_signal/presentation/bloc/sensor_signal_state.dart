import 'package:equatable/equatable.dart';

import '../../domain/entities/sensor_conversion_result.dart';

abstract class SensorSignalState extends Equatable {
  const SensorSignalState();
  @override
  List<Object> get props => [];
}

class SensorSignalInitial extends SensorSignalState {
  const SensorSignalInitial();
}

class SensorSignalLoaded extends SensorSignalState {
  final SensorConversionResult result;

  const SensorSignalLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

class SensorSignalError extends SensorSignalState {
  final String message;

  const SensorSignalError({required this.message});

  @override
  List<Object> get props => [message];
}
