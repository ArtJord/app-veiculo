import 'package:flutter/material.dart';
import 'package:app_veiculo/model/Abastecimento.dart';
import 'package:app_veiculo/model/Veiculo.dart';
import 'package:app_veiculo/controller/AbastecimentoController.dart';
import 'package:app_veiculo/controller/VeiculoController.dart';


class CadastroAbastecimento extends StatefulWidget {
  const CadastroAbastecimento({super.key});

  @override
  CadastroAbastecimentoState createState() => CadastroAbastecimentoState();
}

class CadastroAbastecimentoState extends State<CadastroAbastecimento>{
  final VeiculoController veiculoController = VeiculoController();

  List<Veiculo> veiculos = [];
  Veiculo? veiculoSelecionado;

  final TextEditingController quilometragemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    aCarregarVeiculos(); 
  }

  void aCarregarVeiculos() async {
    List<Veiculo> veiculosEncontrados =
        await veiculoController.buscarVeiculosUsuario();

    setState(() {
      veiculos = veiculosEncontrados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cadastrar o abastecimento'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<Veiculo>(
              hint: Text('Selecione um veículo'),
              value: veiculoSelecionado,
              onChanged: (Veiculo? novoVeiculo) {
                setState(() {
                  veiculoSelecionado = novoVeiculo;
                  quilometragemController.text =
                      veiculoSelecionado?.kmAtual.toString() ?? '';
                });
              },
              items: veiculos.map((Veiculo veiculo) {
                return DropdownMenuItem<Veiculo>(
                  value: veiculo,
                  child: Text(veiculo.nome),
                );
              }).toList(),
            ),
            SizedBox(height: 30),

            TextField(
              controller: quilometragemController,
              decoration: InputDecoration(
                labelText: 'Quilometragem(KM)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: veiculoSelecionado !=
                  null, 
            ),
            SizedBox(height: 10),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(
                labelText: 'Quantidade em litros',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: veiculoSelecionado !=
                  null, 
            ),
            SizedBox(height: 10),

            TextField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
              ),
              readOnly:
                  true, 
              enabled: veiculoSelecionado !=
                  null, 
              onTap: veiculoSelecionado == null
                  ? null
                  : () async {
                      DateTime? dataSelecionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(2000), 
                        lastDate: DateTime(2100), 
                      );
                      if (dataSelecionada != null) {
                        setState(() {
                          dataController.text =
                              "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";
                        });
                      }
                    },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_isCamposValidos()) {
              String quilometragem = quilometragemController.text;
              String quantidade = quantidadeController.text;
              String data = dataController.text;

              Abastecimento abastecimento = Abastecimento(
                veiculo: veiculoSelecionado!,
                dataAbastecimento: data,
                quantidadeLitros: int.parse(quantidade),
                km: int.parse(quilometragem),
              );

              AbastecimentoController abastecimentoController =
                  AbastecimentoController();
              abastecimentoController.cadastrarAbastecimento(abastecimento);

              Navigator.of(context)
                  .pop(true); 
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Verifique os dados e tente novamente.')),
              );
            }
          },
          child: Text('Salvar', style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }

  bool _isCamposValidos() {
    if (veiculoSelecionado != null) {
      int kmAtual = veiculoSelecionado!.kmAtual;
      int kmInserido = int.tryParse(quilometragemController.text) ?? 0;
      if (kmInserido <= kmAtual) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'A quilometragem deve ser maior que ${kmAtual.toString()}')),
        );
        return false;
      }
    }

    if (quilometragemController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        dataController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return false;
    }

    return true;
  }
}

