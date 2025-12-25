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
    Tool(
      name: 'DESP',
      description: 'Directive Équipements Sous Pression 2014/68/UE',
      icon: Icons.gavel,
      route: '/desp',
    ),
    Tool(
      name: 'Test d\'Azote',
      description: 'Calcul de l\'influence de la température',
      icon: Icons.science,
      route: '/nitrogen-test',
    ),
    Tool(
      name: 'Pression Moyenne',
      description: 'Calcul pour systèmes bi-étagés',
      icon: Icons.compress,
      route: '/intermediate-pressure',
    ),
    Tool(
      name: 'Calcul de Charge',
      description: 'Dimensionnement charge frigorifique',
      icon: Icons.calculate_outlined,
      route: '/refrigerant-charge',
    ),
    Tool(
      name: 'Volume Mini LFL',
      description: 'Limite Inférieure d\'Inflammabilité',
      icon: Icons.local_fire_department,
      route: '/lfl-volume',
    ),
  ];
}
