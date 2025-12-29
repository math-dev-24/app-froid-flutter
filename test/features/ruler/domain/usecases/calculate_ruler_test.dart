import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/ruler/domain/entities/calculation_result.dart';
import 'package:app_froid/features/ruler/domain/entities/fluid.dart';
import 'package:app_froid/features/ruler/domain/entities/ruler_parameters.dart';
import 'package:app_froid/features/ruler/domain/repositories/ruler_repository.dart';
import 'package:app_froid/features/ruler/domain/usecases/calculate_ruler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_ruler_test.mocks.dart';

@GenerateMocks([RulerRepository])
void main() {
  late CalculateRuler usecase;
  late MockRulerRepository mockRepository;

  setUp(() {
    mockRepository = MockRulerRepository();
    usecase = CalculateRuler(mockRepository);
  });

  const tFluid = Fluid(name: 'R410A', refName: 'R410A');
  const tParameters = RulerParameters(
    fluid: tFluid,
    knownParameter: 'P',
    knownValue: 10.0,
    targetParameter: 'T',
  );

  final tResult = CalculationResult.fromMap({
    'result': 25.0,
    'P': 10.0,
    'T': 25.0,
  });

  test('should calculate ruler value from repository', () async {
    when(mockRepository.calculateRuler(any))
        .thenAnswer((_) async => Right(tResult));

    final result = await usecase(tParameters);

    expect(result, Right(tResult));
    verify(mockRepository.calculateRuler(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when calculation fails', () async {
    const tFailure = CalculationFailure('Error');
    when(mockRepository.calculateRuler(any))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParameters);

    expect(result, const Left(tFailure));
    verify(mockRepository.calculateRuler(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
