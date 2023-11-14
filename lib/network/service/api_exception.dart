import 'dart:core';

import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  factory ApiException.fromDioError(DioError dioError) {
    String message = "Something went wrong";

    // Handle DioError-specific errors
    //  final dioErrorData = (dioError.error as DioError).response?.data;
    final status = dioError.response?.statusCode;
    final msg = dioError.response?.data['message'];

    if (status == 400) {
      message = msg;
    } else if (status == 401) {
      message = msg;
    } else if (status == 403) {
      message = msg;
    } else if (status == 404) {
      message = msg;
    } else if (status == 500) {
      message = msg;
    } else if (status == 502) {
      message = msg;
    }

    if (dioError.error is SocketException) {
      // Handle SocketException for network errors
      message = 'No internet connection';
    } else if (dioError.type == DioErrorType.connectionTimeout) {
      message = "Connection timeout with API server";
    } else if (dioError.type == DioErrorType.receiveTimeout) {
      message = "Receive timeout in connection with API server";
    } else if (dioError.type == DioErrorType.sendTimeout) {
      message = "Send timeout in connection with API server";
    } else if (dioError.type == DioErrorType.cancel) {
      message = "Request to API server was cancelled";
    }

    return ApiException(message);
  }

  @override
  String toString() => message;
}
