import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';

abstract class LflVolumeRepository {
  Future<Either<Failure, LflResult>> calculateLflVolume(
    LflParameters parameters,
    double safetyFactor,
  );
  Future<Either<Failure, List<FlammableFluid>>> getAvailableFluids();
}
