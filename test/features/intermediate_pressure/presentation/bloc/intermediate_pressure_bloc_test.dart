import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';
import 'package:app_froid/features/intermediate_pressure/domain/usecases/calculate_intermediate_pressure.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/bloc/intermediate_pressure_bloc.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/bloc/intermediate_pressure_event.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/bloc/intermediate_pressure_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'intermediate_pressure_bloc_test.mocks.dart';

@GenerateMocks([CalculateIntermediatePressure])
void main() {
  late IntermediatePressureBloc bloc;
  late MockCalculateIntermediatePressure mockCalculate;

  setUp(() {
    mockCalculate = MockCalculateIntermediatePressure();
    bloc = IntermediatePressureBloc(calculateIntermediatePressure: mockCalculate);
  });

  test('initial state should be IntermediatePressureInitial', () {
    expect(bloc.state, equals(IntermediatePressureInitial()));
  });

  group('CalculatePressureEvent', () {
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

    blocTest<IntermediatePressureBloc, IntermediatePressureState>(
      'should emit [Loading, Loaded] when calculation succeeds',
      build: () {
        when(mockCalculate(any))
            .thenAnswer((_) async => const Right(tResult));
        return bloc;
      },
      act: (bloc) => bloc.add(const CalculateIntermediatePressureEvent(
        highPressure: 20.0,
        lowPressure: 5.0,
      )),
      expect: () => [
        IntermediatePressureLoading(),
        const IntermediatePressureLoaded(tResult),
      ],
      verify: (_) {
        verify(mockCalculate(tParameters));
      },
    );

    blocTest<IntermediatePressureBloc, IntermediatePressureState>(
      'should emit [Loading, Error] when calculation fails',
      build: () {
        when(mockCalculate(any))
            .thenAnswer((_) async => const Left(CalculationFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const CalculateIntermediatePressureEvent(
        highPressure: 20.0,
        lowPressure: 5.0,
      )),
      expect: () => [
        IntermediatePressureLoading(),
        const IntermediatePressureError('Error'),
      ],
      verify: (_) {
        verify(mockCalculate(tParameters));
      },
    );
  });
}
