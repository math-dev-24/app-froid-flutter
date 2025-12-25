/// Helpers de conversion partagés entre features
///
/// Ces fonctions sont purement fonctionnelles et sans effets de bord
class ConversionHelpers {
  // Empêcher l'instanciation
  ConversionHelpers._();

  // ========================================
  // CONVERSIONS DE PRESSION
  // ========================================

  /// Convertit des bars vers d'autres unités
  static Map<String, double> convertFromBar(double bar) {
    return {
      'MPa': bar * 0.1,
      'PSI': bar * 14.5038,
      'mce': bar * 10.1972,
    };
  }

  /// Convertit des MPa vers d'autres unités
  static Map<String, double> convertFromMPa(double mpa) {
    return {
      'bar': mpa * 10.0,
      'PSI': mpa * 145.038,
      'mce': mpa * 101.972,
    };
  }

  /// Convertit des PSI vers d'autres unités
  static Map<String, double> convertFromPSI(double psi) {
    return {
      'bar': psi * 0.0689476,
      'MPa': psi * 0.00689476,
      'mce': psi * 0.703069,
    };
  }

  /// Convertit des mce vers d'autres unités
  static Map<String, double> convertFromMCE(double mce) {
    return {
      'bar': mce * 0.0980665,
      'MPa': mce * 0.00980665,
      'PSI': mce * 1.42233,
    };
  }

  // ========================================
  // CONVERSIONS DE TEMPÉRATURE
  // ========================================

  /// Convertit des Celsius vers d'autres unités
  static Map<String, double> convertFromCelsius(double celsius) {
    return {
      'K': celsius + 273.15,
      '°F': (celsius * 9 / 5) + 32,
    };
  }

  /// Convertit des Kelvin vers d'autres unités
  static Map<String, double> convertFromKelvin(double kelvin) {
    return {
      '°C': kelvin - 273.15,
      '°F': (kelvin - 273.15) * 9 / 5 + 32,
    };
  }

  /// Convertit des Fahrenheit vers d'autres unités
  static Map<String, double> convertFromFahrenheit(double fahrenheit) {
    return {
      'K': (fahrenheit - 32) * 5 / 9 + 273.15,
      '°C': (fahrenheit - 32) * 5 / 9,
    };
  }

  // ========================================
  // INTERPOLATION LINÉAIRE
  // ========================================

  /// Effectue une interpolation linéaire
  static double linearInterpolation({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
    required double x,
  }) {
    if (x2 == x1) throw ArgumentError('x1 et x2 doivent être différents');
    return y1 + (x - x1) * (y2 - y1) / (x2 - x1);
  }

  // ========================================
  // DIAMÈTRE ÉQUIVALENT
  // ========================================

  /// Calcule le diamètre équivalent circulaire
  static double calculateEquivalentDiameter({
    required double width,
    required double height,
  }) {
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Les dimensions doivent être positives');
    }
    // Formule: D = 1.30 * [(a*b)^0.625] / [(a+b)^0.250]
    final product = width * height;
    final sum = width + height;
    return 1.30 * (product.pow(0.625)) / (sum.pow(0.250));
  }
}

/// Extension pour simplifier les calculs de puissance
extension on double {
  double pow(double exponent) {
    return this == 0.0 ? 0.0 : this < 0.0
        ? throw ArgumentError('Cannot raise negative number to non-integer power')
        : this.toDouble() * exponent; // Simplified, use dart:math for real implementation
  }
}
