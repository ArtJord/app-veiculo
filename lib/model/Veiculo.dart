import 'package:app_veiculo/model/Abastecimento.dart';

class Veiculo {
  String id;
  String nome;
  String marca;
  String ano;
  String placa;
  String usuarioId;
  int kmAtual;
  double? mediaConsumo;
  List<Abastecimento> abastecimentos;

  Veiculo({
    required this.id,
    required this.nome,
    required this.marca,
    required this.ano,
    required this.placa,
    required this.usuarioId,
    required this.kmAtual,
    this.mediaConsumo,
    this.abastecimentos = const [], 
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'marca': marca,
      'ano': ano,
      'placa': placa,
      'usuarioId': usuarioId,
      'kmAtual': kmAtual,
      'mediaConsumo': mediaConsumo,
      'abastecimentos': abastecimentos.map((ab) => ab.toMap()).toList(),
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map, String id) {
    var abastecimentosList = <Abastecimento>[];
    if (map['abastecimentos'] != null) {
      abastecimentosList = List<Abastecimento>.from(
        map['abastecimentos'].map((ab) => Abastecimento.fromMap(ab, id, map['nome'])),
      );
    }

    return Veiculo(
      id: id,
      nome: map['nome'] ?? '',
      marca: map['marca'] ?? '',
      ano: map['ano'] ?? '',
      placa: map['placa'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      kmAtual: map['kmAtual'] ?? 0,
      mediaConsumo: map['mediaConsumo'] != null ? map['mediaConsumo'] as double : null,
      abastecimentos: abastecimentosList,
    );
  }
}
