import 'package:equatable/equatable.dart';

import '../../domain/entities/conversion_direction.dart';
import '../../domain/entities/signal_type.dart';

abstract class SensorSignalEvent extends Equatable {
  const SensorSignalEvent();
  @override
  List<Object> get props => [];
}

class ConvertSignalEvent extends SensorSignalEvent {
  final SignalType signalType;
  final double minValue;
  final double maxValue;
  final String valueUnit;
  final double searchValue;
  final ConversionDirection direction;

  const ConvertSignalEvent({
    required this.signalType,
    required this.minValue,
    required this.maxValue,
    required this.valueUnit,
    required this.searchValue,
    required this.direction,
  });

  @override
  List<Object> get props => [signalType, minValue, maxValue, valueUnit, searchValue, direction];
}
