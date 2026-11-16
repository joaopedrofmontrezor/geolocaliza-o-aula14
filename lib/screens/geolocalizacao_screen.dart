import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';

class GeolocalizacaoScreen extends StatefulWidget {
  const GeolocalizacaoScreen({super.key});

  @override
  State<GeolocalizacaoScreen> createState() => _GeolocalizacaoScreenState();
}

class _GeolocalizacaoScreenState extends State<GeolocalizacaoScreen> {
  final _locationService = LocationService();
  Position? _posicaoAtual;
  bool _carregando = false;
  String? _mensagemErro;
  StreamSubscription<Position>? _positionStreamSub;
  bool _rastreando = false;

  Future<void> _buscarLocalizacao() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });
    try {
      final posicao = await _locationService.obterPosicaoAtual();
      setState(() => _posicaoAtual = posicao);
    } catch (e) {
      setState(() => _mensagemErro = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _alternarRastreamento() {
    if (_rastreando) {
      _positionStreamSub?.cancel();
      setState(() => _rastreando = false);
    } else {
      setState(() => _rastreando = true);
      _positionStreamSub = _locationService.monitorarPosicao().listen(
        (pos) => setState(() => _posicaoAtual = pos),
        onError: (err) => setState(() => _mensagemErro = err.toString()),
      );
    }
  }

  // Desafio Avançado: Abrir no Google Maps usando url_launcher
  Future<void> _abrirNoMapa() async {
    if (_posicaoAtual == null) return;
    final url = Uri.parse(
      'https://maps.google.com/?q=${_posicaoAtual!.latitude},${_posicaoAtual!.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _mensagemErro = 'Não foi possível abrir o link no Google Maps.';
      });
    }
  }

  // Desafio Básico: Medidor visual de Precisão com Chips coloridos
  Widget _buildChipPrecisao(double accuracy) {
    final Color chipColor;
    final Color textColor;
    final String labelTexto;
    final IconData icone;

    if (accuracy < 15) {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      labelTexto = 'Precisão Alta (< 15m): ${accuracy.toStringAsFixed(1)}m';
      icone = Icons.check_circle;
    } else if (accuracy <= 50) {
      chipColor = Colors.amber.shade100;
      textColor = Colors.amber.shade900;
      labelTexto = 'Precisão Média (15-50m): ${accuracy.toStringAsFixed(1)}m';
      icone = Icons.warning_amber_rounded;
    } else {
      chipColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      labelTexto = 'Precisão Baixa (> 50m): ${accuracy.toStringAsFixed(1)}m';
      icone = Icons.error_outline;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Chip(
        avatar: Icon(icone, color: textColor, size: 18),
        backgroundColor: chipColor,
        side: BorderSide(color: textColor.withValues(alpha: 0.5)),
        label: Text(
          labelTexto,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Formatação de distância em metros ou quilômetros
  String _formatarDistancia(double metros) {
    if (metros >= 1000) {
      return '${(metros / 1000).toStringAsFixed(2)} km (${metros.toStringAsFixed(0)} m)';
    }
    return '${metros.toStringAsFixed(1)} m';
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Desafio Intermediário: Cálculo de distância até a Fatec Matão
    final double? distanciaFatec = _posicaoAtual != null
        ? _locationService.calcularDistanciaAteFatec(
            _posicaoAtual!.latitude,
            _posicaoAtual!.longitude,
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in & GPS'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_carregando) const CircularProgressIndicator(),
            if (_mensagemErro != null)
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(_mensagemErro!, style: const TextStyle(color: Colors.red)),
                ),
              ),
            if (_posicaoAtual != null) ...[
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.my_location, color: Colors.blue),
                      title: const Text('Latitude'),
                      subtitle: Text('${_posicaoAtual!.latitude}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.green),
                      title: const Text('Longitude'),
                      subtitle: Text('${_posicaoAtual!.longitude}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.speed, color: Colors.orange),
                      title: const Text('Precisão / Altitude'),
                      subtitle: Text(
                        'Precisão: ${_posicaoAtual!.accuracy.toStringAsFixed(1)}m | Alt: ${_posicaoAtual!.altitude.toStringAsFixed(1)}m',
                      ),
                    ),
                    // Desafio Básico: Medidor de Precisão
                    _buildChipPrecisao(_posicaoAtual!.accuracy),
                    // Desafio Intermediário: Distância até a Fatec Matão
                    if (distanciaFatec != null)
                      ListTile(
                        leading: const Icon(Icons.school, color: Colors.deepPurple),
                        title: const Text('Distância até a Fatec Matão'),
                        subtitle: Text(_formatarDistancia(distanciaFatec)),
                      ),
                    // Desafio Avançado: Botão para abrir no Google Maps
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: _abrirNoMapa,
                        icon: const Icon(Icons.map),
                        label: const Text('Abrir no Mapa'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _carregando ? null : _buscarLocalizacao,
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Capturar Localização Atual'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _alternarRastreamento,
              icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
              label: Text(_rastreando ? 'Parar Rastreamento' : 'Iniciar Rastreamento Contínuo'),
            ),
          ],
        ),
      ),
    );
  }
}
