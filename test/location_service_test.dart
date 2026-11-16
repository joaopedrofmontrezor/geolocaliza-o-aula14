import 'package:flutter_test/flutter_test.dart';
import 'package:aula14_gps/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    final locationService = LocationService();

    test('Valida coordenadas estáticas da Fatec Matão', () {
      expect(LocationService.fatecMataoLatitude, closeTo(-21.6148, 0.001));
      expect(LocationService.fatecMataoLongitude, closeTo(-48.3596, 0.001));
    });

    test('Cálculo de distância até a própria Fatec Matão deve ser aproximadamente 0 metros', () {
      final distancia = locationService.calcularDistanciaAteFatec(
        LocationService.fatecMataoLatitude,
        LocationService.fatecMataoLongitude,
      );

      expect(distancia, closeTo(0.0, 1.0));
    });

    test('Cálculo de distância entre pontos conhecidos', () {
      // Ponto deslocado aproximadamente 1 km
      final distancia = locationService.calcularDistanciaAteFatec(
        -21.6238,
        -48.3596,
      );

      expect(distancia, greaterThan(500.0));
    });
  });
}
