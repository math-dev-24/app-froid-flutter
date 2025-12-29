import 'package:app_froid/core/error/exceptions.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/refrigerant_charge/data/datasources/refrigerant_charge_local_datasource.dart';
import 'package:app_froid/features/refrigerant_charge/data/models/charge_result_model.dart';
import 'package:app_froid/features/refrigerant_charge/data/models/fluid_model.dart';
import 'package:app_froid/features/refrigerant_charge/data/repositories/refrigerant_charge_repository_impl.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refrigerant_charge_repository_impl_test.mocks.dart';

@GenerateMocks([RefrigerantChargeLocalDataSource])
void main() {
  late RefrigerantChargeRepositoryImpl repository;
  late MockRefrigerantChargeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockRefrigerantChargeLocalDataSource();
    repository = RefrigerantChargeRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('getAvailableFluids', () {
    const tFluidModels = [
      FluidModel(id: 'R410A', label: 'R410A', desp: 1, lfl: 0.44, gwp: 2088),
      FluidModel(id: 'R32', label: 'R32', desp: 2, lfl: 0.307, gwp: 675),
    ];

    test('should return fluids when the call to local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.getAvailableFluids())
          .thenAnswer((_) async => tFluidModels);

      // act
      final result = await repository.getAvailableFluids();

      // assert
      verify(mockLocalDataSource.getAvailableFluids());
      expect(result, equals(const Right(tFluidModels)));
    });

    test('should return CalculationFailure when the call to local data source throws', () async {
      // arrange
      when(mockLocalDataSource.getAvailableFluids())
          .thenThrow(const CalculationException('Failed to load fluids'));

      // act
      final result = await repository.getAvailableFluids();

      // assert
      verify(mockLocalDataSource.getAvailableFluids());
      expect(result, equals(const Left(CalculationFailure('Failed to load fluids'))));
    });
  });

  group('calculateCharge', () {
    const tParameters = ChargeParameters(
      fluidId: 'R32',
      lfl: 0.307,
      application: Application.confort,
      access: AccessConfort.general,
      classification: Classification.deux,
      volume: 20.0,
    );

    const tChargeResultModel = ChargeResultModel(
      factorM1: 2.46,
      factorM2: 15.96,
      factorM3: 79.82,
      chargeLimit: 2.46,
      message: null,
    );

    test('should return charge result when calculation is successful', () async {
      // arrange
      when(mockLocalDataSource.calculateCharge(any))
          .thenAnswer((_) async => tChargeResultModel);

      // act
      final result = await repository.calculateCharge(tParameters);

      // assert
      verify(mockLocalDataSource.calculateCharge(tParameters));
      expect(result, equals(const Right(tChargeResultModel)));
    });

    test('should return CalculationFailure when calculation throws exception', () async {
      // arrange
      when(mockLocalDataSource.calculateCharge(any))
          .thenThrow(const CalculationException('Calculation failed'));

      // act
      final result = await repository.calculateCharge(tParameters);

      // assert
      verify(mockLocalDataSource.calculateCharge(tParameters));
      expect(result, equals(const Left(CalculationFailure('Calculation failed'))));
    });
  });
}
