// @dart=2.9
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
}
