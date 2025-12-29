import 'package:equatable/equatable.dart';
import '../../domain/entities/fluid_custom.dart';

/// États pour le BLoC des fluides personnalisés
abstract class FluidCustomState extends Equatable {
  const FluidCustomState();

  @override
  List<Object?> get props => [];
}

/// État initial
class FluidCustomInitial extends FluidCustomState {
  const FluidCustomInitial();
}

/// État de chargement
class FluidCustomLoading extends FluidCustomState {
  const FluidCustomLoading();
}

/// État chargé avec succès
class FluidCustomLoaded extends FluidCustomState {
  final List<FluidCustom> fluids;

  const FluidCustomLoaded(this.fluids);

  @override
  List<Object?> get props => [fluids];
}

/// État d'erreur
class FluidCustomError extends FluidCustomState {
  final String message;

  const FluidCustomError(this.message);

  @override
  List<Object?> get props => [message];
}
