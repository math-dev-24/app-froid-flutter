import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Classe abstraite pour tous les Use Cases
/// Params: Type des paramètres d'entrée
/// Type: Type de la donnée retournée en cas de succès
abstract class UseCase<Type, Params> {
  /// Exécute le cas d'usage
  /// Retourne Either un Failure (gauche) ou le résultat Type (droite)
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe utilisée quand un Use Case n'a pas besoin de paramètres
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
