import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/diameter_result.dart';
import '../../domain/entities/duct_dimensions.dart';
import '../../domain/repositories/equivalent_diameter_repository.dart';
import '../datasources/equivalent_diameter_local_datasource.dart';

/// Implémentation du repository de diamètre équivalent
class EquivalentDiameterRepositoryImpl implements EquivalentDiameterRepository {
  final EquivalentDiameterLocalDataSource localDataSource;

  EquivalentDiameterRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, DiameterResult> calculate(DuctDimensions dimensions) {
    try {
      final result = localDataSource.calculate(dimensions);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Erreur de calcul: ${e.toString()}'));
    }
  }
}
