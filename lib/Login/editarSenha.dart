import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditarSenha extends StatefulWidget{
  const EditarSenha({super.key});

  @override
  State<EditarSenha> createState()=>
  EditarSenhaState();
}

class EditarSenhaState extends State<EditarSenha>{

  final TextEditingController emailController = TextEditingController();
  String? statusMessage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'Alterar Senha',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        automaticallyImplyLeading: false,

      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Informe seu e-mail para alterar a senha',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,  
              ),
            ),
            SizedBox(height: 30.0),

            // Campo de email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 24.0),

            // Mensagem de erro ou sucesso
            if (statusMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  statusMessage!,
                  style: TextStyle(
                    color: statusMessage!.contains('sucesso') ? Colors.green : Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Botão de enviar link para alteração de senha
            ElevatedButton(
              onPressed: isLoading ? null : sendPasswordResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Enviar Link',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        statusMessage = 'Por favor, insira um e-mail válido.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      statusMessage = null; 
    });

    try {
      final auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: email);
      setState(() {
        statusMessage = 'Link de redefinição de senha enviado com sucesso! Verifique seu e-mail.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = 'Erro: ${e.message}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

}