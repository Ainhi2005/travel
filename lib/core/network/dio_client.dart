import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio(
    BaseOptions(
      // Chú ý: Dùng 10.0.2.2 cho máy ảo Android, dùng 127.0.0.1 cho iOS/Web/Windows.
      // Tạm thời dùng 127.0.0.1 theo yêu cầu.
      baseUrl: 'http://127.0.0.1:3658/m1/1312864-1312865-default',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
}
