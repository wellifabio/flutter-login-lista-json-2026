import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "mariana@email.com";
  String senha = "senha123";
  late TextEditingController _email, _senha;
  bool _senhaVisivel = false;
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: email);
    _senha = TextEditingController(text: senha);
    carrearUsuariosJSON();
  }

  Future<void> carrearUsuariosJSON() async {
    String data = await rootBundle.loadString('assets/users.json');
    usuarios = json.decode(data);
    verificarSeJaEstaLogado();
  }

  Future<void> verificarSeJaEstaLogado() async {
    final localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('user_data')) {
      toHome();
    }
  }

  Future<void> salvarPerfil(int indice) async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('user_data', json.encode(usuarios[indice]));
    toHome();
  }

  void toHome() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  void entrar() {
    int indice = -1;
    indice = usuarios.indexWhere((user) => user['email'] == email);
    if (indice != -1) {
      if (usuarios[indice]['senha'] == senha) {
        salvarPerfil(indice);
      } else {
        msgDialog("Erro", "Senha inválda.");
      }
    } else {
      msgDialog("Erro", "E-mail não encontrado.");
    }
  }

  void msgDialog(String titulo, String msg) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: [
            ElevatedButton(
              child: Text("Fechar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12.0,
          children: [
            GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails drag) =>
                  drag.delta.dy < 0 ? verificarSeJaEstaLogado() : null,
              child: Image.asset('assets/user.png', width: 200, height: 200),
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: "E-mail"),
              onChanged: (value) {
                email = value;
              },
            ),
            TextField(
              controller: _senha,
              obscureText: !_senhaVisivel,
              decoration: InputDecoration(
                labelText: "Senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _senhaVisivel = !_senhaVisivel;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                senha = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                entrar();
              },
              child: Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
