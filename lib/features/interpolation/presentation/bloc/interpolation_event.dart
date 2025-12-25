import 'package:equatable/equatable.dart';

abstract class InterpolationEvent extends Equatable {
  const InterpolationEvent();
  @override
  List<Object> get props => [];
}

class CalculateInterpolationEvent extends InterpolationEvent {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x;

  const CalculateInterpolationEvent({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x,
  });

  @override
  List<Object> get props => [x1, y1, x2, y2, x];
}
