// @dart=2.9
import 'package:intl/intl.dart';

class MedicamentoInfo {
  int id;
  String nome;
  //int quantidadeCapsulas;
  List<String> horarios;
  //bool noFim;
  int posicaoCaixa;
  int vezesAoDia;
  int gradienteColorIndex;

  MedicamentoInfo(
      {this.id,
      this.nome,
      //this.quantidadeCapsulas,
      this.horarios,
      //this.noFim,
      this.posicaoCaixa,
      this.vezesAoDia,
      this.gradienteColorIndex});

  factory MedicamentoInfo.fromMap(Map<String, dynamic> json) => MedicamentoInfo(
        id: json["id"],
        nome: json["nome"],
        horarios: json["horarios"].split('_'),
        // noFim: json["noFim"],
        posicaoCaixa: json["posicaoCaixa"],
        vezesAoDia: json["vezesAoDia"],
        gradienteColorIndex: json["gradientColorIndex"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "horarios": horarios.join('_'),
        "posicaoCaixa": posicaoCaixa,
        "vezesAoDia": vezesAoDia,
        "gradientColorIndex": gradienteColorIndex,
      };

  Future<void> geraHorarios(DateTime horarioSelecionado) async {
    DateTime _aux = horarioSelecionado;
    int _horasAdicionadas = (24 * 60) ~/ vezesAoDia;
    _aux = _aux.add(Duration(minutes: _horasAdicionadas));
    for (int i = 0; i < vezesAoDia - 1; i++) {
      if (_aux != DateTime.tryParse(horarios[0])) {
        horarios.add(DateFormat("HH:MM").format(_aux));
        _aux = _aux.add(Duration(minutes: _horasAdicionadas));
      }
    }
    print(horarios);
  }

  String formatHorarios() {
    var horariosFormatado = '';
    for (int i = 0; i < horarios.length; i++) {
      if (i % 4 != 0 || i == 0)
        horariosFormatado += horarios[i] + "\t";
      else
        horariosFormatado += "\n" + horarios[i] + "\t";
    }
    return horariosFormatado;
  }

  String sendToDevice() {
    String fim = id.toString() +
        '_' +
        posicaoCaixa.toString() +
        "_" +
        horarios.join("_");

    return fim;
  }
}
