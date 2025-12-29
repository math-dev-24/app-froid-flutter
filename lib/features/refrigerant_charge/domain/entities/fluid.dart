import 'package:equatable/equatable.dart';

class Fluid extends Equatable {
  final String id;
  final String label;
  final int desp;
  final double lfl;
  final double gwp;

  const Fluid({
    required this.id,
    required this.label,
    required this.desp,
    required this.lfl,
    required this.gwp,
  });

  @override
  List<Object?> get props => [id, label, desp, lfl, gwp];
}
