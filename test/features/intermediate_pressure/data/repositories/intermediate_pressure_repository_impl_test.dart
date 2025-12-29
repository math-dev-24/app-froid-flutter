import 'package:app_froid/core/error/exceptions.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/intermediate_pressure/data/datasources/intermediate_pressure_local_datasource.dart';
import 'package:app_froid/features/intermediate_pressure/data/models/pressure_result_model.dart';
import 'package:app_froid/features/intermediate_pressure/data/repositories/intermediate_pressure_repository_impl.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'intermediate_pressure_repository_impl_test.mocks.dart';

@GenerateMocks([IntermediatePressureLocalDataSource])
void main() {
  late IntermediatePressureRepositoryImpl repository;
  late MockIntermediatePressureLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockIntermediatePressureLocalDataSource();
    repository = IntermediatePressureRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('calculateIntermediatePressure', () {
    const tParameters = PressureParameters(
      highPressure: 20.0,
      lowPressure: 5.0,
    );

    const tResultModel = PressureResultModel(
      intermediateEqualEfficiency: 10.0,
      intermediateSandHold: 10.35,
      compressionRatioHPEqual: 2.0,
      compressionRatioBPEqual: 2.0,
      compressionRatioHPSandHold: 1.93,
      compressionRatioBPSandHold: 2.07,
    );

    test('should return result when calculation is successful', () async {
      // arrange
      when(mockLocalDataSource.calculateIntermediatePressure(any))
          .thenAnswer((_) async => tResultModel);

      // act
      final result = await repository.calculateIntermediatePressure(tParameters);

      // assert
      verify(mockLocalDataSource.calculateIntermediatePressure(tParameters));
      expect(result, equals(const Right(tResultModel)));
    });

    test('should return CalculationFailure when calculation throws exception', () async {
      // arrange
      when(mockLocalDataSource.calculateIntermediatePressure(any))
          .thenThrow(const CalculationException('Calculation failed'));

      // act
      final result = await repository.calculateIntermediatePressure(tParameters);

      // assert
      verify(mockLocalDataSource.calculateIntermediatePressure(tParameters));
      expect(result, equals(const Left(CalculationFailure('Calculation failed'))));
    });
  });
}
