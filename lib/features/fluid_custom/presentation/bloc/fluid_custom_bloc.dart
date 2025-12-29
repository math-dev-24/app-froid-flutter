import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fluid_custom_repository.dart';
import 'fluid_custom_event.dart';
import 'fluid_custom_state.dart';

/// BLoC pour la gestion des fluides personnalisés
class FluidCustomBloc extends Bloc<FluidCustomEvent, FluidCustomState> {
  final FluidCustomRepository repository;

  FluidCustomBloc({required this.repository})
      : super(const FluidCustomInitial()) {
    on<LoadFluidCustomsEvent>(_onLoadFluidCustoms);
    on<AddFluidCustomEvent>(_onAddFluidCustom);
    on<UpdateFluidCustomEvent>(_onUpdateFluidCustom);
    on<RemoveFluidCustomEvent>(_onRemoveFluidCustom);
  }

  Future<void> _onLoadFluidCustoms(
    LoadFluidCustomsEvent event,
    Emitter<FluidCustomState> emit,
  ) async {
    emit(const FluidCustomLoading());
    final result = await repository.getFluidCustoms();
    result.fold(
      (failure) => emit(const FluidCustomError('Erreur lors du chargement')),
      (fluids) => emit(FluidCustomLoaded(fluids)),
    );
  }

  Future<void> _onAddFluidCustom(
    AddFluidCustomEvent event,
    Emitter<FluidCustomState> emit,
  ) async {
    if (state is FluidCustomLoaded) {
      final currentFluids = (state as FluidCustomLoaded).fluids;
      final result = await repository.addFluidCustom(event.fluid);
      result.fold(
        (failure) => emit(const FluidCustomError('Erreur lors de l\'ajout')),
        (_) => emit(FluidCustomLoaded([...currentFluids, event.fluid])),
      );
    }
  }

  Future<void> _onUpdateFluidCustom(
    UpdateFluidCustomEvent event,
    Emitter<FluidCustomState> emit,
  ) async {
    if (state is FluidCustomLoaded) {
      final currentFluids = (state as FluidCustomLoaded).fluids;
      final result =
          await repository.updateFluidCustom(event.index, event.fluid);
      result.fold(
        (failure) =>
            emit(const FluidCustomError('Erreur lors de la mise à jour')),
        (_) {
          final updatedFluids = List.of(currentFluids);
          if (event.index >= 0 && event.index < updatedFluids.length) {
            updatedFluids[event.index] = event.fluid;
          }
          emit(FluidCustomLoaded(updatedFluids));
        },
      );
    }
  }

  Future<void> _onRemoveFluidCustom(
    RemoveFluidCustomEvent event,
    Emitter<FluidCustomState> emit,
  ) async {
    if (state is FluidCustomLoaded) {
      final currentFluids = (state as FluidCustomLoaded).fluids;
      final result = await repository.removeFluidCustom(event.index);
      result.fold(
        (failure) =>
            emit(const FluidCustomError('Erreur lors de la suppression')),
        (_) {
          final updatedFluids = List.of(currentFluids);
          if (event.index >= 0 && event.index < updatedFluids.length) {
            updatedFluids.removeAt(event.index);
          }
          emit(FluidCustomLoaded(updatedFluids));
        },
      );
    }
  }
}
