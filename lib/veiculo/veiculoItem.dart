import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Veiculo.dart';

class VeiculoItem extends StatelessWidget{
  final Veiculo veiculo;
  final VoidCallback onEdit;

  const VeiculoItem({super.key, required this.veiculo, required this.onEdit});

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  veiculo.nome,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Média de Consumo: ${veiculo.mediaConsumo != null ? veiculo.mediaConsumo!.toStringAsFixed(2) : "Indisponivel"}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Marca: ${veiculo.marca}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ano: ${veiculo.ano}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Placa: ${veiculo.placa}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'KM Atual: ${veiculo.kmAtual}', 
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );

  }
}