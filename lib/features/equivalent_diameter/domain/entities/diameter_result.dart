import 'package:equatable/equatable.dart';

/// Entité représentant le résultat du calcul de diamètre équivalent
class DiameterResult extends Equatable {
  final double equivalentDiameter;
  final double rectangularSection;
  final double circularSection;
  final int sectionRatioPercent;

  const DiameterResult({
    required this.equivalentDiameter,
    required this.rectangularSection,
    required this.circularSection,
    required this.sectionRatioPercent,
  });

  @override
  List<Object> get props => [
        equivalentDiameter,
        rectangularSection,
        circularSection,
        sectionRatioPercent,
      ];
}
