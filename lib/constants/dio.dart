import 'package:dio/dio.dart';

import '../network/service/interceptors/authInterceptors.dart';
import 'app_url.dart';
import 'flutter_secure_storage.dart';

final _options = BaseOptions(
  baseUrl: AppUrl.baseUrl,
  connectTimeout: const Duration(seconds: AppUrl.connectionTimeout),
  receiveTimeout: const Duration(seconds: AppUrl.receiveTimeout),
  responseType: ResponseType.json,
);
final Dio dio = Dio(_options)..interceptors.add(AuthInterceptor(storage));
