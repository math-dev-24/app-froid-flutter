import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/diameter_result.dart';
import '../entities/duct_dimensions.dart';

/// Interface du repository de diamètre équivalent
abstract class EquivalentDiameterRepository {
  Either<Failure, DiameterResult> calculate(DuctDimensions dimensions);
}
