import '../../domain/entities/desp_parameters.dart';
import '../../domain/entities/equipment_type.dart';
import '../../domain/entities/fluid_nature.dart';
import '../models/desp_result_model.dart';
import 'desp_local_datasource.dart';

/// Implémentation de la source de données locale pour DESP
class DespLocalDataSourceImpl implements DespLocalDataSource {
  @override
  DespResultModel calculate(DespParameters parameters) {
    final category = _calculateCategory(parameters);
    final description = _getCategoryDescription(category);

    // Calcul PS×V ou PS×DN selon le type d'équipement
    final pvValue = parameters.equipmentType == EquipmentType.tuyauterie
        ? parameters.pressure * parameters.nominalDiameter
        : parameters.pressure * parameters.volume;

    final pvUnit = parameters.equipmentType == EquipmentType.tuyauterie
        ? 'bar·mm'
        : 'bar·L';

    return DespResultModel(
      category: category,
      description: description,
      pvValue: pvValue,
      pvUnit: pvUnit,
    );
  }

  String _calculateCategory(DespParameters params) {
    const art43 = "Art 4§3";
    const catI = "Cat I";
    const catII = "Cat II";
    const catIII = "Cat III";
    const catIV = "Cat IV";

    if (params.pressure < 0.5) {
      return "Non soumis";
    }

    final pvs = params.pressure * params.volume;
    final pvn = params.pressure * params.nominalDiameter;

    String result = "";

    if (params.dangerGroup == 1) {
      if (params.fluidNature == FluidNature.liquide) {
        if (params.equipmentType == EquipmentType.tuyauterie) {
          // Tuyauterie liquide G1
          if (params.nominalDiameter <= 25) result = art43;
          if (pvn <= 2000 && params.nominalDiameter >= 25) result = art43;
          if (pvn > 2000 && params.pressure <= 10) result = catI;
          if (pvn > 2000 && params.nominalDiameter > 25 && params.pressure <= 500 && params.pressure > 10) result = catII;
          if (params.nominalDiameter > 25 && params.pressure > 500) result = catIII;
        } else {
          // Récipients liquide G1
          if (params.volume < 1 && params.pressure <= 500) result = art43;
          if (params.volume >= 1 && pvs <= 200) result = art43;
          if (pvs > 200 && params.pressure <= 10) result = catI;
          if (pvs > 200 && params.volume >= 1 && params.pressure <= 500 && params.pressure > 10) result = catII;
          if (params.volume <= 1 && params.pressure > 500) result = catII;
          if (params.volume > 1 && params.pressure > 500) result = catIII;
        }
      } else {
        // Gaz
        if (params.equipmentType == EquipmentType.tuyauterie) {
          // Tuyauterie gaz G1
          if (params.nominalDiameter <= 25) result = art43;
          if (params.pressure > 10 && pvn <= 1000 && params.nominalDiameter > 25) result = catI;
          if (params.nominalDiameter < 100 && params.nominalDiameter >= 25 && params.pressure <= 10) result = catI;

          if (params.pressure > 40 && params.nominalDiameter > 25 && params.nominalDiameter <= 100) result = catII;
          if (params.pressure < 35 && params.pressure > 10 && pvn <= 3500 && pvn > 1000) result = catII;
          if (params.pressure > 35 && params.pressure <= 40 && params.nominalDiameter <= 100 && pvn > 1000) result = catII;
          if (params.pressure <= 10 && params.nominalDiameter > 100 && params.nominalDiameter <= 350) result = catII;

          if (params.pressure > 35 && params.nominalDiameter > 100) result = catIII;
          if (params.pressure <= 10 && params.nominalDiameter > 350) result = catIII;
          if (params.pressure > 10 && params.pressure < 35 && pvn > 3500) result = catIII;
        } else {
          // Récipients gaz G1
          if (params.pressure <= 200 && params.volume <= 1) result = art43;
          if (params.volume > 1 && pvs <= 25) result = art43;
          if (pvs > 25 && pvs <= 50 && params.volume > 1) result = catI;
          if (pvs > 50 && pvs <= 200 && params.volume > 1) result = catII;
          if (params.pressure > 200 && params.volume <= 1000 && params.volume < 1) result = catIII;
          if (params.volume > 1 && pvs > 200 && pvs <= 1000) result = catIII;
          if (params.volume <= 1 && params.pressure > 1000) result = catIV;
          if (params.volume >= 1 && pvs > 1000) result = catIV;
        }
      }
    } else {
      // Groupe 2
      if (params.fluidNature == FluidNature.liquide) {
        if (params.equipmentType == EquipmentType.tuyauterie) {
          // Tuyauterie Liquide G2
          if (params.nominalDiameter <= 200) result = art43;
          if (params.nominalDiameter <= 500 && params.nominalDiameter > 200 && pvn <= 5000) result = art43;
          if (params.nominalDiameter > 500 && params.pressure <= 10) result = art43;
          if (params.nominalDiameter > 200 && pvn > 5000 && params.nominalDiameter <= 500 && params.pressure <= 500) result = catI;
          if (params.nominalDiameter > 500 && params.pressure > 10 && params.pressure <= 500) result = catI;
          if (params.nominalDiameter > 200 && params.pressure > 500) result = catII;
        } else {
          // Récipients Liquide G2
          if (params.volume < 10 && params.pressure <= 1000) result = art43;
          if (params.volume >= 10 && pvs <= 10000 && params.volume < 1000) result = art43;
          if (params.volume >= 1000 && params.pressure <= 10) result = art43;
          if (pvs > 10000 && params.pressure <= 500 && params.volume < 1000 && params.pressure > 10) result = catI;
          if (params.pressure > 10 && params.pressure <= 500 && params.volume >= 1000 && pvs > 10000) result = catI;
          if (params.pressure > 1000 && params.volume <= 10) result = catI;
          if (pvs > 10000 && params.pressure > 500 && params.volume > 10) result = catII;
        }
      } else {
        // Gaz
        if (params.equipmentType == EquipmentType.tuyauterie) {
          // Tuyauterie gaz G2
          if (params.nominalDiameter <= 32) result = art43;
          if (params.nominalDiameter > 32 && pvn <= 1000) result = art43;

          if (params.nominalDiameter > 32 && params.pressure > 35 && params.nominalDiameter <= 100) result = catI;
          if (params.pressure <= 35 && params.pressure > 31.25 && pvn <= 3500 && params.nominalDiameter > 32) result = catI;
          if (params.pressure <= 31.25 && pvn > 1000 && pvn <= 3500) result = catI;

          if (params.pressure > 35 && params.nominalDiameter > 100 && params.nominalDiameter <= 250) result = catII;
          if (params.pressure > 20 && params.pressure <= 35 && params.nominalDiameter <= 250 && pvn > 3500) result = catII;
          if (params.pressure <= 20 && pvn <= 5000 && pvn > 3500) result = catII;
          if (params.pressure > 20 && params.nominalDiameter > 250) result = catIII;
          if (params.pressure <= 20 && pvn > 5000) result = catIII;
        } else {
          // Récipients Gaz G2
          if (params.pressure <= 1000 && params.volume <= 1) result = art43;
          if (params.volume >= 1 && pvs <= 50) result = art43;
          if (pvs > 50 && pvs <= 200 && params.volume > 1) result = catI;
          if (pvs > 200 && pvs <= 1000 && params.volume > 1) result = catII;
          if (params.pressure > 1000 && params.pressure <= 3000 && params.volume <= 1) result = catIII;
          if (params.volume > 1 && params.volume <= 1000 && pvs > 1000 && pvs <= 3000) result = catIII;
          if (params.volume > 1000 && params.pressure <= 4 && pvs > 1000) result = catIII;
          if (params.volume <= 1 && params.pressure > 3000) result = catIV;
          if (params.volume > 1 && params.volume <= 1000 && pvs > 3000) result = catIV;
          if (params.volume >= 1000 && params.pressure >= 4) result = catIV;
        }
      }
    }

    return result;
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case "Non soumis":
        return "L'équipement n'est pas soumis à la directive DESP";
      case "Art 4§3":
        return "Conception selon les règles de l'art";
      case "Cat I":
        return "Niveau de risque faible";
      case "Cat II":
        return "Niveau de risque modéré";
      case "Cat III":
        return "Niveau de risque élevé";
      case "Cat IV":
        return "Niveau de risque très élevé";
      default:
        return "";
    }
  }
}
