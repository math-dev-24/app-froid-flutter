import 'package:equatable/equatable.dart';

import '../../domain/entities/diameter_result.dart';

abstract class EquivalentDiameterState extends Equatable {
  const EquivalentDiameterState();
  @override
  List<Object> get props => [];
}

class EquivalentDiameterInitial extends EquivalentDiameterState {
  const EquivalentDiameterInitial();
}

class EquivalentDiameterLoaded extends EquivalentDiameterState {
  final DiameterResult result;

  const EquivalentDiameterLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

class EquivalentDiameterError extends EquivalentDiameterState {
  final String message;

  const EquivalentDiameterError({required this.message});

  @override
  List<Object> get props => [message];
}
