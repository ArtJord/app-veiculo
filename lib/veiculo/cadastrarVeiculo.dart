import 'package:flutter/material.dart';
import 'package:app_veiculo/controller/VeiculoController.dart';

class CadastrarVeiculo extends StatefulWidget{
  const CadastrarVeiculo({super.key});

  @override
  CadastrarVeiculoState createState() =>
  CadastrarVeiculoState();
}

class CadastrarVeiculoState extends State<CadastrarVeiculo>{
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController kmController = TextEditingController(); 

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _adicionarVeiculo(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      VeiculoController controller = VeiculoController();

      bool sucesso = await controller.adicionarVeiculo(
        nomeController.text,
        marcaController.text,
        anoController.text,
        placaController.text,
        int.tryParse(kmController.text) ?? 0, 
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(sucesso ? 'Veículo adicionado com sucesso!' : 'Erro ao adicionar veículo.'),
        ),
      );

      if (sucesso) {
        nomeController.clear();
        marcaController.clear();
        anoController.clear();
        placaController.clear();
        kmController.clear(); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  'Adicionar Novo Veículo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Veículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do veículo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca do Veículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a marca do veículo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: anoController,
                decoration: const InputDecoration(
                  labelText: 'Ano do Veículo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano do veículo.';
                  } else if (int.tryParse(value) == null) {
                    return 'Por favor, insira um ano válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa do Veículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa do veículo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: kmController,
                decoration: const InputDecoration(
                  labelText: 'Km Atual do Veículo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o km atual do veículo.';
                  } else if (int.tryParse(value) == null) {
                    return 'Por favor, insira um valor de km válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.red, 
                  ),
                  onPressed: () => _adicionarVeiculo(context),
                  child: const Text('Adicionar Veículo', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}