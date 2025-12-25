/// Exception levée quand le serveur retourne une erreur
class ServerException implements Exception {
  final String? message;

  ServerException([this.message]);

  @override
  String toString() => message ?? 'ServerException';
}

/// Exception levée quand il n'y a pas de connexion réseau
class NetworkException implements Exception {
  final String? message;

  NetworkException([this.message]);

  @override
  String toString() => message ?? 'NetworkException';
}

/// Exception levée lors du parsing de données invalides
class ParsingException implements Exception {
  final String? message;

  ParsingException([this.message]);

  @override
  String toString() => message ?? 'ParsingException';
}

/// Exception levée quand le cache est vide ou invalide
class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);

  @override
  String toString() => message ?? 'CacheException';
}
