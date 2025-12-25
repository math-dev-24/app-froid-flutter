# Guide de Migration vers l'Architecture Hexagonale

## 🎯 Objectif

Ce guide explique comment migrer progressivement les features existantes de l'ancienne architecture vers la nouvelle architecture hexagonale.

## ✅ État actuel

### Feature migrée
- ✅ **Ruler (Règlette)** - Architecture hexagonale complète

### Features à migrer
- ⏳ Règlette avancée (Advanced Ruler)
- ⏳ Signal capteur (Sensor Convert)
- ⏳ Convertisseur (Converter)
- ⏳ Diamètre équivalent (Equivalent Diameter)
- ⏳ Interpolation linéaire (Interpolation)
- ⏳ DESP
- ⏳ Test d'Azote (Nitrogen Test)
- ⏳ Pression Moyenne (Intermediate Pressure)
- ⏳ Calcul de Charge (Refrigerant Charge)
- ⏳ Volume Mini LFL (LFL Volume)
- ⏳ Contact

## 📋 Checklist de migration

Pour chaque feature, suivre ces étapes :

### 1. Préparation (Analyse)

- [ ] Identifier les entités métier de la feature
- [ ] Lister les opérations métier (use cases)
- [ ] Identifier les sources de données (API, local, cache)
- [ ] Noter les dépendances avec d'autres features

### 2. Couche Domain

- [ ] Créer `lib/features/[nom_feature]/domain/entities/`
- [ ] Créer les entités (classes immuables avec Equatable)
- [ ] Créer `lib/features/[nom_feature]/domain/repositories/`
- [ ] Définir les interfaces de repositories
- [ ] Créer `lib/features/[nom_feature]/domain/usecases/`
- [ ] Implémenter les use cases avec validation

**Exemple pour "Converter":**
```dart
// domain/entities/conversion.dart
class Conversion extends Equatable {
  final double value;
  final String unit;
  const Conversion({required this.value, required this.unit});
  @override
  List<Object> get props => [value, unit];
}

// domain/repositories/converter_repository.dart
abstract class ConverterRepository {
  Either<Failure, List<Conversion>> convertPressure(double value, String fromUnit);
  Either<Failure, List<Conversion>> convertTemperature(double value, String fromUnit);
}

// domain/usecases/convert_pressure.dart
class ConvertPressure implements UseCase<List<Conversion>, ConvertPressureParams> {
  final ConverterRepository repository;
  ConvertPressure(this.repository);

  @override
  Future<Either<Failure, List<Conversion>>> call(ConvertPressureParams params) async {
    if (!params.value.isFinite) {
      return const Left(ValidationFailure('Valeur invalide'));
    }
    return repository.convertPressure(params.value, params.fromUnit);
  }
}
```

### 3. Couche Data

- [ ] Créer `lib/features/[nom_feature]/data/models/`
- [ ] Créer les models qui héritent des entités + fromJson/toJson
- [ ] Créer `lib/features/[nom_feature]/data/datasources/`
- [ ] Implémenter les datasources (remote, local)
- [ ] Créer `lib/features/[nom_feature]/data/repositories/`
- [ ] Implémenter le repository avec gestion erreurs

**Exemple pour "Converter":**
```dart
// data/models/conversion_model.dart
class ConversionModel extends Conversion {
  const ConversionModel({required super.value, required super.unit});

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'unit': unit};
}

// data/datasources/converter_local_datasource.dart
abstract class ConverterLocalDataSource {
  List<ConversionModel> convertPressure(double value, String fromUnit);
}

class ConverterLocalDataSourceImpl implements ConverterLocalDataSource {
  @override
  List<ConversionModel> convertPressure(double value, String fromUnit) {
    // Logique de conversion locale (pas d'API nécessaire)
    switch (fromUnit) {
      case 'bar':
        return [
          ConversionModel(value: value * 0.1, unit: 'MPa'),
          ConversionModel(value: value * 14.5038, unit: 'PSI'),
          // ...
        ];
      // autres conversions
    }
  }
}

// data/repositories/converter_repository_impl.dart
class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterLocalDataSource localDataSource;

  ConverterRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, List<Conversion>> convertPressure(double value, String fromUnit) {
    try {
      final result = localDataSource.convertPressure(value, fromUnit);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Erreur de conversion: ${e.toString()}'));
    }
  }
}
```

### 4. Couche Presentation

- [ ] Créer `lib/features/[nom_feature]/presentation/bloc/`
- [ ] Créer les events (actions utilisateur)
- [ ] Créer les states (états UI)
- [ ] Implémenter le bloc avec handlers
- [ ] Créer `lib/features/[nom_feature]/presentation/pages/`
- [ ] Migrer l'UI vers BlocProvider/BlocBuilder
- [ ] Créer `lib/features/[nom_feature]/presentation/widgets/`
- [ ] Extraire les widgets réutilisables

