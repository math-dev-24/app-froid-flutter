import 'package:app_froid/features/lfl_volume/domain/entities/lfl_result.dart';

class LflResultModel extends LflResult {
  const LflResultModel({
    required super.minimumVolumeM3,
    required super.safetyVolumeM3,
    required super.density,
  });
}
