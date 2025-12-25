import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';

class ApiService {

  final String baseUrl = "https://api-ovh.mathieu-busse.dev/v1";


  Future<Map<String, dynamic>> ruler({
    required String fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/ruler');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fluid': fluid,
          'car_1': car1,
          'val_1': val1,
          'car_2': car2,
          'val_2': val2,
          'car_need': carNeed,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      if (response.statusCode == 422) {
        return json.decode(response.body);
      }

      return _buildErrorResponse('Erreur serveur (${response.statusCode})');

    } on SocketException {
      return _buildErrorResponse('Pas de connexion Internet');
    } on FormatException {
      return _buildErrorResponse('Réponse invalide du serveur');
    } on http.ClientException {
      return _buildErrorResponse('Erreur de connexion au serveur');
    } catch (e) {
      return _buildErrorResponse('Erreur inattendue: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> sendContact({
    required String description,
  }) async {
    try {
      // Récupérer la clé API depuis les variables d'environnement
      final codaApiKey = dotenv.env['CODA_API_KEY'] ?? '';

      if (codaApiKey.isEmpty) {
        return _buildErrorResponse('Clé API Coda non configurée');
      }

      final uri = Uri.parse('https://coda.io/apis/v1/docs/zXBR5Dno9U/hooks/automation/grid-auto-aZ1e6gAqCL');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $codaApiKey',
        },
        body: json.encode({
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'ok': true,
          'message': 'Message envoyé avec succès !',
        };
      }

      return _buildErrorResponse('Erreur lors de l\'envoi du message (${response.statusCode})');

    } on SocketException {
      return _buildErrorResponse('Pas de connexion Internet');
    } on FormatException {
      return _buildErrorResponse('Réponse invalide du serveur');
    } on http.ClientException {
      return _buildErrorResponse('Erreur de connexion au serveur');
    } catch (e) {
      return _buildErrorResponse('Erreur inattendue: ${e.toString()}');
    }
  }

  Map<String, dynamic> _buildErrorResponse(String errorMessage) {
    return {
      'ok': false,
      'error': errorMessage,
    };
  }
}