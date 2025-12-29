import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/ruler/domain/entities/calculation_result.dart';
import 'package:app_froid/features/ruler/domain/entities/fluid.dart';
import 'package:app_froid/features/ruler/domain/repositories/ruler_repository.dart';
import 'package:app_froid/features/ruler/domain/usecases/calculate_simple_ruler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_simple_ruler_test.mocks.dart';

@GenerateMocks([RulerRepository])
void main() {
  late CalculateSimpleRuler usecase;
  late MockRulerRepository mockRepository;

  setUp(() {
    mockRepository = MockRulerRepository();
    usecase = CalculateSimpleRuler(mockRepository);
  });

  const tFluid = Fluid(
    name: 'R410A',
    refName: 'R410A',
    canSimulate: true,
    isMix: true,
  );

  final tResult = CalculationResult(values: {
    'result': 25.0,
    'P': 10.0,
    'T': 25.0,
  });

  group('calculateSimple with temperature', () {
    const tParams = SimpleRulerParams(
      fluid: tFluid,
      temperature: 25.0,
    );

    test('should calculate pressure from temperature', () async {
      when(mockRepository.calculateSimple(
        fluid: anyNamed('fluid'),
        temperature: anyNamed('temperature'),
        pressure: anyNamed('pressure'),
      )).thenAnswer((_) async => Right(tResult));

      final result = await usecase(tParams);

      expect(result, Right(tResult));
      verify(mockRepository.calculateSimple(
        fluid: tFluid,
        temperature: 25.0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when calculation fails', () async {
      const tFailure = CalculationFailure('Error');
      when(mockRepository.calculateSimple(
        fluid: anyNamed('fluid'),
        temperature: anyNamed('temperature'),
        pressure: anyNamed('pressure'),
      )).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(mockRepository.calculateSimple(
        fluid: tFluid,
        temperature: 25.0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('calculateSimple with pressure', () {
    const tParams = SimpleRulerParams(
      fluid: tFluid,
      pressure: 10.0,
    );

    test('should calculate temperature from pressure', () async {
      when(mockRepository.calculateSimple(
        fluid: anyNamed('fluid'),
        temperature: anyNamed('temperature'),
        pressure: anyNamed('pressure'),
      )).thenAnswer((_) async => Right(tResult));

      final result = await usecase(tParams);

      expect(result, Right(tResult));
      verify(mockRepository.calculateSimple(
        fluid: tFluid,
        pressure: 10.0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when calculation fails', () async {
      const tFailure = CalculationFailure('Error');
      when(mockRepository.calculateSimple(
        fluid: anyNamed('fluid'),
        temperature: anyNamed('temperature'),
        pressure: anyNamed('pressure'),
      )).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(mockRepository.calculateSimple(
        fluid: tFluid,
        pressure: 10.0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('SimpleRulerParams validation', () {
    test('should throw assertion error when both temperature and pressure are null', () {
      expect(
        () => SimpleRulerParams(
          fluid: tFluid,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should accept temperature only', () {
      expect(
        () => SimpleRulerParams(
          fluid: tFluid,
          temperature: 25.0,
        ),
        returnsNormally,
      );
    });

    test('should accept pressure only', () {
      expect(
        () => SimpleRulerParams(
          fluid: tFluid,
          pressure: 10.0,
        ),
        returnsNormally,
      );
    });

    test('should accept both temperature and pressure', () {
      expect(
        () => SimpleRulerParams(
          fluid: tFluid,
          temperature: 25.0,
          pressure: 10.0,
        ),
        returnsNormally,
      );
    });
  });
}
