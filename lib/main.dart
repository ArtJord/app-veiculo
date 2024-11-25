import 'package:app_veiculo/GerenciaAbastecimento/abastecimentoView.dart';
import 'package:app_veiculo/Login/login.dart';
import 'package:app_veiculo/Login/telaPrincipal.dart';
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
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot){
          if(snapshot.hasData && snapshot.data != null){
            return TelaPrincipal();
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return Login();
          }
        },
      ),
    );
  }
 }
 

