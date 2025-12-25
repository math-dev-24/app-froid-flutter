import 'package:equatable/equatable.dart';

abstract class EquivalentDiameterEvent extends Equatable {
  const EquivalentDiameterEvent();
  @override
  List<Object> get props => [];
}

class CalculateDiameterEvent extends EquivalentDiameterEvent {
  final double width;
  final double height;

  const CalculateDiameterEvent({
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [width, height];
}
