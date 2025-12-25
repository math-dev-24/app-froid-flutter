import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/test_parameters.dart';
import '../entities/test_result.dart';

/// Interface du repository de test d'azote
abstract class NitrogenTestRepository {
  Either<Failure, TestResult> calculate(TestParameters parameters);
}
