import 'package:app_veiculo/GerenciaAbastecimento/AbastecimentoView.dart';
import 'package:app_veiculo/Login/login.dart';
import 'package:app_veiculo/Login/userConfig.dart';
import 'package:app_veiculo/veiculo/cadastrarVeiculo.dart';
import 'package:app_veiculo/veiculo/listaVEiculo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  TelaPrincipalState createState() => TelaPrincipalState();
}

class TelaPrincipalState extends State<TelaPrincipal> {
  int selectedIndex = 0;

  User? user = FirebaseAuth.instance.currentUser;

  Widget getBodyContent(int index) {
    switch (index) {
      case 0:
        return const ListaVeiculo();
      case 1:
        return const CadastrarVeiculo();
      case 2:
        return const AbastecimentoView();
      case 3: 
        return const UserConfig();
      case 4:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _confirmarDeslogar(context);
        });
        return const ListaVeiculo();
      default:
        return Scaffold(
        body: Center(
          child: Text('Erro desconhecido!', style: TextStyle(fontSize: 24, color: Colors.red)),
        ),
      );
  }
}

  Future<void> _confirmarDeslogar(BuildContext context) async{
    bool? confirmarDeslogar = await showDialog<bool>(context: context,
     builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Você tem certeza que deseja deslogar?'),
        actions: <Widget[
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('Cancelar'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, 
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Confirmar', style: TextStyle(color: Colors.white),))
        ],
      );
     }
     );
     if (confirmarDeslogar == true) {
      await _logout(context);
     }
  }

  Future<void> _logout(BuildContext context) async{
    try{
      await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deslogado com sucesso')),
    );
          Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );

    }catch (e){
          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao deslogar: $e')),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Veiculo App',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  if (user != null)
                    Text(
                      'Bem vindo, ${user?.displayName ?? user?.email ?? 'Usuário'}',  
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.car_repair),
              title: Text('Meus Veículos'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Adicionar Veículo'),
              
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico de Abastecimentos'),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  Icon(Icons.person),
              title: Text('Perfil'),
              onTap: (){
                setState(() {
                  selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: (){
                setState(() {
                  selectedIndex = 4;
                });
              },
            )
          ],
        ),
      ),
      body: getBodyContent(selectedIndex), 
    );
  }
}