class Signal {
  final double min;
  final double max;
  final double delta;
  final String unit;

  const Signal({
    required this.min,
    required this.max,
    required this.delta,
    required this.unit,
  });
}

enum SearchType {
  signal,
  value,
}
