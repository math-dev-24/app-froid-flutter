import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_result.dart';

class ChargeResultModel extends ChargeResult {
  const ChargeResultModel({
    required super.factorM1,
    required super.factorM2,
    required super.factorM3,
    super.message,
    super.chargeLimit,
  });

  factory ChargeResultModel.fromEntity(ChargeResult entity) {
    return ChargeResultModel(
      factorM1: entity.factorM1,
      factorM2: entity.factorM2,
      factorM3: entity.factorM3,
      message: entity.message,
      chargeLimit: entity.chargeLimit,
    );
  }
}
