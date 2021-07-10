import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  receiveTimeout: 5000,
);
Dio dio = Dio(options);
