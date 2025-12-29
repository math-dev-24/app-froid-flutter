import 'package:equatable/equatable.dart';

class LflParameters extends Equatable {
  final String fluidRefName;
  final double fluidCharge;
  final double ambientTemperature;
  final double density;
  final double lflLower;

  const LflParameters({
    required this.fluidRefName,
    required this.fluidCharge,
    required this.ambientTemperature,
    required this.density,
    required this.lflLower,
  });

  @override
  List<Object?> get props => [
        fluidRefName,
        fluidCharge,
        ambientTemperature,
        density,
        lflLower,
      ];
}
