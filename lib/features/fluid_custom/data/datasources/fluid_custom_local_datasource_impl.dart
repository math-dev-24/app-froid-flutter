import 'package:shared_preferences/shared_preferences.dart';
import '../models/fluid_custom_model.dart';
import 'fluid_custom_local_datasource.dart';

/// Implémentation de la source de données locale pour les fluides personnalisés
///
/// Utilise SharedPreferences pour la persistance
class FluidCustomLocalDataSourceImpl implements FluidCustomLocalDataSource {
  static const String _keyFluidCustoms = 'fluid_customs';
  final SharedPreferences sharedPreferences;

  FluidCustomLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FluidCustomModel>> getFluidCustoms() async {
    final jsonString = sharedPreferences.getString(_keyFluidCustoms);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return FluidCustomModel.listFromJson(jsonString);
  }

  @override
  Future<void> saveFluidCustoms(List<FluidCustomModel> fluids) async {
    final jsonString = FluidCustomModel.listToJson(fluids);
    await sharedPreferences.setString(_keyFluidCustoms, jsonString);
  }

  @override
  Future<void> addFluidCustom(FluidCustomModel fluid) async {
    final fluids = await getFluidCustoms();
    fluids.add(fluid);
    await saveFluidCustoms(fluids);
  }

  @override
  Future<void> updateFluidCustom(int index, FluidCustomModel fluid) async {
    final fluids = await getFluidCustoms();
    if (index >= 0 && index < fluids.length) {
      fluids[index] = fluid;
      await saveFluidCustoms(fluids);
    }
  }

  @override
  Future<void> removeFluidCustom(int index) async {
    final fluids = await getFluidCustoms();
    if (index >= 0 && index < fluids.length) {
      fluids.removeAt(index);
      await saveFluidCustoms(fluids);
    }
  }
}
