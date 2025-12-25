# Architecture Hexagonale - App Froid

## 📐 Vue d'ensemble

Ce projet utilise l'**architecture hexagonale** (Clean Architecture) pour organiser le code de manière maintenable, testable et scalable.

## 🏗️ Structure du projet

```
lib/
├── core/                           # Éléments partagés entre features
│   ├── error/
│   │   ├── failures.dart          # Failures métier (domaine)
│   │   └── exceptions.dart        # Exceptions techniques (infrastructure)
│   ├── network/
│   │   ├── network_info.dart      # Interface de vérification réseau
│   │   └── network_info_impl.dart # Implémentation avec connectivity_plus
│   ├── usecases/
│   │   └── usecase.dart           # Classe abstraite pour tous les use cases
│   └── di/
│       └── injection_container.dart # Configuration GetIt
│
├── features/                       # Organisation par fonctionnalité
│   └── ruler/                      # Feature: Règlette thermodynamique
│       ├── domain/                 # 🟢 DOMAINE (Pure Dart - Aucune dépendance)
│       │   ├── entities/
│       │   │   ├── fluid.dart                    # Entité Fluide
│       │   │   └── calculation_result.dart       # Résultat de calcul
│       │   ├── repositories/
│       │   │   └── ruler_repository.dart         # Interface repository
│       │   └── usecases/
│       │       ├── calculate_simple_ruler.dart   # Use case calcul simple
│       │       └── calculate_advanced_ruler.dart # Use case calcul avancé
│       │
│       ├── data/                   # 🔵 DATA (Implémentation)
│       │   ├── models/
│       │   │   ├── fluid_model.dart              # Model avec JSON
│       │   │   └── calculation_result_model.dart # Model avec JSON
│       │   ├── datasources/
│       │   │   ├── ruler_remote_datasource.dart       # Interface API
│       │   │   ├── ruler_remote_datasource_impl.dart  # Implémentation API
│       │   │   └── fluids_local_data.dart             # Données locales
│       │   └── repositories/
│       │       └── ruler_repository_impl.dart    # Implémentation repository
│       │
│       └── presentation/           # 🟡 PRESENTATION (UI)
│           ├── bloc/
│           │   ├── ruler_bloc.dart     # Logique d'état
│           │   ├── ruler_event.dart    # Événements utilisateur
│           │   └── ruler_state.dart    # États UI
│           ├── pages/
│           │   └── ruler_page.dart     # Page principale
│           └── widgets/
│               └── form_ruler_widget.dart # Formulaire réutilisable
│
├── screens/                        # ⚠️ Ancienne architecture (à migrer)
├── services/                       # ⚠️ Ancienne architecture (à migrer)
├── data/                           # ⚠️ Ancienne architecture (à migrer)
├── widgets/                        # ⚠️ Ancienne architecture (à migrer)
└── main.dart                       # Point d'entrée
```

## 🎯 Principes de l'Architecture Hexagonale

### 1. Couche DOMAIN (Cœur métier)

**Responsabilités:**
- Définir les **entités** (objets métier immuables)
- Définir les **interfaces de repositories** (contracts)
- Implémenter les **use cases** (logique métier)

**Règles:**
- ✅ Pure Dart (aucune dépendance Flutter)
- ✅ Aucune dépendance vers les couches externes
- ✅ Utilise `Either<Failure, Success>` de dartz
- ❌ Pas d'import de packages UI ou infrastructure

**Exemple:**
```dart
// domain/entities/fluid.dart
class Fluid extends Equatable {
  final String name;
  final String refName;
  // ...
}

// domain/repositories/ruler_repository.dart
abstract class RulerRepository {
  Future<Either<Failure, CalculationResult>> calculateSimple(...);
}

// domain/usecases/calculate_simple_ruler.dart
class CalculateSimpleRuler implements UseCase<CalculationResult, SimpleRulerParams> {
  final RulerRepository repository;
  // Validation + délégation au repository
}
```

### 2. Couche DATA (Infrastructure)

