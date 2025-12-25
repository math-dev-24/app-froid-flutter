import '../../domain/entities/signal_type.dart';

/// Modèle de données pour SignalType
class SignalTypeModel extends SignalType {
  const SignalTypeModel({
    required super.min,
    required super.max,
    required super.delta,
    required super.unit,
    required super.label,
  });

  factory SignalTypeModel.fromEntity(SignalType signalType) {
    return SignalTypeModel(
      min: signalType.min,
      max: signalType.max,
      delta: signalType.delta,
      unit: signalType.unit,
      label: signalType.label,
    );
  }
}
