import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/test_parameters.dart';
import '../../domain/entities/test_result.dart';
import '../../domain/repositories/nitrogen_test_repository.dart';
import '../datasources/nitrogen_test_local_datasource.dart';

/// Implémentation du repository de test d'azote
class NitrogenTestRepositoryImpl implements NitrogenTestRepository {
  final NitrogenTestLocalDataSource localDataSource;

  NitrogenTestRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, TestResult> calculate(TestParameters parameters) {
    try {
      final result = localDataSource.calculate(parameters);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Erreur de calcul: ${e.toString()}'));
    }
  }
}
