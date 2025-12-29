import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';

abstract class RefrigerantChargeRepository {
  Future<Either<Failure, ChargeResult>> calculateCharge(
    ChargeParameters parameters,
  );
  Future<Either<Failure, List<Fluid>>> getAvailableFluids();
}
