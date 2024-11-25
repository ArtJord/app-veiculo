import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Veiculo.dart';
import 'package:app_veiculo/veiculo/veiculoItem.dart';
import 'package:app_veiculo/veiculo/editarVeiculo.dart';
import 'package:app_veiculo/controller/VeiculoController.dart';


class ListaVeiculo extends StatefulWidget{
  const ListaVeiculo({super.key});

  @override
  ListaVeiculoState createState() => ListaVeiculoState();
}

class ListaVeiculoState extends State<ListaVeiculo>{

  late VeiculoController veiculoController;
  late Future<List<Veiculo>> veiculosFuture;

  @override
  void initState() {
    super.initState();
    veiculoController = VeiculoController();
    veiculosFuture = veiculoController.buscarVeiculosUsuario();
  }

  void atualizarVeiculos() {
    setState(() {
      veiculosFuture = veiculoController.buscarVeiculosUsuario();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Meus Veículos',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Veiculo>>(
                future: veiculosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum veículo encontrado.'));
                  }

                  final veiculos = snapshot.data!;

                  return ListView.builder(
                    itemCount: veiculos.length,
                    itemBuilder: (context, index) {
                      return VeiculoItem(
                        veiculo: veiculos[index],
                        onEdit: () {
                          showEditDialog(
                            context,
                            veiculos[index],
                            (editedVeiculo) {
                              veiculoController.editarVeiculo(
                                veiculos[index].id, 
                                editedVeiculo.nome,
                                editedVeiculo.marca,
                                editedVeiculo.ano,
                                editedVeiculo.placa,
                              ).then((_) {
                                atualizarVeiculos();
                              });
                            },
                            (deletedVeiculo) {
                              veiculoController.deletarVeiculo(deletedVeiculo.id).then((_) {
                                atualizarVeiculos();
                              });
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}