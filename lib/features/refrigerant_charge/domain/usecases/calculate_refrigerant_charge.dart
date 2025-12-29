import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';

class CalculateRefrigerantCharge
    implements UseCase<ChargeResult, ChargeParameters> {
  final RefrigerantChargeRepository repository;

  CalculateRefrigerantCharge(this.repository);

  @override
  Future<Either<Failure, ChargeResult>> call(
    ChargeParameters params,
  ) async {
    return await repository.calculateCharge(params);
  }
}
