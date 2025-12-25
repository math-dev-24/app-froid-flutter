import 'package:equatable/equatable.dart';

import '../../domain/entities/interpolation_result.dart';

abstract class InterpolationState extends Equatable {
  const InterpolationState();
  @override
  List<Object> get props => [];
}

class InterpolationInitial extends InterpolationState {
  const InterpolationInitial();
}

class InterpolationLoaded extends InterpolationState {
  final InterpolationResult result;

  const InterpolationLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

class InterpolationError extends InterpolationState {
  final String message;

  const InterpolationError({required this.message});

  @override
  List<Object> get props => [message];
}
