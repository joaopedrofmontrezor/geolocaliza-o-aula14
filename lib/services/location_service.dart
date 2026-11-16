import 'package:geolocator/geolocator.dart';

class LocationService {
  // Coordenadas da Fatec Matão - Luiz Marchesan
  static const double fatecMataoLatitude = -21.6148;
  static const double fatecMataoLongitude = -48.3596;

  Future<Position> obterPosicaoAtual() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('O serviço de GPS está desativado no dispositivo.');
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada pelo usuário.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissões negadas permanentemente. Altere nas configurações.');
    }

    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Stream<Position> monitorarPosicao() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  double calcularDistanciaAteFatec(double latitude, double longitude) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      fatecMataoLatitude,
      fatecMataoLongitude,
    );
  }
}
