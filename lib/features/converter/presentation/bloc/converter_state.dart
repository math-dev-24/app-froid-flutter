import 'package:equatable/equatable.dart';

import '../../domain/entities/conversion.dart';
import '../../domain/entities/conversion_type.dart';

/// États du Bloc Converter
abstract class ConverterState extends Equatable {
  final ConversionType activeTab;

  const ConverterState({required this.activeTab});

  @override
  List<Object> get props => [activeTab];
}

/// État initial - pas de conversion effectuée
class ConverterInitial extends ConverterState {
  const ConverterInitial({
    super.activeTab = ConversionType.pressure,
  });
}

/// État avec résultats de conversion
class ConverterLoaded extends ConverterState {
  final List<Conversion> conversions;

  const ConverterLoaded({
    required this.conversions,
    required super.activeTab,
  });

  @override
  List<Object> get props => [conversions, activeTab];
}

/// État d'erreur
class ConverterError extends ConverterState {
  final String message;

  const ConverterError({
    required this.message,
    required super.activeTab,
  });

  @override
  List<Object> get props => [message, activeTab];
}
