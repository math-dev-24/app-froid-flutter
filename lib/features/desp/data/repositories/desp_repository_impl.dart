import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/desp_parameters.dart';
import '../../domain/entities/desp_result.dart';
import '../../domain/repositories/desp_repository.dart';
import '../datasources/desp_local_datasource.dart';

/// Implémentation du repository DESP
class DespRepositoryImpl implements DespRepository {
  final DespLocalDataSource localDataSource;

  DespRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, DespResult> calculate(DespParameters parameters) {
    try {
      final result = localDataSource.calculate(parameters);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Erreur de calcul: ${e.toString()}'));
    }
  }
}
