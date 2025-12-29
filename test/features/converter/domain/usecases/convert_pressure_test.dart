import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/converter/domain/entities/conversion_parameters.dart';
import 'package:app_froid/features/converter/domain/repositories/converter_repository.dart';
import 'package:app_froid/features/converter/domain/usecases/convert_pressure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'convert_pressure_test.mocks.dart';

@GenerateMocks([ConverterRepository])
void main() {
  late ConvertPressure usecase;
  late MockConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockConverterRepository();
    usecase = ConvertPressure(mockRepository);
  });

  const tParameters = ConversionParameters(
    value: 10.0,
    fromUnit: 'bar',
    toUnit: 'psi',
  );

  const double tResult = 145.04;

  test('should convert pressure from repository', () async {
    when(mockRepository.convertPressure(any))
        .thenAnswer((_) async => const Right(tResult));

    final result = await usecase(tParameters);

    expect(result, const Right(tResult));
    verify(mockRepository.convertPressure(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when conversion fails', () async {
    const tFailure = CalculationFailure('Error');
    when(mockRepository.convertPressure(any))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParameters);

    expect(result, const Left(tFailure));
    verify(mockRepository.convertPressure(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
