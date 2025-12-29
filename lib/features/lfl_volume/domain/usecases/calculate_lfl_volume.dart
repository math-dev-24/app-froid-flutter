import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';
import 'package:app_froid/features/lfl_volume/domain/repositories/lfl_volume_repository.dart';

class CalculateLflVolumeParams extends Equatable {
  final LflParameters parameters;
  final double safetyFactor;

  const CalculateLflVolumeParams({
    required this.parameters,
    required this.safetyFactor,
  });

  @override
  List<Object?> get props => [parameters, safetyFactor];
}

class CalculateLflVolume
    implements UseCase<LflResult, CalculateLflVolumeParams> {
  final LflVolumeRepository repository;

  CalculateLflVolume(this.repository);

  @override
  Future<Either<Failure, LflResult>> call(
    CalculateLflVolumeParams params,
  ) async {
    return await repository.calculateLflVolume(
      params.parameters,
      params.safetyFactor,
    );
  }
}
