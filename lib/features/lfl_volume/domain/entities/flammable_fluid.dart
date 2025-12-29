import 'package:equatable/equatable.dart';

class LflRange extends Equatable {
  final double lower;
  final double upper;

  const LflRange({required this.lower, required this.upper});

  @override
  List<Object?> get props => [lower, upper];
}

class FlammableFluid extends Equatable {
  final String refName;
  final String name;
  final String classification;
  final String description;
  final LflRange lfl;

  const FlammableFluid({
    required this.refName,
    required this.name,
    required this.classification,
    required this.description,
    required this.lfl,
  });

  @override
  List<Object?> get props => [refName, name, classification, description, lfl];
}
