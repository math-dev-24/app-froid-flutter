import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/usecases/calculate_lfl_volume.dart';
import 'package:app_froid/features/lfl_volume/domain/usecases/get_flammable_fluids.dart';
import 'package:app_froid/features/lfl_volume/presentation/bloc/lfl_volume_event.dart';
import 'package:app_froid/features/lfl_volume/presentation/bloc/lfl_volume_state.dart';

class LflVolumeBloc extends Bloc<LflVolumeEvent, LflVolumeState> {
  final GetFlammableFluids getFlammableFluids;
  final CalculateLflVolume calculateLflVolume;

  List<FlammableFluid> _cachedFluids = [];

  LflVolumeBloc({
    required this.getFlammableFluids,
    required this.calculateLflVolume,
  }) : super(LflVolumeInitial()) {
    on<LoadFluidsEvent>(_onLoadFluids);
    on<CalculateLflVolumeEvent>(_onCalculateLflVolume);
  }

  Future<void> _onLoadFluids(
    LoadFluidsEvent event,
    Emitter<LflVolumeState> emit,
  ) async {
    emit(LflVolumeLoading());

    final result = await getFlammableFluids(NoParams());

    result.fold(
      (failure) => emit(LflVolumeError(failure.message)),
      (fluids) {
        _cachedFluids = fluids;
        emit(FluidsLoaded(fluids));
      },
    );
  }

  Future<void> _onCalculateLflVolume(
    CalculateLflVolumeEvent event,
    Emitter<LflVolumeState> emit,
  ) async {
    final params = CalculateLflVolumeParams(
      parameters: event.parameters,
      safetyFactor: event.safetyFactor,
    );

    final result = await calculateLflVolume(params);

    result.fold(
      (failure) => emit(LflVolumeError(failure.message)),
      (lflResult) => emit(LflVolumeCalculated(
        fluids: _cachedFluids,
        result: lflResult,
      )),
    );
  }
}
