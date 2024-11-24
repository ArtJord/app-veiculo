import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Veiculo.dart';
import 'package:app_veiculo/model/Abastecimento.dart';
import 'package:app_veiculo/GerenciaAbastecimento/AbastecimentoItem.dart';

/*void main() {
  runApp(const TestAbastecimentoItem());
}
*/

class TestAbastecimentoItem extends StatelessWidget {
  const TestAbastecimentoItem({super.key});

  @override
  Widget build(BuildContext context) {
    
    final Veiculo veiculoTeste = Veiculo(
      id: "1",  
      nome: "Fusca 1975",
      marca: "Volkswagen",
      ano: "1975",
      placa: "ABC-1234",
      usuarioId: "usuario123", 
      kmAtual: 120000,
    );
    
    final Abastecimento abastecimentoTeste = Abastecimento(
      veiculo: veiculoTeste,
      dataAbastecimento: "24/11/2024",
      quantidadeLitros: 40,
      km: 120050,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Teste AbastecimentoItem"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AbastecimentoItem(abastecimento: abastecimentoTeste),
        ),
      ),
    );
  }
}
