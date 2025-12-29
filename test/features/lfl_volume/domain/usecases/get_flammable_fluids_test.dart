import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/repositories/lfl_volume_repository.dart';
import 'package:app_froid/features/lfl_volume/domain/usecases/get_flammable_fluids.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_flammable_fluids_test.mocks.dart';

@GenerateMocks([LflVolumeRepository])
void main() {
  late GetFlammableFluids usecase;
  late MockLflVolumeRepository mockRepository;

  setUp(() {
    mockRepository = MockLflVolumeRepository();
    usecase = GetFlammableFluids(mockRepository);
  });

  const tFluids = [
    FlammableFluid(
      refName: 'R32',
      name: 'R32',
      classification: 'A2L',
      description: 'Difluorométhane',
      lfl: LflRange(lower: 14.4, upper: 29.3),
    ),
  ];

  test('should get list of flammable fluids from repository', () async {
    // arrange
    when(mockRepository.getFlammableFluids())
        .thenAnswer((_) async => const Right(tFluids));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(tFluids));
    verify(mockRepository.getFlammableFluids());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when loading fails', () async {
    // arrange
    const tFailure = CalculationFailure('Failed to load fluids');
    when(mockRepository.getFlammableFluids())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.getFlammableFluids());
    verifyNoMoreInteractions(mockRepository);
  });
}
