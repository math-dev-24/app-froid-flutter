import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/entities/fluid.dart';
import '../../domain/repositories/ruler_repository.dart';
import '../datasources/ruler_remote_datasource.dart';

/// Implémentation concrète du RulerRepository
///
/// Coordonne les appels entre la datasource et vérifie la connexion réseau
/// Transforme les Exceptions en Failures pour la couche domaine
class RulerRepositoryImpl implements RulerRepository {
  final RulerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RulerRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CalculationResult>> calculateSimple({
    required Fluid fluid,
    double? temperature,
    double? pressure,
  }) async {
    return await _executeCalculation(() async {
      if (temperature != null) {
        // Mode T -> P
        return await remoteDataSource.calculate(
          fluidRefName: fluid.refName,
          car1: 'T',
          val1: temperature,
          car2: 'Q',
          val2: 1.0,
          carNeed: 'P',
        );
      } else if (pressure != null) {
        // Mode P -> T
        return await remoteDataSource.calculate(
          fluidRefName: fluid.refName,
          car1: 'P',
          val1: pressure,
          car2: 'Q',
          val2: 1.0,
          carNeed: 'T',
        );
      } else {
        throw ArgumentError('Either temperature or pressure must be provided');
      }
    });
  }

  @override
  Future<Either<Failure, CalculationResult>> calculateAdvanced({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    return await _executeCalculation(() async {
      return await remoteDataSource.calculate(
        fluidRefName: fluid.refName,
        car1: car1,
        val1: val1,
        car2: car2,
        val2: val2,
        carNeed: carNeed,
      );
    });
  }

  /// Méthode utilitaire pour exécuter un calcul avec gestion des erreurs
  ///
  /// Vérifie la connexion réseau avant d'exécuter
  /// Transforme les exceptions en Failures appropriés
  Future<Either<Failure, CalculationResult>> _executeCalculation(
    Future<CalculationResult> Function() calculation,
  ) async {
    // Vérification de la connexion réseau
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await calculation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Erreur réseau'));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message ?? 'Erreur de parsing'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
}
