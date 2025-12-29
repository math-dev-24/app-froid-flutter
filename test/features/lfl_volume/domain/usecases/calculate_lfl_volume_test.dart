import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';
import 'package:app_froid/features/lfl_volume/domain/repositories/lfl_volume_repository.dart';
import 'package:app_froid/features/lfl_volume/domain/usecases/calculate_lfl_volume.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_lfl_volume_test.mocks.dart';

@GenerateMocks([LflVolumeRepository])
void main() {
  late CalculateLflVolume usecase;
  late MockLflVolumeRepository mockRepository;

  setUp(() {
    mockRepository = MockLflVolumeRepository();
    usecase = CalculateLflVolume(mockRepository);
  });

  const tParameters = LflParameters(
    fluidRefName: 'R32',
    fluidCharge: 5.0,
    ambientTemperature: 25.0,
    density: 2.16,
    lflLower: 14.4,
  );

  const tResult = LflResult(
    minimumVolumeM3: 1.6,
    safetyVolumeM3: 2.08,
    density: 2.16,
  );

  test('should calculate LFL volume from repository', () async {
    // arrange
    when(mockRepository.calculateLflVolume(any))
        .thenAnswer((_) async => const Right(tResult));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Right(tResult));
    verify(mockRepository.calculateLflVolume(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when calculation fails', () async {
    // arrange
    const tFailure = CalculationFailure('Calculation error');
    when(mockRepository.calculateLflVolume(any))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.calculateLflVolume(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
