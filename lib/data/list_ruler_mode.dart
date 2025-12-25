import 'models/option_ruler.dart';

/// Liste statique des options de calcul pour la règlette
class ListOptionsRuler {
  static const List<OptionRuler> options = [
    OptionRuler(
      label: "Pression",
      value: "P",
      canSearch: true
    ),
    OptionRuler(
      label: "Température",
      value: "T",
      canSearch: true
    ),
    OptionRuler(
      label: "Enthalpie",
      value: "H",
      canSearch: true
    ),
    OptionRuler(
      label: "Q",
      value: "Q",
      canSearch: false
      )
  ];

  static List<OptionRuler> getOptionAvalaible(OptionRuler need) {
    return options.where((o) => o != need).toList();
  }

  static bool existOption(OptionRuler value) {
    return options.any((o) => o == value);
  }
}
