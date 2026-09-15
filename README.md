# Patrimônios SENAI

Aplicativo Flutter com GetX para listar, pesquisar, visualizar, cadastrar, editar e excluir patrimônios pela API REST.

## Como executar

1. Instale o Flutter e confira o ambiente:

```bash
flutter doctor
```

2. Na pasta do projeto, gere as pastas nativas do Flutter (necessário apenas na primeira vez neste workspace):

```bash
flutter create .
```

3. Na pasta do projeto, instale as dependências:

```bash
flutter pub get
```

4. Inicie a API em `http://localhost:8080` e confirme que a documentação abre em `http://localhost:8080/docs`.

5. Execute o aplicativo:

```bash
flutter run
```

Para abrir no navegador:

```bash
flutter run -d chrome
```

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

## Endereço da API

O endereço padrão está em `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://localhost:8080';
```

- Chrome, Windows e iOS Simulator: normalmente `localhost` funciona.
- Android Emulator: use `http://10.0.2.2:8080`.
- Celular físico: use o IP da máquina na rede, por exemplo `http://192.168.0.10:8080`, e deixe a API acessível na rede.

## Prints para a entrega

Com a API ligada, execute `flutter run` e faça prints destas telas:

1. Lista inicial de patrimônios.
2. Resultado de uma pesquisa.
3. Tela de detalhes ao tocar em um item.
4. Formulário preenchido e patrimônio cadastrado.
5. Formulário de edição com os dados alterados.
6. Confirmação de exclusão e lista após a exclusão.

## Comandos úteis

```bash
flutter analyze
flutter test
flutter clean
flutter pub get
```

## Estrutura

- `lib/models`: modelo dos dados.
- `lib/services`: comunicação HTTP com a API.
- `lib/controllers`: estado e regras com GetX.
- `lib/views`: telas do aplicativo.
