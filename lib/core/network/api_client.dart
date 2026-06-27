import '../error/exceptions.dart';
import 'dio_client.dart';

class ApiClient {
  final DioClient dioClient;

  ApiClient({required this.dioClient});

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await ApiErrorHandler.handleRequest(dioClient.dio.get(
      path,
      queryParameters: queryParameters,
    ));
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await ApiErrorHandler.handleRequest(dioClient.dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    ));
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await ApiErrorHandler.handleRequest(dioClient.dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
    ));
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await ApiErrorHandler.handleRequest(dioClient.dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    ));
  }
}