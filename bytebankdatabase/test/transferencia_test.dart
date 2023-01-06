import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Deve retornar o valor no fim da operacao", () {
    final Transferencia transferencia = Transferencia(null, 200, null);
    expect(transferencia.valor!.toInt(), 200);
  });
  test("Deve apresentar erro se nao for maior que zero", () {
    expect(() => Transferencia(null, 0, null), throwsAssertionError);
  });
}
