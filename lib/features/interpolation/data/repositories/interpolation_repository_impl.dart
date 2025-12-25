import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/interpolation_points.dart';
import '../../domain/entities/interpolation_result.dart';
import '../../domain/repositories/interpolation_repository.dart';
import '../datasources/interpolation_local_datasource.dart';

/// Implémentation du repository d'interpolation
class InterpolationRepositoryImpl implements InterpolationRepository {
  final InterpolationLocalDataSource localDataSource;

  InterpolationRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, InterpolationResult> calculate(InterpolationPoints points) {
    try {
      final result = localDataSource.calculate(points);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Erreur de calcul: ${e.toString()}'));
    }
  }
}
