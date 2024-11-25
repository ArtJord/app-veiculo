import 'package:app_veiculo/model/Veiculo.dart';
import 'package:flutter/material.dart';

void showEditDialog (BuildContext context, Veiculo veiculo, Function(Veiculo) onSave, Function(Veiculo) onDelete){

  TextEditingController nomeController = TextEditingController(text: veiculo.nome);
  TextEditingController marcaController = TextEditingController(text: veiculo.marca);
  TextEditingController anoController = TextEditingController(text: veiculo.ano);
  TextEditingController placaController = TextEditingController(text: veiculo.placa);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Editar Veículo'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: anoController,
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: placaController,
                decoration: InputDecoration(labelText: 'Placa'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDelete(veiculo); 
              Navigator.of(context).pop();
            },
            child: Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              veiculo.nome = nomeController.text;
              veiculo.marca = marcaController.text;
              veiculo.ano = anoController.text;
              veiculo.placa = placaController.text;

              onSave(veiculo); 
              Navigator.of(context).pop(); 
            },
            child: Text('Salvar'),
          ),
        ],
      );
    },
  );

}