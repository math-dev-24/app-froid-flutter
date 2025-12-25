import 'package:equatable/equatable.dart';

import '../../domain/entities/conversion_type.dart';

/// Événements du Bloc Converter
abstract class ConverterEvent extends Equatable {
  const ConverterEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour changer l'onglet actif (pression/température)
class ChangeTabEvent extends ConverterEvent {
  final ConversionType tab;

  const ChangeTabEvent(this.tab);

  @override
  List<Object> get props => [tab];
}

/// Événement pour convertir une pression
class ConvertPressureEvent extends ConverterEvent {
  final double value;
  final String fromUnit;

  const ConvertPressureEvent({
    required this.value,
    required this.fromUnit,
  });

  @override
  List<Object> get props => [value, fromUnit];
}

/// Événement pour convertir une température
class ConvertTemperatureEvent extends ConverterEvent {
  final double value;
  final String fromUnit;

  const ConvertTemperatureEvent({
    required this.value,
    required this.fromUnit,
  });

  @override
  List<Object> get props => [value, fromUnit];
}
