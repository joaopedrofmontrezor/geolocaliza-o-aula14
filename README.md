# Aula 14 - Recursos do Dispositivo: Geolocalização e GPS

**Disciplina:** Programação para Dispositivos Móveis I  
**Professor:** Diego Menegassi  
**Tópico:** Aula 14 — Sensores do Celular, Permissões e Coordenadas

---

## 📌 Sobre o Projeto

Aplicativo Flutter desenvolvido como atividade prática da **Aula 14**, com foco no acesso a recursos de hardware do dispositivo móvel (módulo de GPS e sensores de localização) através do pacote oficial `geolocator`.

### 🚀 Funcionalidades Principais:
1. **Configuração de Permissões Nativas**:
   - `ACCESS_FINE_LOCATION` e `ACCESS_COARSE_LOCATION` no `AndroidManifest.xml` (Android).
   - Configurações de `NSLocationWhenInUseUsageDescription` e `NSLocationAlwaysUsageDescription` no `Info.plist` (iOS).
   - Configuração de esquema `https` e `geo` nas `<queries>` do Android para compatibilidade com o `url_launcher`.
2. **Camada de Serviço (`LocationService`)**:
   - Isolamento de regras de negócio em `lib/services/location_service.dart`.
   - Verificação defensiva de serviço de GPS ligado (`Geolocator.isLocationServiceEnabled()`).
   - Ciclo completo de checagem e solicitação de permissão (`checkPermission` e `requestPermission`).
   - Tratamento específico para permissões negadas permanentemente (`LocationPermission.deniedForever`).
   - Captura de coordenadas únicas (`getCurrentPosition`).
   - Monitoramento contínuo da posição através de Stream (`getPositionStream`) com filtro de distância.
3. **Interface Gráfica (`GeolocalizacaoScreen`)**:
   - Visualização de Latitude, Longitude, Altitude e Precisão.
   - Indicador de carregamento (`CircularProgressIndicator`) durante a aquisição do sinal.
   - Tratamento visual de erros em `Card` vermelho.
   - Botão para captura única de coordenadas.
   - Botão para iniciar e parar rastreamento contínuo em tempo real.
4. **Desafios Práticos de Laboratório Implementados**:
   - 🟢 **Básico - Medidor de Precisão**: Indicador visual dinâmico com `Chip` colorido:
     - **Verde**: Precisão < 15m (alta precisão).
     - **Amarelo**: Precisão entre 15m e 50m (precisão intermediária).
     - **Vermelho**: Precisão > 50m (baixa precisão).
   - 🟣 **Intermediário - Cálculo de Distância**: Cálculo da distância geodésica em metros/quilômetros até a **Fatec Matão — Luiz Marchesan** (`-21.6148, -48.3596`) utilizando `Geolocator.distanceBetween()`.
   - 🗺️ **Avançado - Abrir no Google Maps**: Botão *"Abrir no Mapa"* integrado ao pacote `url_launcher` para navegação externa em `https://maps.google.com/?q=lat,lng`.

---

## 🛠️ Como Executar o Projeto

```bash
# Obter dependências
flutter pub get

# Executar testes unitários e de interface
flutter test

# Executar no dispositivo ou emulador
flutter run
```

---

## 📦 Versionamento Git (Roteiro da Aula)

Conforme as instruções da rubrica, execute os comandos abaixo no terminal da pasta do projeto quando desejar enviar seus commits:

```bash
# 1. Adicionar permissões e serviço
git add android/app/src/main/AndroidManifest.xml pubspec.yaml lib/services/
git commit -m "feat: configura permissoes de GPS e servico LocationService"

# 2. Adicionar telas e ponto de entrada
git add lib/screens/ lib/main.dart
git commit -m "feat: constroi interface de check-in com coordenadas e rastreamento em tempo real"

# 3. Adicionar testes e documentação dos desafios
git add test/ README.md
git commit -m "feat: implementa desafios de medidor de precisao, distancia Fatec e mapa"

# 4. Vincular repositório remoto e enviar para a main
git branch -M main
git remote add origin URL_DO_SEU_REPOSITORIO
git push -u origin main
```
