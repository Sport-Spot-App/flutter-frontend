import 'package:dio/dio.dart';
import 'package:sport_spot/api/token/token_storage.dart';

class DefaultInterceptor implements Interceptor {
  final TokenStorage _tokenStorage;

  DefaultInterceptor(this._tokenStorage);
  
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final blackList = ["/user", "/login"];
    final relative = options.path;
    final containsPath = blackList.any((e) => e == relative);
    if (!containsPath) {
      final token = await _tokenStorage.read();
      options.headers["Authorization"] = "Bearer $token";
    }
    options.headers["Content-Type"] = "application/json";
    handler.next(options);
  }
  
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path == "/login") {
      final token = response.data["token"];
      await _tokenStorage.save(token);
    }
    handler.next(response);
  }
}