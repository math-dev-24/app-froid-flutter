import 'package:app_froid/features/refrigerant_charge/data/datasources/refrigerant_charge_local_datasource.dart';
import 'package:app_froid/features/refrigerant_charge/data/models/charge_result_model.dart';
import 'package:app_froid/features/refrigerant_charge/data/models/fluid_model.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';

class RefrigerantChargeLocalDataSourceImpl
    implements RefrigerantChargeLocalDataSource {
  static const List<FluidModel> _fluids = [
    FluidModel(id: "R1234ze", label: "R1234ze", desp: 2, lfl: 0.303, gwp: 1.37),
    FluidModel(id: "R1234yf", label: "R1234yf", desp: 2, lfl: 0.289, gwp: 0.501),
    FluidModel(id: "R32", label: "R32", desp: 1, lfl: 0.307, gwp: 675),
    FluidModel(id: "R454A", label: "R454A", desp: 1, lfl: 0.289, gwp: 270),
    FluidModel(id: "R454B", label: "R454B", desp: 1, lfl: 0.297, gwp: 531),
    FluidModel(id: "R454C", label: "R454C", desp: 1, lfl: 0.293, gwp: 145.5),
    FluidModel(id: "R455A", label: "R455A", desp: 1, lfl: 0.431, gwp: 145.5),
  ];

  @override
  Future<ChargeResultModel> calculateCharge(
    ChargeParameters parameters,
  ) async {
    // Calcul des facteurs M
    final double factorM1 = ((parameters.lfl * 4) * 100).round() / 100;
    final double factorM2 = ((parameters.lfl * 26) * 100).round() / 100;
    final double factorM3 = ((parameters.lfl * 130) * 100).round() / 100;

    // Classification III - Pas de limite de charge
    if (parameters.classification == Classification.trois) {
      return const ChargeResultModel(
        factorM1: 0,
        factorM2: 0,
        factorM3: 0,
        message: "Pas de limite de charge !",
      );
    }

    // Classification IV - Charge = M3
    if (parameters.classification == Classification.quatre) {
      return ChargeResultModel(
        factorM1: factorM1,
        factorM2: factorM2,
        factorM3: factorM3,
        chargeLimit: factorM3,
      );
    }

    // Pour les autres classifications, on a besoin du volume
    return ChargeResultModel(
      factorM1: factorM1,
      factorM2: factorM2,
      factorM3: factorM3,
    );
  }

  @override
  Future<List<FluidModel>> getAvailableFluids() async {
    return _fluids;
  }
}
