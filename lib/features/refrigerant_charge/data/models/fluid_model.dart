import 'package:app_froid/features/refrigerant_charge/domain/entities/fluid.dart';

class FluidModel extends Fluid {
  const FluidModel({
    required super.id,
    required super.label,
    required super.desp,
    required super.lfl,
    required super.gwp,
  });

  factory FluidModel.fromEntity(Fluid entity) {
    return FluidModel(
      id: entity.id,
      label: entity.label,
      desp: entity.desp,
      lfl: entity.lfl,
      gwp: entity.gwp,
    );
  }
}
