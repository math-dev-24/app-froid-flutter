# 🏗️ App Froid - Architecture Hexagonale

> Application Flutter pour techniciens frigoristes avec architecture hexagonale (Clean Architecture)

## 🚀 Démarrage rapide

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Analyser le code
flutter analyze

# Exécuter les tests
flutter test
```

## 📁 Structure du projet

```
lib/
├── core/                           # Infrastructure partagée
│   ├── error/                     # Gestion des erreurs
│   ├── network/                   # Vérification réseau
│   ├── usecases/                  # Use cases abstraits
│   ├── utils/                     # Utilitaires partagés
│   └── di/                        # Injection de dépendances
│
├── features/                       # Features avec architecture hexagonale
│   └── ruler/                     # ✅ Règlette (migrée)
│       ├── domain/                # Logique métier pure
│       ├── data/                  # Implémentation infrastructure
│       └── presentation/          # UI avec BLoC
│
├── screens/                        # ⚠️ Ancienne architecture
├── services/                       # ⚠️ À migrer progressivement
├── data/                          # ⚠️ À migrer progressivement
└── main.dart                       # Point d'entrée
```

## 🎯 Fonctionnalités

### ✅ Migrées (Architecture Hexagonale)
- **Règlette** - Calculs thermodynamiques (T→P)

### ⏳ À migrer
- Règlette avancée
- Convertisseur (pression/température)
- Signal capteur
- Interpolation linéaire
- Diamètre équivalent
- DESP
- Test d'Azote
- Pression moyenne
- Calcul de charge
- Volume mini LFL
- Contact

## 📚 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Explication complète de l'architecture hexagonale
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Guide étape par étape pour migrer les features
- **[SUMMARY.md](SUMMARY.md)** - Résumé de ce qui a été fait

## 🧪 Architecture hexagonale

### Les 3 couches

#### 1. Domain (Cœur métier)
```dart
// Pure Dart - Aucune dépendance externe
features/ruler/domain/
├── entities/              # Objets métier immuables
├── repositories/          # Interfaces (contracts)
└── usecases/             # Logique métier
```

#### 2. Data (Infrastructure)
```dart
// Implémentation des interfaces
features/ruler/data/
├── models/               # Sérialisation JSON
├── datasources/          # API, DB, Cache
└── repositories/         # Implémentation concrète
```

#### 3. Presentation (UI)
```dart
// Interface utilisateur
features/ruler/presentation/
├── bloc/                 # State management (BLoC)
├── pages/                # Écrans
└── widgets/              # Composants réutilisables
```

### Flux de données

```
User Action
    ↓
BLoC Event
    ↓
Use Case (validation)
    ↓
Repository (interface)
    ↓
DataSource (API/DB)
    ↓
Either<Failure, Success>
    ↓
BLoC State
    ↓
UI Rebuild
```

## 🔧 Technologies

| Package | Usage |
|---------|-------|
| `flutter_bloc` | State management (BLoC pattern) |
| `dartz` | Programmation fonctionnelle (Either) |
| `equatable` | Comparaison d'objets |
| `get_it` | Injection de dépendances |
| `http` | Client HTTP |
| `connectivity_plus` | Vérification réseau |
| `shared_preferences` | Stockage local |

## 🎓 Exemple : Feature Ruler

### Use Case
```dart
class CalculateSimpleRuler implements UseCase<CalculationResult, SimpleRulerParams> {
  final RulerRepository repository;

  Future<Either<Failure, CalculationResult>> call(params) async {
    // 1. Validation
    if (!params.temperature.isFinite) {
      return Left(ValidationFailure('Température invalide'));
    }

    // 2. Délégation au repository
    return await repository.calculateSimple(...);
  }
}
```

### Repository Implementation
```dart
class RulerRepositoryImpl implements RulerRepository {
  final RulerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, CalculationResult>> calculateSimple(...) async {
    // 1. Vérification réseau
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      // 2. Appel datasource
      final result = await remoteDataSource.calculate(...);
      return Right(result);
    } on ServerException catch (e) {
      // 3. Transformation Exception → Failure
      return Left(ServerFailure(e.message));
    }
  }
}
```

### BLoC
```dart
class RulerBloc extends Bloc<RulerEvent, RulerState> {
  final CalculateSimpleRuler calculateSimpleRuler;

  on<CalculateSimpleEvent>((event, emit) async {
    emit(RulerLoading());

    final result = await calculateSimpleRuler(params);

    result.fold(
      (failure) => emit(RulerError(message: failure.message)),
      (success) => emit(RulerLoaded(result: success)),
    );
  });
}
```

### UI
```dart
class RulerPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RulerBloc>(),
      child: BlocBuilder<RulerBloc, RulerState>(
        builder: (context, state) {
          if (state is RulerLoading) return LoadingWidget();
          if (state is RulerError) return ErrorWidget(state.message);
          if (state is RulerLoaded) return ResultWidget(state.result);
          return FormWidget();
        },
      ),
    );
  }
}
```

## ✅ Avantages

| Avantage | Description |
|----------|-------------|
| **Testabilité** | Chaque couche testée indépendamment |
| **Maintenabilité** | Code organisé, responsabilités claires |
| **Scalabilité** | Ajout de features sans impact |
| **Indépendance** | Domaine sans dépendances externes |
| **Flexibilité** | Changement d'API/UI facile |

## 📝 Comment migrer une feature

1. **Créer la structure**
   ```bash
   lib/features/ma_feature/
   ├── domain/
   ├── data/
   └── presentation/
   ```

2. **Implémenter Domain** → Data → Presentation

3. **Configurer DI** dans `injection_container.dart`

4. **Mettre à jour routes** dans `main.dart`

5. **Tester** et supprimer ancien code

Voir [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) pour le détail.

## 🧪 Tests

```bash
# Unit tests (use cases)
flutter test test/features/ruler/domain/usecases/

# Repository tests
flutter test test/features/ruler/data/repositories/

# BLoC tests
flutter test test/features/ruler/presentation/bloc/

# Widget tests
flutter test test/features/ruler/presentation/pages/
```

## 📊 Métriques

- **Features migrées** : 1/12
- **Fichiers créés** : 25+
- **Lignes de code** : ~2000
- **Documentation** : ~900 lignes
- **Erreurs compilation** : 0

## 🤝 Contribution

Pour contribuer :

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/ma-feature`)
3. Suivre l'architecture hexagonale
4. Ajouter des tests
5. Commit (`git commit -m 'Add ma-feature'`)
6. Push (`git push origin feature/ma-feature`)
7. Ouvrir une Pull Request

## 📞 Support

Pour toute question sur l'architecture :
- Voir [ARCHITECTURE.md](ARCHITECTURE.md)
- Voir [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
- Consulter l'exemple dans `lib/features/ruler/`

---

**Version** : 1.0.0 (Architecture Hexagonale)
**Date** : Décembre 2025
**Status** : 🚧 Migration en cours
