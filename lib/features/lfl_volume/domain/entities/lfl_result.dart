import 'package:equatable/equatable.dart';

class LflResult extends Equatable {
  final double minimumVolumeM3;
  final double safetyVolumeM3;
  final double density;

  const LflResult({
    required this.minimumVolumeM3,
    required this.safetyVolumeM3,
    required this.density,
  });

  @override
  List<Object?> get props => [minimumVolumeM3, safetyVolumeM3, density];
}
