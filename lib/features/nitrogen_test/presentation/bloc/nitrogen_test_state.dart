import 'package:equatable/equatable.dart';

import '../../domain/entities/test_result.dart';

abstract class NitrogenTestState extends Equatable {
  const NitrogenTestState();
  @override
  List<Object> get props => [];
}

class NitrogenTestInitial extends NitrogenTestState {
  const NitrogenTestInitial();
}

class NitrogenTestLoaded extends NitrogenTestState {
  final TestResult result;

  const NitrogenTestLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

class NitrogenTestError extends NitrogenTestState {
  final String message;

  const NitrogenTestError({required this.message});

  @override
  List<Object> get props => [message];
}
