# Login arquivo JSON
Apicaçao flutter de exemplo de processo de login com:
|Assunto|Comando ou biblioteca|
|-|:-:|
|Navegação push, pop|Navegator|
|Compartilhamento de dados entre telas (shared, "LocalStorage")|Biblioteca: shared_preferences.dart<br>SharedPreferences|
|Leitura de dados de aquivo local de texto JSON|rootBundle.loadString()|
|Conversão de dados|json.encode(), json.decode()|
|Imagens locais e da web|Image.asset(), Image.network()|
|Ações por gestos|GestureDetector|
|Listas|List<>, ListView|

## Tecnologias
- Flutter

## Telas
![Screenshot01](./assets/prints/sreenshot01.png)
![Screenshot02](./assets/prints/sreenshot03.png)
![Screenshot03](./assets/prints/sreenshot03.png)

## Como testar
- Clone o repositório
- Abra com vscode e em um terminal execute:
```bash
flutter pub get
flutter run
```

## Outros
Comando para gerar o .apk para instalar no Android e testar
```bash
flutter build apk --release
```