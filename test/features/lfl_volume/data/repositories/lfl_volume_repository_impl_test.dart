import 'package:app_froid/core/error/exceptions.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/lfl_volume/data/datasources/lfl_volume_local_datasource.dart';
import 'package:app_froid/features/lfl_volume/data/models/flammable_fluid_model.dart';
import 'package:app_froid/features/lfl_volume/data/models/lfl_result_model.dart';
import 'package:app_froid/features/lfl_volume/data/repositories/lfl_volume_repository_impl.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lfl_volume_repository_impl_test.mocks.dart';

@GenerateMocks([LflVolumeLocalDataSource])
void main() {
  late LflVolumeRepositoryImpl repository;
  late MockLflVolumeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLflVolumeLocalDataSource();
    repository = LflVolumeRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('getFlammableFluids', () {
    const tFluids = [
      FlammableFluidModel(
        refName: 'R32',
        name: 'R32',
        classification: 'A2L',
        description: 'Test',
        lfl: LflRange(lower: 14.4, upper: 29.3),
      ),
    ];

    test('should return fluids when successful', () async {
      when(mockLocalDataSource.getFlammableFluids())
          .thenAnswer((_) async => tFluids);

      final result = await repository.getFlammableFluids();

      verify(mockLocalDataSource.getFlammableFluids());
      expect(result, equals(const Right(tFluids)));
    });

    test('should return failure when exception is thrown', () async {
      when(mockLocalDataSource.getFlammableFluids())
          .thenThrow(const CalculationException('Error'));

      final result = await repository.getFlammableFluids();

      verify(mockLocalDataSource.getFlammableFluids());
      expect(result, equals(const Left(CalculationFailure('Error'))));
    });
  });

  group('calculateLflVolume', () {
    const tParameters = LflParameters(
      fluidRefName: 'R32',
      fluidCharge: 5.0,
      ambientTemperature: 25.0,
      density: 2.16,
      lflLower: 14.4,
    );

    const tResult = LflResultModel(
      minimumVolumeM3: 1.6,
      safetyVolumeM3: 2.08,
      density: 2.16,
    );

    test('should return result when calculation succeeds', () async {
      when(mockLocalDataSource.calculateLflVolume(any))
          .thenAnswer((_) async => tResult);

      final result = await repository.calculateLflVolume(tParameters);

      verify(mockLocalDataSource.calculateLflVolume(tParameters));
      expect(result, equals(const Right(tResult)));
    });

    test('should return failure when calculation fails', () async {
      when(mockLocalDataSource.calculateLflVolume(any))
          .thenThrow(const CalculationException('Error'));

      final result = await repository.calculateLflVolume(tParameters);

      verify(mockLocalDataSource.calculateLflVolume(tParameters));
      expect(result, equals(const Left(CalculationFailure('Error'))));
    });
  });
}
