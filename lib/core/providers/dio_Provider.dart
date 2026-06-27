import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
final apiClientProvider = Provider<ApiClient>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiClient(dioClient: dioClient);
});
