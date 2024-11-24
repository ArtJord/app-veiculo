import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_veiculo/model/Abastecimento.dart';
import 'package:app_veiculo/model/Veiculo.dart';
import 'package:app_veiculo/controller/VeiculoController.dart';

class AbastecimentoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cadastro de abastecimento
  Future<bool> cadastrarAbastecimento(Abastecimento abastecimento) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        print("Erro: Nenhum usuário autenticado.");
        return false;
      }

      String idUsuario = usuario.uid;

      // Valida dados antes de salvar
      if (abastecimento.quantidadeLitros <= 0 || abastecimento.km <= 0) {
        print("Erro: Dados de abastecimento inválidos.");
        return false;
      }

      CollectionReference abastecimentosRef = _firestore.collection('abastecimentos');

      Map<String, dynamic> dadosAbastecimento = {
        'idUsuario': idUsuario,
        'dataAbastecimento': abastecimento.dataAbastecimento,
        'quantidadeLitros': abastecimento.quantidadeLitros,
        'km': abastecimento.km,
        'idVeiculo': abastecimento.veiculo.id,
      };

      // Salva o abastecimento no Firestore
      await abastecimentosRef.add(dadosAbastecimento);

      // Calcula a média de consumo do veículo
      double mediaConsumo = calcularMediaConsumo(abastecimento);

      // Atualiza os dados do veículo
      VeiculoController veiculoController = VeiculoController();
      await veiculoController.atualizarConsumoVeiculo(abastecimento.veiculo, mediaConsumo);

      // Atualiza o KM do veículo
      abastecimento.veiculo.kmAtual = abastecimento.km;

      // Adiciona o abastecimento à lista de abastecimentos do veículo
      abastecimento.veiculo.abastecimentos.add(abastecimento);

      return true;
    } catch (e) {
      print("Erro ao cadastrar abastecimento: $e");
      return false;
    }
  }

  /// Função auxiliar para calcular a média de consumo do veículo
  double calcularMediaConsumo(Abastecimento abastecimento) {
    // Evita divisão por zero ou dados inválidos
    if (abastecimento.quantidadeLitros == 0) return 0;
    return (abastecimento.km - abastecimento.veiculo.kmAtual) / abastecimento.quantidadeLitros;
  }

  /// Busca todos os abastecimentos de veículos do usuário
  Future<List<Abastecimento>> buscarAbastecimentosPorUsuario() async {
    try {
      VeiculoController veiculoController = VeiculoController();
      List<Veiculo> veiculos = await veiculoController.buscarVeiculosUsuario();

      List<Abastecimento> listaAbastecimentos = [];

      for (var veiculo in veiculos) {
        CollectionReference abastecimentosRef = _firestore.collection('abastecimentos');

        QuerySnapshot querySnapshot = await abastecimentosRef
            .where('idVeiculo', isEqualTo: veiculo.id)
            .orderBy('dataAbastecimento', descending: true)
            .get();

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic>? dados = doc.data() as Map<String, dynamic>?;

          if (dados != null) {
            listaAbastecimentos.add(Abastecimento.fromMap(dados, veiculo.id, veiculo.nome));
          } else {
            print("Documento com dados nulos encontrado: ${doc.id}");
          }
        }
      }

      return listaAbastecimentos;
    } catch (e) {
      print("Erro ao buscar abastecimentos: $e");
      return [];
    }
  }
}
