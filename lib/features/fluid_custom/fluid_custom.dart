/// Feature FluidCustom - Gestion des fluides personnalisés
///
/// Cette feature permet de créer, modifier et supprimer des fluides personnalisés
/// (mélanges de fluides frigorigènes).
library;

// Domain
export 'domain/entities/fluid_custom.dart';
export 'domain/repositories/fluid_custom_repository.dart';

// Presentation
export 'presentation/bloc/fluid_custom_bloc.dart';
export 'presentation/bloc/fluid_custom_event.dart';
export 'presentation/bloc/fluid_custom_state.dart';
export 'presentation/widgets/fluid_custom_button.dart';
export 'presentation/widgets/fluid_custom_modal.dart';
export 'presentation/widgets/fluid_selector_widget.dart';
export 'presentation/widgets/fluid_dropdown_selector.dart';
