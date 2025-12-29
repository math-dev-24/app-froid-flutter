import 'package:app_froid/features/refrigerant_charge/data/models/charge_result_model.dart';
import 'package:app_froid/features/refrigerant_charge/data/models/fluid_model.dart';
import 'package:app_froid/features/refrigerant_charge/domain/entities/charge_parameters.dart';

abstract class RefrigerantChargeLocalDataSource {
  Future<ChargeResultModel> calculateCharge(ChargeParameters parameters);
  Future<List<FluidModel>> getAvailableFluids();
}
