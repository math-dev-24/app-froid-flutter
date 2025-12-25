import '../../domain/entities/test_parameters.dart';
import '../models/test_result_model.dart';

/// Interface de la source de données locale pour le test d'azote
abstract class NitrogenTestLocalDataSource {
  TestResultModel calculate(TestParameters parameters);
}
