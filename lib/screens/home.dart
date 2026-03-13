import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> dados = [];
  String usuario = '';
  String avatar = '';

  @override
  void initState() {
    super.initState();
    verificarSeEstaLogado();
  }

  Future<void> verificarSeEstaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_data')) {
      carrearUsuariosJSON();
      usuario = json.decode(prefs.getString('user_data')!)['nome'];
      avatar = json.decode(prefs.getString('user_data')!)['avatar'];
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void carrearUsuariosJSON() async {
    String data = await rootBundle.loadString('assets/users.json');
    setState(() {
      dados = json.decode(data);
    });
  }

  Image tipoImg(String img) {
    if (img == "") {
      return Image.asset('assets/user.png');
    } else {
      return Image.network(img);
    }
  }

  ClipRRect userAvatar(String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: img == ''
          ? Image.asset('assets/user.png', width: 50, height: 50)
          : Image.network(img, width: 50, height: 50, fit: BoxFit.cover),
    );
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    verificarSeEstaLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario),
        backgroundColor: Colors.blueGrey,
        toolbarHeight: 70.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userAvatar(avatar),
          ),
          ElevatedButton(onPressed: () => sair(), child: Text("Sair")),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, i) {
          return ListTile(
            leading: Text(
              "${dados[i]['id']}",
              style: TextStyle(fontSize: 22.0),
            ),
            contentPadding: const EdgeInsets.all(8),
            title: Text(dados[i]['nome']),
            subtitle: Text(dados[i]['email']),
            trailing: CircleAvatar(
              backgroundImage: tipoImg(dados[i]['avatar']).image,
            ),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, _) => const Divider(),
        itemCount: dados.length,
      ),
    );
  }
}
