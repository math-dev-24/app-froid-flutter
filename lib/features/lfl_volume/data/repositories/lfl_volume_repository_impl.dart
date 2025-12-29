import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/lfl_volume/data/datasources/lfl_volume_local_datasource.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';
import 'package:app_froid/features/lfl_volume/domain/repositories/lfl_volume_repository.dart';

class LflVolumeRepositoryImpl implements LflVolumeRepository {
  final LflVolumeLocalDataSource localDataSource;

  LflVolumeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, LflResult>> calculateLflVolume(
    LflParameters parameters,
    double safetyFactor,
  ) async {
    try {
      final result =
          await localDataSource.calculateLflVolume(parameters, safetyFactor);
      return Right(result);
    } catch (e) {
      return Left(CalculationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FlammableFluid>>> getAvailableFluids() async {
    try {
      final fluids = await localDataSource.getAvailableFluids();
      return Right(fluids);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
