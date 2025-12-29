import 'package:app_froid/features/fluid_custom/domain/entities/fluid_custom.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FluidCustom', () {
    const tFluidCustom = FluidCustom(
      label: 'Test Mix',
      fluids: ['R32', 'R125'],
      fluidsRef: ['R32', 'R125'],
      quantities: [0.5, 0.5],
    );

    test('should be a subclass of Equatable', () {
      expect(tFluidCustom, isA<Object>());
    });

    group('isValidTotal', () {
      test('should return true when total equals 1.0', () {
        expect(tFluidCustom.isValidTotal, true);
      });

      test('should return true when total is within tolerance', () {
        const fluid = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125', 'R134a'],
          fluidsRef: ['R32', 'R125', 'R134a'],
          quantities: [0.333, 0.333, 0.334],
        );
        expect(fluid.isValidTotal, true);
      });

      test('should return false when total does not equal 1.0', () {
        const fluid = FluidCustom(
          label: 'Invalid Mix',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.4, 0.4],
        );
        expect(fluid.isValidTotal, false);
      });
    });

    group('totalDecimal', () {
      test('should return correct total', () {
        expect(tFluidCustom.totalDecimal, 1.0);
      });

      test('should return correct total for invalid quantities', () {
        const fluid = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.3, 0.4],
        );
        expect(fluid.totalDecimal, 0.7);
      });
    });

    group('hasAllFluidsSelected', () {
      test('should return true when all fluids are selected', () {
        expect(tFluidCustom.hasAllFluidsSelected, true);
      });

      test('should return false when some fluids are empty', () {
        const fluid = FluidCustom(
          label: 'Test',
          fluids: ['R32', ''],
          fluidsRef: ['R32', ''],
          quantities: [0.5, 0.5],
        );
        expect(fluid.hasAllFluidsSelected, false);
      });

      test('should return false when fluids contain only whitespace', () {
        const fluid = FluidCustom(
          label: 'Test',
          fluids: ['R32', '  '],
          fluidsRef: ['R32', '  '],
          quantities: [0.5, 0.5],
        );
        expect(fluid.hasAllFluidsSelected, false);
      });
    });

    group('copyWith', () {
      test('should copy with new label', () {
        final copy = tFluidCustom.copyWith(label: 'New Label');
        expect(copy.label, 'New Label');
        expect(copy.fluids, tFluidCustom.fluids);
        expect(copy.fluidsRef, tFluidCustom.fluidsRef);
        expect(copy.quantities, tFluidCustom.quantities);
      });

      test('should copy with new fluids', () {
        final copy = tFluidCustom.copyWith(
          fluids: ['R410A', 'R134a'],
        );
        expect(copy.fluids, ['R410A', 'R134a']);
        expect(copy.label, tFluidCustom.label);
      });

      test('should copy with new quantities', () {
        final copy = tFluidCustom.copyWith(
          quantities: [0.6, 0.4],
        );
        expect(copy.quantities, [0.6, 0.4]);
        expect(copy.label, tFluidCustom.label);
      });
    });

    group('empty factory', () {
      test('should create empty FluidCustom with two empty fluids', () {
        final empty = FluidCustom.empty();
        expect(empty.label, '');
        expect(empty.fluids, ['', '']);
        expect(empty.fluidsRef, ['', '']);
        expect(empty.quantities, [0.0, 0.0]);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        const fluid1 = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.5, 0.5],
        );
        const fluid2 = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.5, 0.5],
        );
        expect(fluid1, fluid2);
      });

      test('should not be equal when label is different', () {
        const fluid1 = FluidCustom(
          label: 'Test1',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.5, 0.5],
        );
        const fluid2 = FluidCustom(
          label: 'Test2',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.5, 0.5],
        );
        expect(fluid1, isNot(fluid2));
      });

      test('should not be equal when quantities are different', () {
        const fluid1 = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.5, 0.5],
        );
        const fluid2 = FluidCustom(
          label: 'Test',
          fluids: ['R32', 'R125'],
          fluidsRef: ['R32', 'R125'],
          quantities: [0.6, 0.4],
        );
        expect(fluid1, isNot(fluid2));
      });
    });
  });
}
