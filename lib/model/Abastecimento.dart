import 'package:app_veiculo/model/Veiculo.dart';

class Abastecimento {
  String dataAbastecimento;
  int quantidadeLitros;
  int km;
  late Veiculo veiculo; 

  Abastecimento({
    required this.dataAbastecimento,
    required this.quantidadeLitros,
    required this.km,
    required this.veiculo,
  });

   factory Abastecimento.fromMap(Map<String, dynamic> map, String veiculoId, String veiculoNome) {
    Veiculo veiculo = Veiculo(
      id: veiculoId,
      nome: veiculoNome,
      marca: map['veiculoMarca'] ?? '',
      ano: map['veiculoAno'] ?? '',
      placa: map['veiculoPlaca'] ?? '',
      usuarioId: map['veiculoUsuarioId'] ?? '',
      kmAtual: map['veiculoKmAtual'] ?? 0,
    );

    return Abastecimento(
      dataAbastecimento: map['dataAbastecimento'] ?? '',
      quantidadeLitros: map['quantidadeLitros'] ?? 0,
      km: map['km'] ?? 0,
      veiculo: veiculo,
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'dataAbastecimento': dataAbastecimento,
      'quantidadeLitros': quantidadeLitros,
      'km': km,
    };
  }
}

