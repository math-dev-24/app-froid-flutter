import 'package:equatable/equatable.dart';

enum Application {
  confort,
  refrigeration,
}

enum AccessConfort {
  general,
  surveille,
  reserveD1,
}

enum AccessRefrigeration {
  general,
  surveille,
  reserveD1,
  reserveD2,
}

enum Classification {
  un,
  deux,
  trois,
  quatre,
}

class ChargeParameters extends Equatable {
  final String fluidId;
  final double lfl;
  final Application application;
  final dynamic access;
  final Classification classification;
  final double? volume;

  const ChargeParameters({
    required this.fluidId,
    required this.lfl,
    required this.application,
    required this.access,
    required this.classification,
    this.volume,
  });

  @override
  List<Object?> get props => [
        fluidId,
        lfl,
        application,
        access,
        classification,
        volume,
      ];
}
