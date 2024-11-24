import 'package:app_veiculo/GerenciaAbastecimento/abastecimentoView.dart';
import 'package:app_veiculo/test/test_abastecimento_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Veículos',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Veículos'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navegar para a tela de cadastro de abastecimento
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestAbastecimentoItem()),
              );
            },
            child: const Text('Cadastrar Abastecimento'),
          ),
        ),
      ),
    );
  }
}
