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

Se o Android Emulator estiver aberto, execute:

```bash
flutter run -d emulator-5554
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

## Requisitos da atividade

O aplicativo deve manter este fluxo em todas as operações:

```text
View -> Controller (GetX) -> Service -> API REST
```

Endpoints obrigatórios:

| Função | Método | Endpoint |
|---|---|---|
| Listar patrimônios | GET | `/api/v1/patrimonios` |
| Pesquisar | GET | `/api/v1/patrimonios?q=termo` |
| Ver detalhes | GET | `/api/v1/patrimonios/{id}` |
| Cadastrar | POST | `/api/v1/patrimonios` |
| Editar | PUT | `/api/v1/patrimonios/{id}` |
| Excluir | DELETE | `/api/v1/patrimonios/{id}` |

Os campos do patrimônio são: número do inventário, descrição, local e responsável.

### Regra obrigatória para detalhes

Ao tocar em um item da lista, a tela de detalhes deve buscar os dados atualizados usando o endpoint `GET /api/v1/patrimonios/{id}`. Ela não pode exibir somente o objeto recebido da listagem.

O código deve seguir este fluxo:

```text
DetalheView
	-> PatrimonioController.buscar(id)
	-> ApiService.buscarPorId(id)
	-> GET /api/v1/patrimonios/{id}
```

Enquanto a requisição estiver em andamento, exiba um carregamento. Se ela falhar, exiba uma mensagem de erro e uma opção para tentar novamente.

## Checklist para o agente do VS Code

Ao abrir este projeto em outra máquina, peça ao agente para ler este README e executar a seguinte verificação:

```text
Implemente e valide todos os requisitos deste README.
Use Flutter, Dart, GetX, JSON e API REST nas camadas models, services, controllers e views.
Confira especialmente se a tela de detalhes chama GET /api/v1/patrimonios/{id} pelo Controller e pelo Service.
Não considere a tarefa concluída se algum endpoint ou funcionalidade estiver faltando.
Execute flutter pub get, flutter analyze e flutter test.
Corrija todos os erros encontrados e informe quais comandos foram executados.
```

Antes de entregar, confirme manualmente que funcionam: listagem, pesquisa, detalhes, cadastro, edição e exclusão com confirmação.

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
