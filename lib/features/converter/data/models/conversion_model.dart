import '../../domain/entities/conversion.dart';

/// Modèle de données pour Conversion
///
/// Hérite de l'entité du domaine (pas besoin de JSON pour cette feature)
class ConversionModel extends Conversion {
  const ConversionModel({
    required super.value,
    required super.unit,
  });

  /// Crée un ConversionModel à partir d'une entité Conversion
  factory ConversionModel.fromEntity(Conversion conversion) {
    return ConversionModel(
      value: conversion.value,
      unit: conversion.unit,
    );
  }
}
