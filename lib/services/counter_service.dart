import 'package:shared_preferences/shared_preferences.dart';


class CounterService {
  static const String _counterKey = 'counter';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// S'assure que le service est initialisé (auto-init pour hot reload)
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  int getCounter() {
    if (_prefs == null) {
      throw Exception('CounterService non initialisé. Appelez init() d\'abord.');
    }
    return _prefs!.getInt(_counterKey) ?? 0;
  }

  /// Sauvegarde une nouvelle valeur du compteur
  Future<void> setCounter(int value) async {
    if (_prefs == null) {
      throw Exception('CounterService non initialisé. Appelez init() d\'abord.');
    }
    await _prefs!.setInt(_counterKey, value);
  }

  /// Incrémente le compteur de 1
  Future<int> increment() async {
    await _ensureInitialized();
    int currentValue = _prefs!.getInt(_counterKey) ?? 0;
    int newValue = currentValue + 1;
    await _prefs!.setInt(_counterKey, newValue);
    return newValue;
  }

  /// Décrémente le compteur de 1
  Future<int> decrement() async {
    await _ensureInitialized();
    int currentValue = _prefs!.getInt(_counterKey) ?? 0;
    int newValue = currentValue - 1;
    await _prefs!.setInt(_counterKey, newValue);
    return newValue;
  }

  /// Remet le compteur à zéro
  Future<void> reset() async {
    await _ensureInitialized();
    await _prefs!.setInt(_counterKey, 0);
  }

  /// Efface toutes les données sauvegardées
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }
}
