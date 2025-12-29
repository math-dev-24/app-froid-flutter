# FluidCustom Feature

Cette feature permet de gérer les fluides personnalisés (mélanges de fluides frigorigènes).

## Architecture

```
fluid_custom/
├── domain/
│   ├── entities/
│   │   └── fluid_custom.dart          # Entité FluidCustom
│   └── repositories/
│       └── fluid_custom_repository.dart
├── data/
│   ├── models/
│   │   └── fluid_custom_model.dart    # Modèle avec sérialisation JSON
│   ├── datasources/
│   │   ├── fluid_custom_local_datasource.dart
│   │   └── fluid_custom_local_datasource_impl.dart  # Utilise SharedPreferences
│   └── repositories/
│       └── fluid_custom_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── fluid_custom_bloc.dart
    │   ├── fluid_custom_event.dart
    │   └── fluid_custom_state.dart
    └── widgets/
        ├── fluid_custom_button.dart    # Boutons pour ouvrir la modal
        ├── fluid_custom_modal.dart     # Modal de gestion des fluides
        └── fluid_selector_widget.dart  # Widget d'édition d'un fluide
```

## Utilisation

### 1. Ajouter le bouton dans votre page

```dart
import 'package:app_froid/features/fluid_custom/fluid_custom.dart';

// Dans le Scaffold, par exemple dans l'AppBar
AppBar(
  title: Text('Ma Page'),
  actions: [
    FluidCustomButton(
      onFluidsSynced: () {
        // Callback appelé quand la modal est fermée
        print('Fluides synchronisés');
      },
    ),
  ],
)

// Ou comme bouton texte
FluidCustomTextButton(
  label: 'Gérer mes fluides',
  onFluidsSynced: () {
    // Rafraîchir la liste des fluides si nécessaire
  },
)

// Ou comme FAB
FloatingActionButton: FluidCustomFab(
  onFluidsSynced: () => _refreshFluids(),
)
```

### 2. Utiliser les fluides personnalisés

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/features/fluid_custom/fluid_custom.dart';
import 'package:app_froid/core/di/injection_container.dart';

// Dans votre widget
BlocProvider(
  create: (_) => getIt<FluidCustomBloc>()..add(LoadFluidCustomsEvent()),
  child: BlocBuilder<FluidCustomBloc, FluidCustomState>(
    builder: (context, state) {
      if (state is FluidCustomLoaded) {
        // Utiliser state.fluids
        return ListView.builder(
          itemCount: state.fluids.length,
          itemBuilder: (context, index) {
            final fluid = state.fluids[index];
            return ListTile(
              title: Text(fluid.label),
              subtitle: Text(
                fluid.fluids.join(', '),
              ),
            );
          },
        );
      }
      return CircularProgressIndicator();
    },
  ),
)
```

### 3. Structure d'un FluidCustom

```dart
FluidCustom(
  label: 'Mon mélange R410A',
  fluids: ['R32', 'R125'],
  fluidsRef: ['R32', 'R125'],
  quantities: [0.697, 0.303],  // En décimal (0.0 à 1.0)
)
```

## Fonctionnalités

### FluidSelectorWidget

Widget d'édition d'un fluide personnalisé avec :

- **Mode lecture** : Affichage des fluides et quantités avec barre de progression visuelle
- **Mode édition** :
  - Modification du nom
  - Ajout/suppression de fluides (min 2, max 5)
  - Modification des quantités (en %)
  - Auto-équilibrage
  - Validation du total (doit être 100%)

### FluidCustomModal

Modal de gestion avec :
- Liste de tous les fluides personnalisés
- Création de nouveaux fluides
- Modification en ligne
- Suppression avec confirmation
- Persistance automatique avec SharedPreferences

## Validation

Le système valide automatiquement :
- ✅ Nom du mélange non vide
- ✅ Tous les fluides sélectionnés
- ✅ Quantités valides (0-100%)
- ✅ Total = 100% (tolérance 0.1%)
- ✅ Minimum 2 fluides, maximum 5 fluides

## Persistance

Les fluides personnalisés sont sauvegardés automatiquement dans SharedPreferences au format JSON.

## Dépendances

Les dépendances sont automatiquement injectées via `injection_container.dart`.
Aucune configuration supplémentaire n'est nécessaire.
