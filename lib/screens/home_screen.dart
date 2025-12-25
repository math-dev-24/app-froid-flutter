import 'package:app_froid/widgets/app_drawer.dart';
import 'package:app_froid/services/service_locator.dart';
import 'package:app_froid/services/counter_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key, required this.title});

    final String title;


    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Injection du service via get_it
  final CounterService _counterService = getIt<CounterService>();

  // La valeur affichée à l'écran (synchronisée avec le service)
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Charge la valeur depuis le service au démarrage
    _loadCounter();
  }

  /// Charge le compteur depuis le service
  Future<void> _loadCounter() async {
    final value = _counterService.getCounter();
    setState(() {
      _counter = value;
    });
  }

  /// Incrémente le compteur via le service
  Future<void> _inc() async {
    int newValue = await _counterService.increment();
    setState(() {
      _counter = newValue;
    });
  }

  /// Décrémente le compteur via le service
  Future<void> _dev() async {
    int newValue = await _counterService.decrement();
    setState(() {
      _counter = newValue;
    });
  }

  /// Remet le compteur à zéro via le service
  Future<void> _reset() async {
    await _counterService.reset();
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Compteur',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _dev,
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _inc,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Bouton Reset
            ElevatedButton.icon(
              onPressed: _reset,
              icon: Icon(Icons.refresh),
              label: Text('Réinitialiser'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

}