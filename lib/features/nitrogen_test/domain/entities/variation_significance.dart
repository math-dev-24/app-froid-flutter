import 'package:equatable/equatable.dart';

/// Type de signification de la variation de pression
enum VariationStatus {
  success, // Variation négligeable
  warning, // Variation modérée
  error, // Variation significative
}

/// Entité représentant la signification d'une variation de pression
class VariationSignificance extends Equatable {
  final VariationStatus status;
  final String message;

  const VariationSignificance({
    required this.status,
    required this.message,
  });

  @override
  List<Object> get props => [status, message];
}
