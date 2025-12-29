import 'package:equatable/equatable.dart';
import '../../domain/entities/fluid_custom.dart';

/// Événements pour le BLoC des fluides personnalisés
abstract class FluidCustomEvent extends Equatable {
  const FluidCustomEvent();

  @override
  List<Object?> get props => [];
}

/// Événement pour charger les fluides personnalisés
class LoadFluidCustomsEvent extends FluidCustomEvent {
  const LoadFluidCustomsEvent();
}

/// Événement pour ajouter un fluide personnalisé
class AddFluidCustomEvent extends FluidCustomEvent {
  final FluidCustom fluid;

  const AddFluidCustomEvent(this.fluid);

  @override
  List<Object?> get props => [fluid];
}

/// Événement pour mettre à jour un fluide personnalisé
class UpdateFluidCustomEvent extends FluidCustomEvent {
  final int index;
  final FluidCustom fluid;

  const UpdateFluidCustomEvent(this.index, this.fluid);

  @override
  List<Object?> get props => [index, fluid];
}

/// Événement pour supprimer un fluide personnalisé
class RemoveFluidCustomEvent extends FluidCustomEvent {
  final int index;

  const RemoveFluidCustomEvent(this.index);

  @override
  List<Object?> get props => [index];
}
