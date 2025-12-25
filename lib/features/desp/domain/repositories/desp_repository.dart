import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/desp_parameters.dart';
import '../entities/desp_result.dart';

/// Interface du repository DESP
abstract class DespRepository {
  Either<Failure, DespResult> calculate(DespParameters parameters);
}
