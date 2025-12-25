import 'package:equatable/equatable.dart';

/// Entité représentant les dimensions d'un conduit rectangulaire
class DuctDimensions extends Equatable {
  final double width;
  final double height;

  const DuctDimensions({
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [width, height];
}
