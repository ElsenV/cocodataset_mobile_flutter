import 'package:cocodataset_mobile_flutter/core/network/i_network_service.dart';
import 'package:dio/dio.dart';

class DioService extends INetworkService {
  DioService({required Dio client}) : _client = client;

  final Dio _client;

  @override
  Future<Response<dynamic>> get(
    String url, {
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _client.get(
      url,
      options: _option(),
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );

    return response;
  }

  @override
  Future<Response<dynamic>> post(
    String url, {
    dynamic data = const <String, dynamic>{},
    bool requiredToken = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.post(
      url,
      data: data,
      options: _option(),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );

    return response;
  }

  //! Option for setting content type
  Options _option() {
    return Options(contentType: Headers.formUrlEncodedContentType);
  }
}
