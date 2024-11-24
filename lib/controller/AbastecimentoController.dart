import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_veiculo/model/Abastecimento.dart';
import 'package:app_veiculo/model/Veiculo.dart';
import 'package:app_veiculo/controller/VeiculoController.dart';

class AbastecimentoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<bool> cadastrarAbastecimento(Abastecimento abastecimento) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        print("Erro: Nenhum usuário autenticado.");
        return false;
      }

      String idUsuario = usuario.uid;

      
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

      
      await abastecimentosRef.add(dadosAbastecimento);

      
      double mediaConsumo = calcularMediaConsumo(abastecimento);

     
      VeiculoController veiculoController = VeiculoController();
      await veiculoController.atualizarConsumoVeiculo(abastecimento.veiculo, mediaConsumo);

      
      abastecimento.veiculo.kmAtual = abastecimento.km;

      
      abastecimento.veiculo.abastecimentos.add(abastecimento);

      return true;
    } catch (e) {
      print("Erro ao cadastrar abastecimento: $e");
      return false;
    }
  }

  
  double calcularMediaConsumo(Abastecimento abastecimento) {
    
    if (abastecimento.quantidadeLitros == 0) return 0;
    return (abastecimento.km - abastecimento.veiculo.kmAtual) / abastecimento.quantidadeLitros;
  }

  
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
