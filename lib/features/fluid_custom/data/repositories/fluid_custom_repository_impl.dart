import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/fluid_custom.dart';
import '../../domain/repositories/fluid_custom_repository.dart';
import '../datasources/fluid_custom_local_datasource.dart';
import '../models/fluid_custom_model.dart';

/// Implémentation du repository pour les fluides personnalisés
class FluidCustomRepositoryImpl implements FluidCustomRepository {
  final FluidCustomLocalDataSource localDataSource;

  FluidCustomRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FluidCustom>>> getFluidCustoms() async {
    try {
      final fluids = await localDataSource.getFluidCustoms();
      return Right(fluids);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveFluidCustoms(
      List<FluidCustom> fluids) async {
    try {
      final models =
          fluids.map((f) => FluidCustomModel.fromEntity(f)).toList();
      await localDataSource.saveFluidCustoms(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addFluidCustom(FluidCustom fluid) async {
    try {
      final model = FluidCustomModel.fromEntity(fluid);
      await localDataSource.addFluidCustom(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateFluidCustom(
      int index, FluidCustom fluid) async {
    try {
      final model = FluidCustomModel.fromEntity(fluid);
      await localDataSource.updateFluidCustom(index, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFluidCustom(int index) async {
    try {
      await localDataSource.removeFluidCustom(index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
