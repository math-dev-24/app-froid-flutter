import 'package:equatable/equatable.dart';

/// Entité représentant un fluide personnalisé (mélange)
///
/// Un fluide personnalisé est composé de plusieurs fluides de base
/// avec des quantités (pourcentages) définies
class FluidCustom extends Equatable {
  final String label;
  final List<String> fluids;
  final List<String> fluidsRef;
  final List<double> quantities; // En décimal (0.0 à 1.0)

  const FluidCustom({
    required this.label,
    required this.fluids,
    required this.fluidsRef,
    required this.quantities,
  });

  /// Vérifie si le total des quantités est valide (≈ 1.0 ou 100%)
  bool get isValidTotal {
    final total = quantities.fold<double>(0.0, (sum, qty) => sum + qty);
    return (total - 1.0).abs() < 0.001; // Tolérance de 0.1%
  }

  /// Récupère le total en décimal
  double get totalDecimal {
    return quantities.fold<double>(0.0, (sum, qty) => sum + qty);
  }

  /// Vérifie si tous les fluides sont sélectionnés
  bool get hasAllFluidsSelected {
    return fluids.every((fluid) => fluid.trim().isNotEmpty);
  }

  /// Crée une copie avec des modifications
  FluidCustom copyWith({
    String? label,
    List<String>? fluids,
    List<String>? fluidsRef,
    List<double>? quantities,
  }) {
    return FluidCustom(
      label: label ?? this.label,
      fluids: fluids ?? this.fluids,
      fluidsRef: fluidsRef ?? this.fluidsRef,
      quantities: quantities ?? this.quantities,
    );
  }

  /// Crée un fluide vide pour l'édition
  factory FluidCustom.empty() {
    return const FluidCustom(
      label: '',
      fluids: ['', ''],
      fluidsRef: ['', ''],
      quantities: [0.0, 0.0],
    );
  }

  @override
  List<Object?> get props => [label, fluids, fluidsRef, quantities];
}
