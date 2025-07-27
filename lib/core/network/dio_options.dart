import 'package:dio/dio.dart';

BaseOptions baseOptions = BaseOptions(
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  responseType: ResponseType.json,
);
