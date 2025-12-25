import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.dart';

/// Implémentation de NetworkInfo utilisant connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // Retourne true si connecté via WiFi, mobile ou ethernet
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);
  }
}
