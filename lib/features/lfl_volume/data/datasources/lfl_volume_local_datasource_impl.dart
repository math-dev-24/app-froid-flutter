import 'package:app_froid/features/lfl_volume/data/datasources/lfl_volume_local_datasource.dart';
import 'package:app_froid/features/lfl_volume/data/models/flammable_fluid_model.dart';
import 'package:app_froid/features/lfl_volume/data/models/lfl_result_model.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';

class LflVolumeLocalDataSourceImpl implements LflVolumeLocalDataSource {
  static const List<FlammableFluidModel> _fluids = [
    FlammableFluidModel(
      refName: 'PROPANE',
      name: 'Propane (R290)',
      classification: 'A3',
      description: 'Fluide frigorigène naturel hautement inflammable',
      lfl: LflRange(lower: 2.1, upper: 9.5),
    ),
    FlammableFluidModel(
      refName: 'R32',
      name: 'R32',
      classification: 'A2L',
      description: 'Fluide HFC faiblement inflammable',
      lfl: LflRange(lower: 13.3, upper: 29.3),
    ),
    FlammableFluidModel(
      refName: 'R1234YF',
      name: 'R1234yf',
      classification: 'A2L',
      description: 'Fluide HFO faiblement inflammable, faible GWP',
      lfl: LflRange(lower: 6.2, upper: 12.3),
    ),
  ];

  @override
  Future<LflResultModel> calculateLflVolume(
    LflParameters parameters,
    double safetyFactor,
  ) async {
    // LFL en kg/m³ = (LFL% × densité) / 100
    final lflLowerKgM3 = (parameters.lflLower * parameters.density) / 100;

    // Volume minimum (m³) = Charge (kg) / LFL (kg/m³)
    final minimumVolumeM3 =
        ((parameters.fluidCharge / lflLowerKgM3) * 1000).round() / 1000;

    // Volume de sécurité
    final safetyVolumeM3 =
        ((minimumVolumeM3 * (1 + safetyFactor)) * 1000).round() / 1000;

    return LflResultModel(
      minimumVolumeM3: minimumVolumeM3,
      safetyVolumeM3: safetyVolumeM3,
      density: parameters.density,
    );
  }

  @override
  Future<List<FlammableFluidModel>> getAvailableFluids() async {
    return _fluids;
  }
}
