import 'package:equatable/equatable.dart';

/// Classe abstraite représentant un échec dans le domaine métier
/// Tous les échecs doivent hériter de cette classe
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Échec lors d'un appel au serveur
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Erreur serveur'])
      : super(message);
}

/// Échec dû à une absence de connexion réseau
class NetworkFailure extends Failure {
  const NetworkFailure(
      [String message = 'Aucune connexion Internet'])
      : super(message);
}

/// Échec lors de la validation des données
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Échec lors du parsing des données
class ParsingFailure extends Failure {
  const ParsingFailure(
      [String message = 'Erreur lors du traitement des données'])
      : super(message);
}

/// Échec dû à un cache vide ou invalide
class CacheFailure extends Failure {
  const CacheFailure(
      [String message = 'Aucune donnée en cache'])
      : super(message);
}
