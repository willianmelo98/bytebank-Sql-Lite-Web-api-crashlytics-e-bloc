import 'dart:convert';
import 'package:bytebankdatabase/http/endpoints.dart';
import 'package:bytebankdatabase/http/web_cliente.dart';
import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:http/http.dart';

class TransferenciaWebClient {
  Future<List<Transferencia>> findAll() async {
    final Response response = await client
        .get(Uri.http(EndPoint.baseUrl, EndPoint.transaction))
        .timeout(Duration(seconds: 5));
    List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transferencia.fromJson(json))
        .toList();
  }

  Future<Transferencia> save(Transferencia transferencia, String senha) async {
    Map<String, dynamic> transactionMap = transferencia.toJson();
    final String jsonTransaction = jsonEncode(transactionMap);
    final Response response = await client
        .post(Uri.http(EndPoint.baseUrl, EndPoint.transaction),
            headers: {
              'Content-type': 'application/json',
              'password': senha,
            },
            body: jsonTransaction)
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return Transferencia.fromJson(jsonDecode(response.body));
    }
    throw HttpException(statusCodeResponses[response.statusCode] ??
        'Status Code? ${response.statusCode} ,Api resposta: ${response.body}, ');
  }

  static Map<int, String> statusCodeResponses = {
    400: '400 - Verefique os dados e tente novamente. ',
    401: '401 - Senha incorreta, por favor tente novamente. ',
    409: '409 - Transacao ja existe. '
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
