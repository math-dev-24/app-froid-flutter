import 'package:flutter/material.dart';

/// Modèle représentant un outil disponible dans l'application
class Tool {
  final String name;
  final String description;
  final IconData icon;
  final String route;

  const Tool({
    required this.name,
    required this.description,
    required this.icon,
    required this.route,
  });
}
