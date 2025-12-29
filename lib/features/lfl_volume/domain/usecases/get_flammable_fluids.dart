import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/repositories/lfl_volume_repository.dart';

class GetFlammableFluids implements UseCase<List<FlammableFluid>, NoParams> {
  final LflVolumeRepository repository;

  GetFlammableFluids(this.repository);

  @override
  Future<Either<Failure, List<FlammableFluid>>> call(NoParams params) async {
    return await repository.getAvailableFluids();
  }
}
