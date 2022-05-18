import 'package:bytebankdatabase/http/interceptors/interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);
