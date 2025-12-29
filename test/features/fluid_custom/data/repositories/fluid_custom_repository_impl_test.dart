import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/fluid_custom/data/datasources/fluid_custom_local_datasource.dart';
import 'package:app_froid/features/fluid_custom/data/models/fluid_custom_model.dart';
import 'package:app_froid/features/fluid_custom/data/repositories/fluid_custom_repository_impl.dart';
import 'package:app_froid/features/fluid_custom/domain/entities/fluid_custom.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fluid_custom_repository_impl_test.mocks.dart';

@GenerateMocks([FluidCustomLocalDataSource])
void main() {
  late FluidCustomRepositoryImpl repository;
  late MockFluidCustomLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockFluidCustomLocalDataSource();
    repository = FluidCustomRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tFluidCustomModel = FluidCustomModel(
    label: 'Test Mix',
    fluids: ['R32', 'R125'],
    fluidsRef: ['R32', 'R125'],
    quantities: [0.5, 0.5],
  );

  const tFluidCustom = FluidCustom(
    label: 'Test Mix',
    fluids: ['R32', 'R125'],
    fluidsRef: ['R32', 'R125'],
    quantities: [0.5, 0.5],
  );

  group('getFluidCustoms', () {
    test('should return list of FluidCustom when datasource succeeds', () async {
      when(mockLocalDataSource.getFluidCustoms())
          .thenAnswer((_) async => [tFluidCustomModel]);

      final result = await repository.getFluidCustoms();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (fluids) {
          expect(fluids.length, 1);
          expect(fluids.first, tFluidCustomModel);
        },
      );
      verify(mockLocalDataSource.getFluidCustoms());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when datasource throws exception', () async {
      when(mockLocalDataSource.getFluidCustoms())
          .thenThrow(Exception('Cache error'));

      final result = await repository.getFluidCustoms();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (fluids) => fail('Should return Left'),
      );
      verify(mockLocalDataSource.getFluidCustoms());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return empty list when datasource returns empty', () async {
      when(mockLocalDataSource.getFluidCustoms())
          .thenAnswer((_) async => []);

      final result = await repository.getFluidCustoms();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (fluids) => expect(fluids, isEmpty),
      );
    });
  });

  group('saveFluidCustoms', () {
    final tFluidsList = [tFluidCustom];
    final tModelsList = [tFluidCustomModel];

    test('should save fluids when datasource succeeds', () async {
      when(mockLocalDataSource.saveFluidCustoms(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.saveFluidCustoms(tFluidsList);

      expect(result.isRight(), true);
      verify(mockLocalDataSource.saveFluidCustoms(tModelsList));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when datasource throws exception', () async {
      when(mockLocalDataSource.saveFluidCustoms(any))
          .thenThrow(Exception('Save error'));

      final result = await repository.saveFluidCustoms(tFluidsList);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return Left'),
      );
      verify(mockLocalDataSource.saveFluidCustoms(tModelsList));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('addFluidCustom', () {
    test('should add fluid when datasource succeeds', () async {
      when(mockLocalDataSource.addFluidCustom(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.addFluidCustom(tFluidCustom);

      expect(result.isRight(), true);
      verify(mockLocalDataSource.addFluidCustom(tFluidCustomModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when datasource throws exception', () async {
      when(mockLocalDataSource.addFluidCustom(any))
          .thenThrow(Exception('Add error'));

      final result = await repository.addFluidCustom(tFluidCustom);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return Left'),
      );
      verify(mockLocalDataSource.addFluidCustom(tFluidCustomModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('updateFluidCustom', () {
    const tIndex = 0;

    test('should update fluid at index when datasource succeeds', () async {
      when(mockLocalDataSource.updateFluidCustom(any, any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.updateFluidCustom(tIndex, tFluidCustom);

      expect(result.isRight(), true);
      verify(mockLocalDataSource.updateFluidCustom(tIndex, tFluidCustomModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when datasource throws exception', () async {
      when(mockLocalDataSource.updateFluidCustom(any, any))
          .thenThrow(Exception('Update error'));

      final result = await repository.updateFluidCustom(tIndex, tFluidCustom);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return Left'),
      );
      verify(mockLocalDataSource.updateFluidCustom(tIndex, tFluidCustomModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('removeFluidCustom', () {
    const tIndex = 0;

    test('should remove fluid at index when datasource succeeds', () async {
      when(mockLocalDataSource.removeFluidCustom(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.removeFluidCustom(tIndex);

      expect(result.isRight(), true);
      verify(mockLocalDataSource.removeFluidCustom(tIndex));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when datasource throws exception', () async {
      when(mockLocalDataSource.removeFluidCustom(any))
          .thenThrow(Exception('Remove error'));

      final result = await repository.removeFluidCustom(tIndex);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return Left'),
      );
      verify(mockLocalDataSource.removeFluidCustom(tIndex));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}
