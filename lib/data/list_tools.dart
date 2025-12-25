import 'package:flutter/material.dart';
import 'models/tool.dart';

/// Liste statique des outils disponibles dans l'application
class ListTools {
  static const List<Tool> tools = [
    Tool(
      name: 'Règlette',
      description: 'Calcul rapide des propriétés thermodynamiques',
      icon: Icons.straighten,
      route: '/ruler',
    ),
    Tool(
      name: 'Règlette avancée',
      description: 'Calculs avancés avec filtres multiples',
      icon: Icons.tune,
      route: '/ruler-advanced',
    ),
    Tool(
      name: 'Signal capteur',
      description: 'Convertisseur de signaux 4-20mA, 0-10V',
      icon: Icons.electric_bolt,
      route: '/sensor-convert',
    ),
    Tool(
      name: 'Convertisseur',
      description: 'Conversion d\'unités de pression et température',
      icon: Icons.sync_alt,
      route: '/converter',
    ),
    Tool(
      name: 'Diamètre équivalent',
      description: 'Calcul du diamètre circulaire équivalent',
      icon: Icons.change_circle,
      route: '/equivalent-diameter',
    ),
    Tool(
      name: 'Interpolation linéaire',
      description: 'Estimation de valeurs entre deux points',
      icon: Icons.show_chart,
      route: '/interpolation',
    ),
  ];
}
