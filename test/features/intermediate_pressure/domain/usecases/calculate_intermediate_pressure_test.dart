import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';
import 'package:app_froid/features/intermediate_pressure/domain/repositories/intermediate_pressure_repository.dart';
import 'package:app_froid/features/intermediate_pressure/domain/usecases/calculate_intermediate_pressure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_intermediate_pressure_test.mocks.dart';

@GenerateMocks([IntermediatePressureRepository])
void main() {
  late CalculateIntermediatePressure usecase;
  late MockIntermediatePressureRepository mockRepository;

  setUp(() {
    mockRepository = MockIntermediatePressureRepository();
    usecase = CalculateIntermediatePressure(mockRepository);
  });

  const tParameters = PressureParameters(
    highPressure: 20.0,
    lowPressure: 5.0,
  );

  const tResult = PressureResult(
    intermediateEqualEfficiency: 10.0,
    intermediateSandHold: 10.35,
    compressionRatioHPEqual: 2.0,
    compressionRatioBPEqual: 2.0,
    compressionRatioHPSandHold: 1.93,
    compressionRatioBPSandHold: 2.07,
  );

  test('should calculate intermediate pressure from repository', () async {
    // arrange
    when(mockRepository.calculateIntermediatePressure(any))
        .thenAnswer((_) async => const Right(tResult));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Right(tResult));
    verify(mockRepository.calculateIntermediatePressure(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when calculation fails', () async {
    // arrange
    const tFailure = CalculationFailure('Calculation error');
    when(mockRepository.calculateIntermediatePressure(any))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.calculateIntermediatePressure(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
