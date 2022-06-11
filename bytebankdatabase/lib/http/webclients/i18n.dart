import 'dart:convert';

import '../endpoints.dart';
import '../web_cliente.dart';
import 'package:http/http.dart';

class I18NWebClient {
  final String _viewKey;
  I18NWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client
        .get(Uri.http(
            EndPoint.baseI18N, EndPoint.compleI18N + _viewKey + ".json"))
        .timeout(Duration(seconds: 5));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}