**Responsabilités:**
- Implémenter les **repositories** du domaine
- Gérer les **data sources** (API, DB, cache)
- Convertir les **models** ↔ **entities**
- Transformer les **exceptions** → **failures**

**Règles:**
- ✅ Implémente les interfaces du domaine
- ✅ Gère la sérialisation JSON
- ✅ Dépend du domaine (jamais l'inverse)
- ❌ Ne contient pas de logique métier

**Exemple:**
```dart
// data/models/fluid_model.dart
class FluidModel extends Fluid {
  factory FluidModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}

// data/datasources/ruler_remote_datasource_impl.dart
class RulerRemoteDataSourceImpl implements RulerRemoteDataSource {
  final http.Client client;
  // Appels HTTP, gestion erreurs
}

// data/repositories/ruler_repository_impl.dart
class RulerRepositoryImpl implements RulerRepository {
  final RulerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, CalculationResult>> calculateSimple(...) {
    // Vérifie réseau
    // Appelle datasource
    // Transforme exceptions → failures
  }
}
```

### 3. Couche PRESENTATION (UI)

**Responsabilités:**
- Gérer l'**état** de l'interface (BLoC)
- Afficher les **pages** et **widgets**
- Réagir aux **événements** utilisateur
- Transformer les **failures** → messages UI

**Règles:**
- ✅ Utilise BLoC pour l'état
- ✅ Dépend uniquement des use cases
- ✅ Ne connaît pas les repositories
- ❌ Pas de logique métier dans les widgets

**Exemple:**
```dart
// presentation/bloc/ruler_bloc.dart
class RulerBloc extends Bloc<RulerEvent, RulerState> {
  final CalculateSimpleRuler calculateSimpleRuler;

  on<CalculateSimpleEvent>((event, emit) async {
    emit(RulerLoading());
    final result = await calculateSimpleRuler(params);
    result.fold(
      (failure) => emit(RulerError(message)),
      (success) => emit(RulerLoaded(result)),
    );
  });
}

// presentation/pages/ruler_page.dart
class RulerPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RulerBloc>(),
      child: BlocBuilder<RulerBloc, RulerState>(
        builder: (context, state) {
          if (state is RulerLoading) return CircularProgressIndicator();
          if (state is RulerError) return ErrorWidget(state.message);
          if (state is RulerLoaded) return ResultDisplay(state.result);
          return FormWidget();
        },
      ),
    );
  }
}
```

## 🔄 Flux de données

```
User Action (UI)
    ↓
[PRESENTATION] BLoC Event
    ↓
[PRESENTATION] BLoC appelle Use Case
    ↓
[DOMAIN] Use Case valide et appelle Repository (interface)
    ↓
[DATA] Repository Impl vérifie réseau
    ↓
[DATA] DataSource fait l'appel API
    ↓
[DATA] Repository transforme Exception → Failure
    ↓
[DOMAIN] Use Case retourne Either<Failure, Result>
    ↓
[PRESENTATION] BLoC émet un nouveau State
    ↓
[PRESENTATION] UI se rebuild automatiquement
```

## 🧪 Testabilité

L'architecture permet de tester chaque couche indépendamment :

```dart
// Test du Use Case (sans réseau, sans UI)
test('should return CalculationResult when repository succeeds', () async {
  // Arrange
  final mockRepository = MockRulerRepository();
  when(mockRepository.calculateSimple(...)).thenAnswer(
    (_) async => Right(expectedResult),
  );
  final useCase = CalculateSimpleRuler(mockRepository);

  // Act
  final result = await useCase(params);

  // Assert
  expect(result, Right(expectedResult));
});

// Test du Repository (sans API réelle)
test('should return NetworkFailure when no internet', () async {
  when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  final result = await repository.calculateSimple(...);
  expect(result, Left(NetworkFailure()));
});

// Test du BLoC (sans UI)
blocTest<RulerBloc, RulerState>(
  'emits [Loading, Loaded] when calculation succeeds',
  build: () => RulerBloc(mockUseCase),
  act: (bloc) => bloc.add(CalculateSimpleEvent(...)),
  expect: () => [RulerLoading(), RulerLoaded(result)],
);
```

## 📦 Injection de Dépendances

Configuration dans [injection_container.dart](lib/core/di/injection_container.dart):

```dart
// External (packages)
getIt.registerLazySingleton<http.Client>(() => http.Client());

// Core
getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

// Data sources
getIt.registerLazySingleton<RulerRemoteDataSource>(
  () => RulerRemoteDataSourceImpl(client: getIt(), baseUrl: '...'),
);

// Repositories
getIt.registerLazySingleton<RulerRepository>(
  () => RulerRepositoryImpl(
    remoteDataSource: getIt(),
    networkInfo: getIt(),
  ),
);

// Use cases
getIt.registerLazySingleton(() => CalculateSimpleRuler(getIt()));

// BLoC (factory pour créer une nouvelle instance à chaque fois)
getIt.registerFactory(() => RulerBloc(
  calculateSimpleRuler: getIt(),
  calculateAdvancedRuler: getIt(),
));
```

## 🚀 Migration progressive

Le projet est en **migration progressive** :

1. ✅ **Feature Ruler** → Nouvelle architecture (architecture hexagonale)
2. ⏳ **Autres features** → Ancienne architecture (à migrer)

Les deux architectures coexistent grâce à :
```dart
// main.dart
void main() async {
  // Ancienne architecture
  setupServiceLocator();

  // Nouvelle architecture
  await initializeDependencies();

  runApp(const MyApp());
}
```

## 📝 Comment ajouter une nouvelle feature

### 1. Créer la structure de dossiers

```bash
lib/features/ma_feature/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

### 2. Implémenter de l'intérieur vers l'extérieur

1. **Domain** : Entités → Repository interface → Use cases
2. **Data** : Models → DataSource → Repository impl
3. **Presentation** : BLoC (events/states) → Pages → Widgets

### 3. Configurer l'injection de dépendances

Ajouter dans `injection_container.dart` :
```dart
// Data sources
getIt.registerLazySingleton<MaFeatureDataSource>(...);

// Repository
getIt.registerLazySingleton<MaFeatureRepository>(...);

// Use cases
getIt.registerLazySingleton(() => MonUseCase(getIt()));

// BLoC
getIt.registerFactory(() => MaFeatureBloc(...));
```

### 4. Ajouter la route dans main.dart

```dart
routes: {
  '/ma-feature': (context) => const MaFeaturePage(),
}
```

## 🎯 Avantages de cette architecture

| Avantage | Explication |
|----------|-------------|
| **Testabilité** | Chaque couche peut être testée indépendamment avec des mocks |
| **Maintenabilité** | Changement d'API ? Seule la couche data change |
| **Scalabilité** | Ajout de features sans impacter l'existant |
| **Indépendance** | Le domaine ne dépend de rien (ni Flutter, ni packages) |
| **Flexibilité** | Changement de state management ? Seule la présentation change |
| **Séparation** | Logique métier séparée de l'UI et de l'infrastructure |

## 📚 Ressources

- [Clean Architecture par Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture par Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Dartz (Functional Programming)](https://pub.dev/packages/dartz)
- [GetIt (Service Locator)](https://pub.dev/packages/get_it)

## 🤝 Contribution

Pour migrer une feature existante vers la nouvelle architecture :

1. Créer la structure `features/nom_feature/`
2. Migrer les entités dans `domain/entities/`
3. Créer les use cases dans `domain/usecases/`
4. Implémenter les repositories et datasources dans `data/`
5. Créer le BLoC dans `presentation/bloc/`
6. Migrer les screens dans `presentation/pages/`
7. Configurer l'injection de dépendances
8. Mettre à jour les routes dans main.dart
9. Supprimer l'ancien code de `screens/`, `services/`, etc.

---

**Auteur:** Équipe App Froid
**Dernière mise à jour:** Décembre 2025
