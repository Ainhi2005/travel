import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'Server Exception'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache Exception'});

  @override
  String toString() => 'CacheException: $message';
}

class ApiErrorHandler {
  static Future<dynamic> handleRequest(Future<Response> request) async {
    try {
      final response = await request;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerException(message: 'Server trả về lỗi: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Lỗi mạng (Dio): ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }
}
