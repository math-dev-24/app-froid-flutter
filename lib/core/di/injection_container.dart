import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/ruler/data/datasources/ruler_remote_datasource.dart';
import '../../features/ruler/data/datasources/ruler_remote_datasource_impl.dart';
import '../../features/ruler/data/repositories/ruler_repository_impl.dart';
import '../../features/ruler/domain/repositories/ruler_repository.dart';
import '../../features/ruler/domain/usecases/calculate_advanced_ruler.dart';
import '../../features/ruler/domain/usecases/calculate_simple_ruler.dart';
import '../../features/ruler/presentation/bloc/ruler_bloc.dart';
import '../../features/converter/data/datasources/converter_local_datasource.dart';
import '../../features/converter/data/datasources/converter_local_datasource_impl.dart';
import '../../features/converter/data/repositories/converter_repository_impl.dart';
import '../../features/converter/domain/repositories/converter_repository.dart';
import '../../features/converter/domain/usecases/convert_pressure.dart';
import '../../features/converter/domain/usecases/convert_temperature.dart';
import '../../features/converter/presentation/bloc/converter_bloc.dart';
import '../../features/sensor_signal/data/datasources/sensor_signal_local_datasource.dart';
import '../../features/sensor_signal/data/datasources/sensor_signal_local_datasource_impl.dart';
import '../../features/sensor_signal/data/repositories/sensor_signal_repository_impl.dart';
import '../../features/sensor_signal/domain/repositories/sensor_signal_repository.dart';
import '../../features/sensor_signal/domain/usecases/convert_sensor_signal.dart';
import '../../features/sensor_signal/presentation/bloc/sensor_signal_bloc.dart';
import '../../features/interpolation/data/datasources/interpolation_local_datasource.dart';
import '../../features/interpolation/data/datasources/interpolation_local_datasource_impl.dart';
import '../../features/interpolation/data/repositories/interpolation_repository_impl.dart';
import '../../features/interpolation/domain/repositories/interpolation_repository.dart';
import '../../features/interpolation/domain/usecases/calculate_interpolation.dart';
import '../../features/interpolation/presentation/bloc/interpolation_bloc.dart';
import '../../features/equivalent_diameter/data/datasources/equivalent_diameter_local_datasource.dart';
import '../../features/equivalent_diameter/data/datasources/equivalent_diameter_local_datasource_impl.dart';
import '../../features/equivalent_diameter/data/repositories/equivalent_diameter_repository_impl.dart';
import '../../features/equivalent_diameter/domain/repositories/equivalent_diameter_repository.dart';
import '../../features/equivalent_diameter/domain/usecases/calculate_equivalent_diameter.dart';
import '../../features/equivalent_diameter/presentation/bloc/equivalent_diameter_bloc.dart';
import '../../features/nitrogen_test/data/datasources/nitrogen_test_local_datasource.dart';
import '../../features/nitrogen_test/data/datasources/nitrogen_test_local_datasource_impl.dart';
import '../../features/nitrogen_test/data/repositories/nitrogen_test_repository_impl.dart';
import '../../features/nitrogen_test/domain/repositories/nitrogen_test_repository.dart';
import '../../features/nitrogen_test/domain/usecases/calculate_nitrogen_test.dart';
import '../../features/nitrogen_test/presentation/bloc/nitrogen_test_bloc.dart';
import '../../features/desp/data/datasources/desp_local_datasource.dart';
import '../../features/desp/data/datasources/desp_local_datasource_impl.dart';
import '../../features/desp/data/repositories/desp_repository_impl.dart';
import '../../features/desp/domain/repositories/desp_repository.dart';
import '../../features/desp/domain/usecases/calculate_desp_category.dart';
import '../../features/desp/presentation/bloc/desp_bloc.dart';
import '../../features/intermediate_pressure/data/datasources/intermediate_pressure_local_datasource.dart';
import '../../features/intermediate_pressure/data/datasources/intermediate_pressure_local_datasource_impl.dart';
import '../../features/intermediate_pressure/data/repositories/intermediate_pressure_repository_impl.dart';
import '../../features/intermediate_pressure/domain/repositories/intermediate_pressure_repository.dart';
import '../../features/intermediate_pressure/domain/usecases/calculate_intermediate_pressure.dart';
import '../../features/intermediate_pressure/presentation/bloc/intermediate_pressure_bloc.dart';
import '../../features/refrigerant_charge/data/datasources/refrigerant_charge_local_datasource.dart';
import '../../features/refrigerant_charge/data/datasources/refrigerant_charge_local_datasource_impl.dart';
import '../../features/refrigerant_charge/data/repositories/refrigerant_charge_repository_impl.dart';
import '../../features/refrigerant_charge/domain/repositories/refrigerant_charge_repository.dart';
import '../../features/refrigerant_charge/domain/usecases/calculate_refrigerant_charge.dart';
import '../../features/refrigerant_charge/domain/usecases/get_available_fluids.dart';
import '../../features/refrigerant_charge/presentation/bloc/refrigerant_charge_bloc.dart';
import '../../features/lfl_volume/data/datasources/lfl_volume_local_datasource.dart';
import '../../features/lfl_volume/data/datasources/lfl_volume_local_datasource_impl.dart';
import '../../features/lfl_volume/data/repositories/lfl_volume_repository_impl.dart';
import '../../features/lfl_volume/domain/repositories/lfl_volume_repository.dart';
import '../../features/lfl_volume/domain/usecases/calculate_lfl_volume.dart';
import '../../features/lfl_volume/domain/usecases/get_flammable_fluids.dart';
import '../../features/lfl_volume/presentation/bloc/lfl_volume_bloc.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';

