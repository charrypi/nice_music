import 'package:dio/dio.dart';

/// 基于dio的请求封装类
class HttpRequest {
  static HttpRequest _instance = HttpRequest._internal();

  Dio _dio;

  factory HttpRequest() => _instance;

  HttpRequest._internal() {
    if (_dio == null) {
      _dio = new Dio(BaseOptions(
          connectTimeout: 30000,
          receiveTimeout: 10000,
          receiveDataWhenStatusError: false));
//      _dio.interceptors.add(CookieManager(CookieJar()));
    }
  }

  HttpRequest _normal() {
    return this;
  }

  static HttpRequest getInstance() {
    return _instance._normal();
  }

  Future<Response<T>> get<T>(String url, {params, options}) async {
    if (params == null) {
      return await _dio.get<T>(url, options: options);
    }
    return await _dio.get<T>(url, queryParameters: params, options: options);
  }

  post(String url, {data}) async {
    return await _dio.post(url, data: data);
  }

  Future<Response> download(
      String urlPath, String savePath, ProgressCallback receiveProgress,
      {CancelToken cancelToken}) async {
    _dio.options.receiveTimeout = 0;
    return await _dio.download(urlPath, savePath,
        cancelToken: cancelToken, onReceiveProgress: receiveProgress);
  }
}
