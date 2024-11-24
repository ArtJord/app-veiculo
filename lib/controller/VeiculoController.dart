import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_veiculo/model/Veiculo.dart';

class VeiculoController {
  Future<bool> adicionarVeiculo(
      String nome, String marca, String ano, String placa,int kmAtual) async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        Veiculo veiculo = Veiculo(
          id: '',
          nome: nome,
          marca: marca,
          ano: ano,
          placa: placa,
          usuarioId: usuario.uid,
          kmAtual: kmAtual,
        );

        await FirebaseFirestore.instance
            .collection('veiculos')
            .add(veiculo.toMap());

        return true;
      } catch (error) {
        print("Erro ao adicionar veículo: $error");
        return false;
      }
    } else {
      return false;
    }
  }

   Future<List<Veiculo>> buscarVeiculosUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('veiculos')
            .where('usuarioId', isEqualTo: usuario.uid)
            .get();
        List<Veiculo> veiculos = querySnapshot.docs.map((doc) {
          return Veiculo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        return veiculos;
      } catch (error) {
        print("Erro ao buscar veículos: $error");
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> editarVeiculo(
      String id, String nome, String marca, String ano, String placa, ) async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        await FirebaseFirestore.instance
            .collection('veiculos')
            .doc(id) 
            .update({
          'nome': nome,
          'marca': marca,
          'ano': ano,
          'placa': placa,
        });

        return true;
      } catch (error) {
        print("Erro ao editar veículo: $error");
        return false;
      }
    } else {
      return false;
    }
  }

   Future<bool> deletarVeiculo(String id) async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      try {
        await FirebaseFirestore.instance
            .collection('veiculos')
            .doc(id) 
            .delete();

        return true;
      } catch (error) {
        print("Erro ao deletar veículo: $error");
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> atualizarConsumoVeiculo(Veiculo veiculo, double mediaConsumoNovo) async {
  User? usuario = FirebaseAuth.instance.currentUser;
  int KmNovo = veiculo.kmAtual;
  if (usuario != null) {
    try {
      if (veiculo.id.isEmpty) {
        print("Erro: Veículo não encontrado.");
        return false;
      }

      await FirebaseFirestore.instance
          .collection('veiculos')
          .doc(veiculo.id)
          .update({
        'mediaConsumo': mediaConsumoNovo,
        'kmAtual': KmNovo,
      });

      print("Consumo do veículo atualizado com sucesso.");
      return true;
    } catch (error) {
      print("Erro ao editar o consumo do veículo: $error");
      return false;
    }
  } else {
    print("Usuário não autenticado.");
    return false;
  }
}


}