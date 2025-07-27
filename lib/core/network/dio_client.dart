import 'package:dio/dio.dart';
import 'package:news_app/core/network/dio_options.dart';

class DioClient {
  final Dio _dio;

  DioClient({String? baseUrl})
    : _dio = Dio(baseOptions..baseUrl = baseUrl ?? '');

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
