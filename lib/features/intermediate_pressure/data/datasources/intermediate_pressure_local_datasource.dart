import 'package:app_froid/features/intermediate_pressure/data/models/pressure_result_model.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';

abstract class IntermediatePressureLocalDataSource {
  Future<PressureResultModel> calculateIntermediatePressure(
    PressureParameters parameters,
  );
}
