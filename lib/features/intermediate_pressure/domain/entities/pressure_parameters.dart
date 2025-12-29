import 'package:equatable/equatable.dart';

class PressureParameters extends Equatable {
  final double highPressure;
  final double lowPressure;

  const PressureParameters({
    required this.highPressure,
    required this.lowPressure,
  });

  @override
  List<Object?> get props => [highPressure, lowPressure];
}
