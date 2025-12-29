import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';
import 'package:app_froid/features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/get_available_fluids.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_available_fluids_test.mocks.dart';

@GenerateMocks([RefrigerantChargeRepository])
void main() {
  late GetAvailableFluids usecase;
  late MockRefrigerantChargeRepository mockRepository;

  setUp(() {
    mockRepository = MockRefrigerantChargeRepository();
    usecase = GetAvailableFluids(mockRepository);
  });

  const tFluids = [
    Fluid(id: 'R410A', label: 'R410A', desp: 1, lfl: 0.44, gwp: 2088),
    Fluid(id: 'R32', label: 'R32', desp: 2, lfl: 0.307, gwp: 675),
  ];

  test('should get list of fluids from the repository', () async {
    // arrange
    when(mockRepository.getAvailableFluids())
        .thenAnswer((_) async => const Right(tFluids));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(tFluids));
    verify(mockRepository.getAvailableFluids());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = CalculationFailure('Failed to load fluids');
    when(mockRepository.getAvailableFluids())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.getAvailableFluids());
    verifyNoMoreInteractions(mockRepository);
  });
}
