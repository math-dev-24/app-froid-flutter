import 'package:equatable/equatable.dart';

class PressureResult extends Equatable {
  final double intermediateEqualEfficiency;
  final double intermediateSandHold;
  final double compressionRatioHPEqual;
  final double compressionRatioBPEqual;
  final double compressionRatioHPSandHold;
  final double compressionRatioBPSandHold;

  const PressureResult({
    required this.intermediateEqualEfficiency,
    required this.intermediateSandHold,
    required this.compressionRatioHPEqual,
    required this.compressionRatioBPEqual,
    required this.compressionRatioHPSandHold,
    required this.compressionRatioBPSandHold,
  });

  @override
  List<Object?> get props => [
        intermediateEqualEfficiency,
        intermediateSandHold,
        compressionRatioHPEqual,
        compressionRatioBPEqual,
        compressionRatioHPSandHold,
        compressionRatioBPSandHold,
      ];
}
