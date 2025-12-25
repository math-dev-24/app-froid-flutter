import 'package:flutter/material.dart';

class ParameterScreen extends StatelessWidget {
  const ParameterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          // En-tête de section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Général',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('À propos'),
                  content: const Text(
                    'App Froid - Application de compteur\n'
                    'Version 1.0.0\n\n'
                    'Développé avec Flutter',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Réinitialiser les compteurs'),
            subtitle: const Text('Remettre tous les compteurs à zéro'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction à venir !'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
