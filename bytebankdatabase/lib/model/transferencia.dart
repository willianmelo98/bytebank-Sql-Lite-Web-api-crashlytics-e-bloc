import 'contact.dart';

class Transferencia {
  final String uuid;
  final double? valor;
  final Contact contato;

  Transferencia(this.uuid, this.valor, this.contato);

  Transferencia.fromJson(Map<String, dynamic> json)
      : uuid = json['id'],
        valor = json['value'],
        contato = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'id': uuid,
        'value': valor,
        'contact': contato.toJson(),
      };

  @override
  String toString() =>
      'Transferencia criada, valor: $valor, numeroConta: $contato';
}
