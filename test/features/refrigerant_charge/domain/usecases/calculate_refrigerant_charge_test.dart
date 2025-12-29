import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/calculate_refrigerant_charge.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_refrigerant_charge_test.mocks.dart';

@GenerateMocks([RefrigerantChargeRepository])
void main() {
  late CalculateRefrigerantCharge usecase;
  late MockRefrigerantChargeRepository mockRepository;

  setUp(() {
    mockRepository = MockRefrigerantChargeRepository();
    usecase = CalculateRefrigerantCharge(mockRepository);
  });

  const tParameters = ChargeParameters(
    fluidId: 'R32',
    lfl: 0.307,
    application: Application.confort,
    access: AccessConfort.general,
    classification: Classification.deux,
    volume: 20.0,
  );

  const tResult = ChargeResult(
    factorM1: 2.46,
    factorM2: 15.96,
    factorM3: 79.82,
    chargeLimit: 2.46,
    message: null,
  );

  test('should calculate refrigerant charge from the repository', () async {
    // arrange
    when(mockRepository.calculateCharge(any))
        .thenAnswer((_) async => const Right(tResult));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Right(tResult));
    verify(mockRepository.calculateCharge(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when calculation fails', () async {
    // arrange
    const tFailure = CalculationFailure('Calculation error');
    when(mockRepository.calculateCharge(any))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tParameters);

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.calculateCharge(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
