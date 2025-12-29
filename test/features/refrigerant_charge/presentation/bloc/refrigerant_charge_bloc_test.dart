import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/calculate_refrigerant_charge.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/get_available_fluids.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_bloc.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_event.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refrigerant_charge_bloc_test.mocks.dart';

@GenerateMocks([GetAvailableFluids, CalculateRefrigerantCharge])
void main() {
  late RefrigerantChargeBloc bloc;
  late MockGetAvailableFluids mockGetAvailableFluids;
  late MockCalculateRefrigerantCharge mockCalculateRefrigerantCharge;

  setUp(() {
    mockGetAvailableFluids = MockGetAvailableFluids();
    mockCalculateRefrigerantCharge = MockCalculateRefrigerantCharge();
    bloc = RefrigerantChargeBloc(
      getAvailableFluids: mockGetAvailableFluids,
      calculateRefrigerantCharge: mockCalculateRefrigerantCharge,
    );
  });

  test('initial state should be RefrigerantChargeInitial', () {
    expect(bloc.state, equals(RefrigerantChargeInitial()));
  });

  group('LoadFluidsEvent', () {
    const tFluids = [
      Fluid(id: 'R410A', label: 'R410A', desp: 1, lfl: 0.44, gwp: 2088),
      Fluid(id: 'R32', label: 'R32', desp: 2, lfl: 0.307, gwp: 675),
    ];

    blocTest<RefrigerantChargeBloc, RefrigerantChargeState>(
      'should emit [Loading, FluidsLoaded] when fluids are loaded successfully',
      build: () {
        when(mockGetAvailableFluids(any))
            .thenAnswer((_) async => const Right(tFluids));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFluidsEvent()),
      expect: () => [
        RefrigerantChargeLoading(),
        FluidsLoaded(tFluids),
      ],
      verify: (_) {
        verify(mockGetAvailableFluids(NoParams()));
      },
    );

    blocTest<RefrigerantChargeBloc, RefrigerantChargeState>(
      'should emit [Loading, Error] when loading fluids fails',
      build: () {
        when(mockGetAvailableFluids(any))
            .thenAnswer((_) async => const Left(CalculationFailure('Error loading fluids')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFluidsEvent()),
      expect: () => [
        RefrigerantChargeLoading(),
        RefrigerantChargeError('Error loading fluids'),
      ],
      verify: (_) {
        verify(mockGetAvailableFluids(NoParams()));
      },
    );
  });

  group('CalculateChargeEvent', () {
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

    const tFluids = [
      Fluid(id: 'R32', label: 'R32', desp: 2, lfl: 0.307, gwp: 675),
    ];

    blocTest<RefrigerantChargeBloc, RefrigerantChargeState>(
      'should emit ChargeCalculated when calculation succeeds',
      build: () {
        when(mockGetAvailableFluids(any))
            .thenAnswer((_) async => const Right(tFluids));
        when(mockCalculateRefrigerantCharge(any))
            .thenAnswer((_) async => const Right(tResult));
        return bloc;
      },
      act: (bloc) {
        bloc.add(LoadFluidsEvent());
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(CalculateChargeEvent(tParameters)),
        );
      },
      expect: () => [
        RefrigerantChargeLoading(),
        FluidsLoaded(tFluids),
        ChargeCalculated(fluids: tFluids, result: tResult),
      ],
      verify: (_) {
        verify(mockGetAvailableFluids(NoParams()));
        verify(mockCalculateRefrigerantCharge(tParameters));
      },
    );

    blocTest<RefrigerantChargeBloc, RefrigerantChargeState>(
      'should emit Error when calculation fails',
      build: () {
        when(mockCalculateRefrigerantCharge(any))
            .thenAnswer((_) async => const Left(CalculationFailure('Calculation error')));
        return bloc;
      },
      act: (bloc) => bloc.add(CalculateChargeEvent(tParameters)),
      expect: () => [
        RefrigerantChargeError('Calculation error'),
      ],
      verify: (_) {
        verify(mockCalculateRefrigerantCharge(tParameters));
      },
    );
  });
}
