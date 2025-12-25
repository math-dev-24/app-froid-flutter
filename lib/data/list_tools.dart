import 'package:flutter/material.dart';
import 'models/tool.dart';

/// Liste statique des outils disponibles dans l'application
class ListTools {
  static const List<Tool> tools = [
    Tool(
      name: 'Règlette',
      description: '',
      icon: Icons.straighten,
      route: '/ruler',
    ),
    Tool(
      name: 'Règlette avancé',
      description: "",
      icon: Icons.ac_unit,
      route: '/ruler-advanced'
      )
  ];
}
