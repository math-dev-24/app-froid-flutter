import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/interpolation_points.dart';
import '../entities/interpolation_result.dart';

/// Interface du repository d'interpolation
abstract class InterpolationRepository {
  Either<Failure, InterpolationResult> calculate(InterpolationPoints points);
}
