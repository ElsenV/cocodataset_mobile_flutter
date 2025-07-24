import 'package:dio/dio.dart';

abstract class INetworkService {
  Future<Response<dynamic>> get(
    String url, {

    CancelToken? cancelToken,
    Map<String, dynamic> queryParameters,
  });

  Future<Response<dynamic>> post(
    String url, {
    dynamic data = const <String, dynamic>{},

    CancelToken? cancelToken,
  });

 
}
