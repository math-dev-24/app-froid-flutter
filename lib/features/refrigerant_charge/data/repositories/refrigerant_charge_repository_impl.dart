import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/refrigerant_charge/data/datasources/refrigerant_charge_local_datasource.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';
import 'package:app_froid/features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';

class RefrigerantChargeRepositoryImpl implements RefrigerantChargeRepository {
  final RefrigerantChargeLocalDataSource localDataSource;

  RefrigerantChargeRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ChargeResult>> calculateCharge(
    ChargeParameters parameters,
  ) async {
    try {
      final result = await localDataSource.calculateCharge(parameters);
      return Right(result);
    } catch (e) {
      return Left(CalculationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Fluid>>> getAvailableFluids() async {
    try {
      final fluids = await localDataSource.getAvailableFluids();
      return Right(fluids);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
