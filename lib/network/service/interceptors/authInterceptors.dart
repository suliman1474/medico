import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  late FlutterSecureStorage storage;
  AuthInterceptor(this.storage);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Set the JWT token in the header for each request
    // final token = await storage.read(key: 'jwt');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    //   return handler.next(options);
    // } else {
    //   return handler.next(options);
    // }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Store the JWT token in the secure storage for future requests

    return handler.next(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle errors here
    return handler.next(err);
  }
}
