import 'package:equatable/equatable.dart';

class ChargeResult extends Equatable {
  final double factorM1;
  final double factorM2;
  final double factorM3;
  final String? message;
  final double? chargeLimit;

  const ChargeResult({
    required this.factorM1,
    required this.factorM2,
    required this.factorM3,
    this.message,
    this.chargeLimit,
  });

  @override
  List<Object?> get props => [
        factorM1,
        factorM2,
        factorM3,
        message,
        chargeLimit,
      ];
}
