import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/calculate_refrigerant_charge.dart';
import 'package:app_froid/features/refrigerant_charge/domain/usecases/get_available_fluids.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_event.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/bloc/refrigerant_charge_state.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';

class RefrigerantChargeBloc
    extends Bloc<RefrigerantChargeEvent, RefrigerantChargeState> {
  final GetAvailableFluids getAvailableFluids;
  final CalculateRefrigerantCharge calculateRefrigerantCharge;

  List<Fluid> _cachedFluids = [];

  RefrigerantChargeBloc({
    required this.getAvailableFluids,
    required this.calculateRefrigerantCharge,
  }) : super(RefrigerantChargeInitial()) {
    on<LoadFluidsEvent>(_onLoadFluids);
    on<CalculateChargeEvent>(_onCalculateCharge);
  }

  Future<void> _onLoadFluids(
    LoadFluidsEvent event,
    Emitter<RefrigerantChargeState> emit,
  ) async {
    emit(RefrigerantChargeLoading());

    final result = await getAvailableFluids(NoParams());

    result.fold(
      (failure) => emit(RefrigerantChargeError(failure.message)),
      (fluids) {
        _cachedFluids = fluids;
        emit(FluidsLoaded(fluids));
      },
    );
  }

  Future<void> _onCalculateCharge(
    CalculateChargeEvent event,
    Emitter<RefrigerantChargeState> emit,
  ) async {
    final result = await calculateRefrigerantCharge(event.parameters);

    result.fold(
      (failure) => emit(RefrigerantChargeError(failure.message)),
      (chargeResult) => emit(ChargeCalculated(
        fluids: _cachedFluids,
        result: chargeResult,
      )),
    );
  }
}
