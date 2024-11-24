import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Abastecimento.dart';





class AbastecimentoItem extends StatelessWidget {
  final Abastecimento abastecimento;

  const AbastecimentoItem({super.key, required this.abastecimento});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              abastecimento.veiculo.nome, 
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              '${abastecimento.dataAbastecimento}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  'Km: ${abastecimento.km}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                
                Text(
                  'Litros: ${abastecimento.quantidadeLitros}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

