import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/calculation_result_model.dart';
import 'ruler_remote_datasource.dart';

/// Implémentation concrète de RulerRemoteDataSource
///
/// Communique avec l'API REST pour effectuer les calculs thermodynamiques
class RulerRemoteDataSourceImpl implements RulerRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RulerRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<CalculationResultModel> calculate({
    required String fluidRefName,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/ruler');
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fluid': fluidRefName,
          'car_1': car1,
          'val_1': val1,
          'car_2': car2,
          'val_2': val2,
          'car_need': carNeed,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
          return CalculationResultModel.fromJson(jsonResponse);
        } catch (e) {
          throw ParsingException('Erreur lors du parsing de la réponse: $e');
        }
      } else if (response.statusCode == 422) {
        // Erreur de validation côté serveur
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = jsonResponse['error'] ?? 'Erreur de validation';
        throw ServerException(errorMessage);
      } else {
        throw ServerException('Erreur serveur (${response.statusCode})');
      }
    } on SocketException {
      throw NetworkException('Pas de connexion Internet');
    } on FormatException catch (e) {
      throw ParsingException('Réponse invalide du serveur: $e');
    } on http.ClientException catch (e) {
      throw NetworkException('Erreur de connexion au serveur: $e');
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur inattendue: ${e.toString()}');
    }
  }
}
