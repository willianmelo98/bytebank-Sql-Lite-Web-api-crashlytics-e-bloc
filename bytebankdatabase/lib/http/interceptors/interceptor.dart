import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final String printRequisicao =
        '{ Url:  ${data.url}, headers: ${data.headers}, body:  ${data.body} }';
    print(printRequisicao);

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    final String printRequisicao =
        '{ StatusCode:  ${data.statusCode}, headers: ${data.headers}, body:  ${data.body} }';
    print(printRequisicao);
    return data;
  }
}
