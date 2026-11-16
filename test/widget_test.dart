import 'package:flutter_test/flutter_test.dart';
import 'package:aula14_gps/main.dart';

void main() {
  testWidgets('Verifica renderização inicial da tela de Geolocalizacao', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());

    // Verifica título da AppBar
    expect(find.text('Check-in & GPS'), findsOneWidget);

    // Verifica botões de captura e rastreamento
    expect(find.text('Capturar Localização Atual'), findsOneWidget);
    expect(find.text('Iniciar Rastreamento Contínuo'), findsOneWidget);
  });
}
