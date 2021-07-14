import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  // connectTimeout: 10000,
  receiveTimeout: 5000,
);
Dio dio = Dio(options);
