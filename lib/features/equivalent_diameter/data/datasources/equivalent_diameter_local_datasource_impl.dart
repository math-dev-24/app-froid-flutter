import 'dart:math';

import '../../domain/entities/duct_dimensions.dart';
import '../models/diameter_result_model.dart';
import 'equivalent_diameter_local_datasource.dart';

/// Implémentation de la source de données locale pour le diamètre équivalent
class EquivalentDiameterLocalDataSourceImpl
    implements EquivalentDiameterLocalDataSource {
  @override
  DiameterResultModel calculate(DuctDimensions dimensions) {
    // Formule du diamètre équivalent: 1.265 * ((L³ * H³)/(L + H))^0.2
    final equivalentDiameter = 1.265 *
        pow(
          (pow(dimensions.width, 3) * pow(dimensions.height, 3)) /
              (dimensions.width + dimensions.height),
          0.2,
        );

    // Arrondir à 3 décimales
    final roundedDiameter = (equivalentDiameter * 1000).round() / 1000;

    // Calcul de la section rectangulaire
    final rectangularSection = dimensions.width * dimensions.height;
    final roundedRectangularSection = (rectangularSection * 1000).round() / 1000;

    // Calcul de la section circulaire équivalente
    final circularSection = pi * pow(roundedDiameter / 2, 2);
    final roundedCircularSection = (circularSection * 1000).round() / 1000;

    // Rapport entre les sections (en pourcentage)
    final sectionRatioPercent =
        ((roundedCircularSection / roundedRectangularSection) * 100).round();

    return DiameterResultModel(
      equivalentDiameter: roundedDiameter,
      rectangularSection: roundedRectangularSection,
      circularSection: roundedCircularSection,
      sectionRatioPercent: sectionRatioPercent,
    );
  }
}
