import 'package:equatable/equatable.dart';

/// Résultat de la catégorisation DESP
class DespResult extends Equatable {
  final String category;
  final String description;
  final double pvValue;
  final String pvUnit;

  const DespResult({
    required this.category,
    required this.description,
    required this.pvValue,
    required this.pvUnit,
  });

  @override
  List<Object> get props => [category, description, pvValue, pvUnit];
}
