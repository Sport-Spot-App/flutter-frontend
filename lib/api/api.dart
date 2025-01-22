import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:sport_spot/api/default_interceptor.dart';
import 'package:sport_spot/api/token/token_storage.dart';

class Api extends DioForNative {
  Api() : super(BaseOptions()) {
    // Production
    options.baseUrl = "https://sportspott.tech/api";
    // Localhost
    // options.baseUrl = "http://localhost/api";

    interceptors.addAll([
      DefaultInterceptor(TokenStorage())
    ]);
  }
}