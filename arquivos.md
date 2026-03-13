# Salvar arquivo de texto no celular
Salvar um arquivo de texto no celular usando Flutter envolve acessar o sistema de arquivos local do dispositivo, o que é feito comumente utilizando os pacotes path_provider (para localizar pastas como Documentos ou Downloads) e dart:io (para gravar o arquivo). 
## Passo a passo
#### 1 Configuração (pubspec.yaml)
Adicione o pacote path_provider para encontrar os diretórios corretos do sistema:
```yaml
dependencies:
  flutter:
    sdk: flutter
  path_provider: ^2.1.0 # Verifique a versão mais recente
```
#### 2 Exemplo de código para salvar um arquivo
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SalvarArquivoScreen extends StatefulWidget {
  @override
  _SalvarArquivoScreenState createState() => _SalvarArquivoScreenState();
}

class _SalvarArquivoScreenState extends State<SalvarArquivoScreen> {
  final TextEditingController _controller = TextEditingController();

  // Função para obter o caminho do arquivo
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Função para criar a referência do arquivo
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/meu_arquivo.txt');
  }

  // Função para salvar o texto no arquivo
  Future<File> _writeCounter(String text) async {
    final file = await _localFile;
    // Grava o arquivo
    return file.writeAsString(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salvar Arquivo Texto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller),
            ElevatedButton(
              onPressed: () {
                _writeCounter(_controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Arquivo salvo em Documentos")),
                );
              },
              child: Text("Salvar no Celular"),
            ),
          ],
        ),
      ),
    );
  }
}
```
#### Detalhes Importantes
- getApplicationDocumentsDirectory(): Recomendado para arquivos privados do aplicativo (pasta Documentos).
- getExternalStorageDirectory() (Android): Use se precisar salvar em pastas públicas como Downloads, mas requer permissões de armazenamento.
- dart:io: Necessário para manipular File, Directory e writeAsString.
- writeAsString: Sobrescreve o arquivo. Se quiser adicionar ao final, use file.writeAsString(text, mode: FileMode.append). 
##### Alternativa: Salvar em pasta acessível (Downloads)
Para salvar arquivos que o usuário consiga abrir fora do app, utilize pacotes como simple_file_saver ou file_saver.