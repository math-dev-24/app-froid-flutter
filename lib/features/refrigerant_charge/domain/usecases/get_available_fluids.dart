import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';
import 'package:app_froid/features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';

class GetAvailableFluids implements UseCase<List<Fluid>, NoParams> {
  final RefrigerantChargeRepository repository;

  GetAvailableFluids(this.repository);

  @override
  Future<Either<Failure, List<Fluid>>> call(NoParams params) async {
    return await repository.getAvailableFluids();
  }
}
