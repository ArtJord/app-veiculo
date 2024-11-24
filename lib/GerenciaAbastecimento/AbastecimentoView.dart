import 'package:app_veiculo/GerenciaAbastecimento/AbastecimentoItem.dart';
import 'package:app_veiculo/GerenciaAbastecimento/CadastroAbastecimento.dart';
import 'package:app_veiculo/controller/AbastecimentoController.dart';
import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Abastecimento.dart';


class AbastecimentoView extends StatefulWidget{
  const AbastecimentoView({super.key});

 @override
  AbastecimentoViewState createState()=> AbastecimentoViewState();

}

class AbastecimentoViewState extends State<AbastecimentoView>{
  final AbastecimentoController abastecimentoController = AbastecimentoController();
  late Future<List<Abastecimento>> AbastecimentosFuture;

  @override
  void initState() {
    super.initState();
    AbastecimentosFuture = abastecimentoController.buscarAbastecimentosPorUsuario();
  }

  void recarregarAbastecimentos() {
    setState(() {
      AbastecimentosFuture = abastecimentoController.buscarAbastecimentosPorUsuario();
    });
  }

  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Histórico de Abastecimento',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CadastroAbastecimento();
                    },
                  );

                  if (result == true) {
                    recarregarAbastecimentos();
                  }
                },
                child: Text(
                  'Cadastrar Novo Abastecimento',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
              SizedBox(height: 22),
              Expanded(
                child: FutureBuilder<List<Abastecimento>>(
                  future: AbastecimentosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar abastecimentos'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhum abastecimento encontrado'));
                    } else {
                      List<Abastecimento> abastecimentos = snapshot.data!;
                      return ListView.builder(
                        itemCount: abastecimentos.length,
                        itemBuilder: (context, index) {
                          Abastecimento abastecimento = abastecimentos[index];
                          return AbastecimentoItem(abastecimento: abastecimento); 
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

}