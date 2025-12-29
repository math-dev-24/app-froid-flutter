import 'package:app_froid/features/lfl_volume/data/models/flammable_fluid_model.dart';
import 'package:app_froid/features/lfl_volume/data/models/lfl_result_model.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';

abstract class LflVolumeLocalDataSource {
  Future<LflResultModel> calculateLflVolume(
    LflParameters parameters,
    double safetyFactor,
  );
  Future<List<FlammableFluidModel>> getAvailableFluids();
}