/// Instance globale de GetIt pour l'injection de dépendances
final getIt = GetIt.instance;

/// Configure toutes les dépendances de l'application
///
/// Cette fonction doit être appelée une seule fois au démarrage de l'app
/// Organisation:
/// - External (packages tiers)
/// - Core (services partagés)
/// - Features (par fonctionnalité)
Future<void> initializeDependencies() async {
  // ========================================
  // External Dependencies (packages tiers)
  // ========================================

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // ========================================
  // Core Dependencies
  // ========================================

  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  // ========================================
  // Feature: Ruler
  // ========================================

  // Data sources
  getIt.registerLazySingleton<RulerRemoteDataSource>(
    () => RulerRemoteDataSourceImpl(
      client: getIt(),
      baseUrl: 'https://api-ovh.mathieu-busse.dev/v1',
    ),
  );

  // Repository
  getIt.registerLazySingleton<RulerRepository>(
    () => RulerRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateSimpleRuler(getIt()));
  getIt.registerLazySingleton(() => CalculateAdvancedRuler(getIt()));

  // Bloc
  getIt.registerFactory(
    () => RulerBloc(
      calculateSimpleRuler: getIt(),
      calculateAdvancedRuler: getIt(),
    ),
  );

  // ========================================
  // Feature: Converter
  // ========================================

  // Data sources
  getIt.registerLazySingleton<ConverterLocalDataSource>(
    () => ConverterLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ConverterRepository>(
    () => ConverterRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => ConvertPressure(getIt()));
  getIt.registerLazySingleton(() => ConvertTemperature(getIt()));

  // Bloc
  getIt.registerFactory(
    () => ConverterBloc(
      convertPressure: getIt(),
      convertTemperature: getIt(),
    ),
  );

  // ========================================
  // Feature: SensorSignal
  // ========================================

  // Data sources
  getIt.registerLazySingleton<SensorSignalLocalDataSource>(
    () => SensorSignalLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<SensorSignalRepository>(
    () => SensorSignalRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => ConvertSensorSignal(getIt()));

  // Bloc
  getIt.registerFactory(
    () => SensorSignalBloc(
      convertSensorSignal: getIt(),
    ),
  );

  // ========================================
  // Feature: Interpolation
  // ========================================

  // Data sources
  getIt.registerLazySingleton<InterpolationLocalDataSource>(
    () => InterpolationLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<InterpolationRepository>(
    () => InterpolationRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateInterpolation(getIt()));

  // Bloc
  getIt.registerFactory(
    () => InterpolationBloc(
      calculateInterpolation: getIt(),
    ),
  );

  // ========================================
  // Feature: EquivalentDiameter
  // ========================================

  // Data sources
  getIt.registerLazySingleton<EquivalentDiameterLocalDataSource>(
    () => EquivalentDiameterLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<EquivalentDiameterRepository>(
    () => EquivalentDiameterRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateEquivalentDiameter(getIt()));

  // Bloc
  getIt.registerFactory(
    () => EquivalentDiameterBloc(
      calculateEquivalentDiameter: getIt(),
    ),
  );

  // ========================================
  // Feature: NitrogenTest
  // ========================================

  // Data sources
  getIt.registerLazySingleton<NitrogenTestLocalDataSource>(
    () => NitrogenTestLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<NitrogenTestRepository>(
    () => NitrogenTestRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateNitrogenTest(getIt()));

  // Bloc
  getIt.registerFactory(
    () => NitrogenTestBloc(
      calculateNitrogenTest: getIt(),
    ),
  );

  // ========================================
  // Feature: DESP
  // ========================================

  // Data sources
  getIt.registerLazySingleton<DespLocalDataSource>(
    () => DespLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<DespRepository>(
    () => DespRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateDespCategory(getIt()));

  // Bloc
  getIt.registerFactory(
    () => DespBloc(
      calculateDespCategory: getIt(),
    ),
  );

  // ========================================
  // Feature: IntermediatePressure
  // ========================================

  // Data sources
  getIt.registerLazySingleton<IntermediatePressureLocalDataSource>(
    () => IntermediatePressureLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<IntermediatePressureRepository>(
    () => IntermediatePressureRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => CalculateIntermediatePressure(getIt()));

  // Bloc
  getIt.registerFactory(
    () => IntermediatePressureBloc(
      calculateIntermediatePressure: getIt(),
    ),
  );

  // ========================================
  // Feature: RefrigerantCharge
  // ========================================

  // Data sources
  getIt.registerLazySingleton<RefrigerantChargeLocalDataSource>(
    () => RefrigerantChargeLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<RefrigerantChargeRepository>(
    () => RefrigerantChargeRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAvailableFluids(getIt()));
  getIt.registerLazySingleton(() => CalculateRefrigerantCharge(getIt()));

  // Bloc
  getIt.registerFactory(
    () => RefrigerantChargeBloc(
      getAvailableFluids: getIt(),
      calculateRefrigerantCharge: getIt(),
    ),
  );

  // ========================================
  // Feature: LflVolume
  // ========================================

  // Data sources
  getIt.registerLazySingleton<LflVolumeLocalDataSource>(
    () => LflVolumeLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<LflVolumeRepository>(
    () => LflVolumeRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetFlammableFluids(getIt()));
  getIt.registerLazySingleton(() => CalculateLflVolume(getIt()));

  // Bloc
  getIt.registerFactory(
    () => LflVolumeBloc(
      getFlammableFluids: getIt(),
      calculateLflVolume: getIt(),
    ),
  );
}
