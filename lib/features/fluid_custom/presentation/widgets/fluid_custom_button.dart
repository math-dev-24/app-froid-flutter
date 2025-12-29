import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/fluid_custom_bloc.dart';
import 'fluid_custom_modal.dart';

/// Bouton pour ouvrir la modal de gestion des fluides personnalisés
///
/// Ce widget peut être utilisé n'importe où dans l'application
/// pour permettre à l'utilisateur de gérer ses fluides personnalisés
class FluidCustomButton extends StatelessWidget {
  final VoidCallback? onFluidsSynced;

  const FluidCustomButton({
    super.key,
    this.onFluidsSynced,
  });

  void _showFluidCustomModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<FluidCustomBloc>(),
        child: const FluidCustomModal(),
      ),
    ).then((_) {
      // Callback appelé quand la modal est fermée
      onFluidsSynced?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.science),
      tooltip: 'Mes fluides personnalisés',
      onPressed: () => _showFluidCustomModal(context),
    );
  }
}

/// Version avec bouton texte
class FluidCustomTextButton extends StatelessWidget {
  final VoidCallback? onFluidsSynced;
  final String label;

  const FluidCustomTextButton({
    super.key,
    this.onFluidsSynced,
    this.label = 'Fluides personnalisés',
  });

  void _showFluidCustomModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<FluidCustomBloc>(),
        child: const FluidCustomModal(),
      ),
    ).then((_) {
      onFluidsSynced?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.science),
      label: Text(label),
      onPressed: () => _showFluidCustomModal(context),
    );
  }
}

/// Version avec FAB (Floating Action Button)
class FluidCustomFab extends StatelessWidget {
  final VoidCallback? onFluidsSynced;

  const FluidCustomFab({
    super.key,
    this.onFluidsSynced,
  });

  void _showFluidCustomModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<FluidCustomBloc>(),
        child: const FluidCustomModal(),
      ),
    ).then((_) {
      onFluidsSynced?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showFluidCustomModal(context),
      tooltip: 'Mes fluides personnalisés',
      child: const Icon(Icons.science),
    );
  }
}
