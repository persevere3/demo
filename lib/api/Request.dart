import 'package:dio/dio.dart';

class Request {
  late Dio dio;

  Request() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://nfftyode.com',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 加上 Token
        // options.headers['Authorization'] = 'Bearer your_token';
        print('➡️ 請求: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ 回應: ${response}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ 錯誤: ${e.message}');
        return handler.next(e);
      },
    ));
  }
}