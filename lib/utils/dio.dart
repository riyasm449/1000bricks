import 'package:dio/dio.dart';
import 'package:thousandbricks/utils/commons.dart';

BaseOptions options = BaseOptions(
  baseUrl: Commons.baseUrl,
  // connectTimeout: 10000,
  receiveTimeout: 5000,
);
Dio dio = Dio(options);
