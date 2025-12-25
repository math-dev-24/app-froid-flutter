import 'package:equatable/equatable.dart';

/// Entité représentant le résultat d'une interpolation
class InterpolationResult extends Equatable {
  final double y;
  final bool isOutOfRange;
  final String? warningMessage;

  const InterpolationResult({
    required this.y,
    required this.isOutOfRange,
    this.warningMessage,
  });

  @override
  List<Object?> get props => [y, isOutOfRange, warningMessage];
}
