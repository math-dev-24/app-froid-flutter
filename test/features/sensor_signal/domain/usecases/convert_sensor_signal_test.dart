import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/sensor_signal/domain/entities/sensor_conversion_parameters.dart';
import 'package:app_froid/features/sensor_signal/domain/entities/sensor_conversion_result.dart';
import 'package:app_froid/features/sensor_signal/domain/repositories/sensor_signal_repository.dart';
import 'package:app_froid/features/sensor_signal/domain/usecases/convert_sensor_signal.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'convert_sensor_signal_test.mocks.dart';

@GenerateMocks([SensorSignalRepository])
void main() {
  late ConvertSensorSignal usecase;
  late MockSensorSignalRepository mockRepository;

  setUp(() {
    mockRepository = MockSensorSignalRepository();
    usecase = ConvertSensorSignal(mockRepository);
  });

  const tParameters = SensorConversionParameters(
    sensorType: 'PT100',
    inputValue: 100.0,
    conversionType: 'resistance_to_temperature',
  );

  const tResult = SensorConversionResult(
    outputValue: 0.0,
    unit: '°C',
  );

  test('should convert sensor signal from repository', () async {
    when(mockRepository.convertSensorSignal(any))
        .thenAnswer((_) async => const Right(tResult));

    final result = await usecase(tParameters);

    expect(result, const Right(tResult));
    verify(mockRepository.convertSensorSignal(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when conversion fails', () async {
    const tFailure = CalculationFailure('Error');
    when(mockRepository.convertSensorSignal(any))
        .thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tParameters);

    expect(result, const Left(tFailure));
    verify(mockRepository.convertSensorSignal(tParameters));
    verifyNoMoreInteractions(mockRepository);
  });
}
