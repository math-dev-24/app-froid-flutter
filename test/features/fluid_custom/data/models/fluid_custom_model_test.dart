import 'dart:convert';
import 'package:app_froid/features/fluid_custom/data/models/fluid_custom_model.dart';
import 'package:app_froid/features/fluid_custom/domain/entities/fluid_custom.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FluidCustomModel', () {
    const tFluidCustomModel = FluidCustomModel(
      label: 'R410A Custom',
      fluids: ['R32', 'R125'],
      fluidsRef: ['R32', 'R125'],
      quantities: [0.5, 0.5],
    );

    test('should be a subclass of FluidCustom entity', () {
      expect(tFluidCustomModel, isA<FluidCustom>());
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        const entity = FluidCustom(
          label: 'Test Mix',
          fluids: ['R32', 'R134a'],
          fluidsRef: ['R32', 'R134a'],
          quantities: [0.6, 0.4],
        );

        final model = FluidCustomModel.fromEntity(entity);

        expect(model.label, entity.label);
        expect(model.fluids, entity.fluids);
        expect(model.fluidsRef, entity.fluidsRef);
        expect(model.quantities, entity.quantities);
      });
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final Map<String, dynamic> jsonMap = {
          'label': 'R410A Custom',
          'fluids': ['R32', 'R125'],
          'fluidsRef': ['R32', 'R125'],
          'quantities': [0.5, 0.5],
        };

        final result = FluidCustomModel.fromJson(jsonMap);

        expect(result, tFluidCustomModel);
      });

      test('should handle integer quantities', () {
        final Map<String, dynamic> jsonMap = {
          'label': 'Test',
          'fluids': ['R32', 'R125'],
          'fluidsRef': ['R32', 'R125'],
          'quantities': [1, 0], // integers instead of doubles
        };

        final result = FluidCustomModel.fromJson(jsonMap);

        expect(result.quantities, [1.0, 0.0]);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tFluidCustomModel.toJson();

        final expectedMap = {
          'label': 'R410A Custom',
          'fluids': ['R32', 'R125'],
          'fluidsRef': ['R32', 'R125'],
          'quantities': [0.5, 0.5],
        };

        expect(result, expectedMap);
      });
    });

    group('listFromJson', () {
      test('should parse JSON string to list of models', () {
        const jsonString = '''
        [
          {
            "label": "Mix 1",
            "fluids": ["R32", "R125"],
            "fluidsRef": ["R32", "R125"],
            "quantities": [0.5, 0.5]
          },
          {
            "label": "Mix 2",
            "fluids": ["R134a", "R1234yf"],
            "fluidsRef": ["R134a", "R1234YF"],
            "quantities": [0.7, 0.3]
          }
        ]
        ''';

        final result = FluidCustomModel.listFromJson(jsonString);

        expect(result, isA<List<FluidCustomModel>>());
        expect(result.length, 2);
        expect(result[0].label, 'Mix 1');
        expect(result[1].label, 'Mix 2');
      });

      test('should return empty list for empty JSON array', () {
        const jsonString = '[]';

        final result = FluidCustomModel.listFromJson(jsonString);

        expect(result, isEmpty);
      });
    });

    group('listToJson', () {
      test('should convert list of models to JSON string', () {
        final models = [
          const FluidCustomModel(
            label: 'Mix 1',
            fluids: ['R32', 'R125'],
            fluidsRef: ['R32', 'R125'],
            quantities: [0.5, 0.5],
          ),
          const FluidCustomModel(
            label: 'Mix 2',
            fluids: ['R134a', 'R1234yf'],
            fluidsRef: ['R134a', 'R1234YF'],
            quantities: [0.7, 0.3],
          ),
        ];

        final result = FluidCustomModel.listToJson(models);
        final decoded = json.decode(result) as List;

        expect(decoded.length, 2);
        expect(decoded[0]['label'], 'Mix 1');
        expect(decoded[1]['label'], 'Mix 2');
      });

      test('should return empty JSON array for empty list', () {
        final result = FluidCustomModel.listToJson([]);

        expect(result, '[]');
      });
    });

    group('JSON round trip', () {
      test('should maintain data integrity after toJson/fromJson', () {
        final json = tFluidCustomModel.toJson();
        final decoded = FluidCustomModel.fromJson(json);

        expect(decoded, tFluidCustomModel);
      });

      test('should maintain data integrity for list serialization', () {
        final models = [
          tFluidCustomModel,
          const FluidCustomModel(
            label: 'Another Mix',
            fluids: ['R32', 'R134a', 'R125'],
            fluidsRef: ['R32', 'R134a', 'R125'],
            quantities: [0.33, 0.33, 0.34],
          ),
        ];

        final jsonString = FluidCustomModel.listToJson(models);
        final decoded = FluidCustomModel.listFromJson(jsonString);

        expect(decoded, models);
      });
    });
  });
}