**Exemple pour "Converter":**
```dart
// presentation/bloc/converter_event.dart
abstract class ConverterEvent extends Equatable {
  const ConverterEvent();
}

class ConvertPressureEvent extends ConverterEvent {
  final double value;
  final String fromUnit;
  const ConvertPressureEvent({required this.value, required this.fromUnit});
  @override
  List<Object> get props => [value, fromUnit];
}

// presentation/bloc/converter_state.dart
abstract class ConverterState extends Equatable {
  const ConverterState();
}

class ConverterInitial extends ConverterState {
  const ConverterInitial();
  @override
  List<Object> get props => [];
}

class ConverterLoaded extends ConverterState {
  final List<Conversion> conversions;
  const ConverterLoaded({required this.conversions});
  @override
  List<Object> get props => [conversions];
}

// presentation/bloc/converter_bloc.dart
class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertPressure convertPressure;
  final ConvertTemperature convertTemperature;

  ConverterBloc({
    required this.convertPressure,
    required this.convertTemperature,
  }) : super(const ConverterInitial()) {
    on<ConvertPressureEvent>(_onConvertPressure);
    on<ConvertTemperatureEvent>(_onConvertTemperature);
  }

  Future<void> _onConvertPressure(
    ConvertPressureEvent event,
    Emitter<ConverterState> emit,
  ) async {
    final result = await convertPressure(
      ConvertPressureParams(value: event.value, fromUnit: event.fromUnit),
    );
    result.fold(
      (failure) => emit(ConverterError(message: failure.message)),
      (conversions) => emit(ConverterLoaded(conversions: conversions)),
    );
  }
}

// presentation/pages/converter_page.dart
class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConverterBloc>(),
      child: const ConverterView(),
    );
  }
}

class ConverterView extends StatelessWidget {
  const ConverterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convertisseur')),
      body: BlocBuilder<ConverterBloc, ConverterState>(
        builder: (context, state) {
          if (state is ConverterLoaded) {
            return ListView.builder(
              itemCount: state.conversions.length,
              itemBuilder: (context, index) {
                final conversion = state.conversions[index];
                return ListTile(
                  title: Text('${conversion.value} ${conversion.unit}'),
                );
              },
            );
          }
          return const FormWidget();
        },
      ),
    );
  }
}
```

### 5. Injection de dépendances

- [ ] Ouvrir `lib/core/di/injection_container.dart`
- [ ] Ajouter les datasources
- [ ] Ajouter les repositories
- [ ] Ajouter les use cases
- [ ] Ajouter le bloc (en factory)

**Exemple:**
```dart
Future<void> initializeDependencies() async {
  // ... existing code ...

  // ========================================
  // Feature: Converter
  // ========================================

  // Data sources
  getIt.registerLazySingleton<ConverterLocalDataSource>(
    () => ConverterLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ConverterRepository>(
    () => ConverterRepositoryImpl(localDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => ConvertPressure(getIt()));
  getIt.registerLazySingleton(() => ConvertTemperature(getIt()));

  // Bloc
  getIt.registerFactory(
    () => ConverterBloc(
      convertPressure: getIt(),
      convertTemperature: getIt(),
    ),
  );
}
```

### 6. Mise à jour de main.dart

- [ ] Importer la nouvelle page
- [ ] Mettre à jour la route

**Exemple:**
```dart
import 'package:app_froid/features/converter/presentation/pages/converter_page.dart';

// Dans MaterialApp routes:
routes: {
  '/converter': (context) => const ConverterPage(), // Nouvelle architecture
}
```

### 7. Nettoyage

- [ ] Supprimer l'ancien screen de `lib/screens/`
- [ ] Supprimer l'ancien service de `lib/services/`
- [ ] Supprimer les anciens models de `lib/data/models/`
- [ ] Vérifier qu'aucune dépendance vers l'ancien code
- [ ] Lancer `flutter analyze` pour vérifier

### 8. Tests

- [ ] Tester le use case (unit test)
- [ ] Tester le repository (unit test)
- [ ] Tester le bloc (bloc test)
- [ ] Tester l'UI (widget test)

## 🎯 Ordre de migration recommandé

Migrer dans cet ordre (du plus simple au plus complexe) :

1. **Convertisseur** - Pas d'API, logique simple
2. **Signal capteur** - Conversion simple, pas d'API
3. **Interpolation** - Calculs mathématiques simples
4. **Diamètre équivalent** - Calculs géométriques
5. **Règlette avancée** - Réutilise le repository Ruler existant
6. **Test d'Azote** - Calculs thermodynamiques
7. **Pression Moyenne** - Calculs thermodynamiques
8. **DESP** - Logique de classification
9. **Calcul de Charge** - Dimensionnement
10. **Volume Mini LFL** - Calculs complexes
11. **Contact** - Intégration Coda API

## 📊 Estimation du temps

| Feature | Complexité | Temps estimé |
|---------|------------|--------------|
| Convertisseur | Faible | 2h |
| Signal capteur | Faible | 2h |
| Interpolation | Faible | 2h |
| Diamètre équivalent | Faible | 2h |
| Règlette avancée | Moyenne | 3h |
| Test d'Azote | Moyenne | 3h |
| Pression Moyenne | Moyenne | 3h |
| DESP | Moyenne | 3h |
| Calcul de Charge | Élevée | 4h |
| Volume Mini LFL | Élevée | 4h |
| Contact | Faible | 2h |

**Total estimé:** ~30 heures de développement

## 🚨 Pièges à éviter

1. **Ne pas mélanger les architectures** dans une même feature
2. **Ne pas mettre de logique métier dans le BLoC** (uniquement coordination)
3. **Ne pas faire dépendre le domain de data ou presentation**
4. **Ne pas oublier la validation dans les use cases**
5. **Ne pas oublier de gérer les erreurs réseau**
6. **Ne pas créer des entités mutables** (toujours const et Equatable)

## ✅ Vérification post-migration

Après chaque migration, vérifier :

```bash
# Pas d'erreurs d'analyse
flutter analyze

# Pas d'erreurs de compilation
flutter build appbundle --release --dry-run

# Les tests passent
flutter test

# L'app se lance correctement
flutter run
```

## 📚 Références

- Exemple complet : `lib/features/ruler/`
- Documentation architecture : [ARCHITECTURE.md](ARCHITECTURE.md)
- Clean Architecture : https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

**Bon courage pour la migration ! 🚀**
