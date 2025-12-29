import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fluid_custom.dart';
import '../bloc/fluid_custom_bloc.dart';
import '../bloc/fluid_custom_event.dart';
import '../bloc/fluid_custom_state.dart';
import 'fluid_selector_widget.dart';

/// Modal de gestion des fluides personnalisés
///
/// Affiche la liste des fluides personnalisés avec possibilité d'ajout,
/// modification et suppression
class FluidCustomModal extends StatefulWidget {
  const FluidCustomModal({super.key});

  @override
  State<FluidCustomModal> createState() => _FluidCustomModalState();
}

class _FluidCustomModalState extends State<FluidCustomModal> {
  @override
  void initState() {
    super.initState();
    // Charger les fluides personnalisés au démarrage
    context.read<FluidCustomBloc>().add(const LoadFluidCustomsEvent());
  }

  void _createNewFluid() {
    // Créer un nouveau fluide vide
    final newFluid = FluidCustom.empty();
    context.read<FluidCustomBloc>().add(AddFluidCustomEvent(newFluid));
  }

  void _updateFluid(int index, FluidCustom fluid) {
    context.read<FluidCustomBloc>().add(UpdateFluidCustomEvent(index, fluid));
  }

  void _removeFluid(int index) {
    // Afficher une confirmation avant suppression
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce fluide personnalisé ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<FluidCustomBloc>().add(RemoveFluidCustomEvent(index));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Mes fluides personnalisés',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Fermer',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.science),
              label: const Text('Créer un fluide'),
              onPressed: _createNewFluid,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FluidCustomBloc, FluidCustomState>(
      builder: (context, state) {
        if (state is FluidCustomLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is FluidCustomError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<FluidCustomBloc>()
                          .add(const LoadFluidCustomsEvent());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is FluidCustomLoaded) {
          if (state.fluids.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            itemCount: state.fluids.length,
            itemBuilder: (context, index) {
              return FluidSelectorWidget(
                key: ValueKey(state.fluids[index].label + index.toString()),
                fluidCustom: state.fluids[index],
                index: index,
                onUpdate: (fluid) => _updateFluid(index, fluid),
                onDelete: _removeFluid,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.science_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun fluide personnalisé',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cliquez sur "Créer un fluide" pour commencer',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
