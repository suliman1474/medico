import 'package:dio/dio.dart';
import 'package:medico/constants/flutter_secure_storage.dart';

import '../../constants/app_url.dart';
import '../service/api_service.dart';

class HomeApi {
  final ApiService _apiService = ApiService();

  // Future<Response> getProjects() async {
  //   try {
  //     final Response response = await _apiService.get(AppUrl.projects);
  //
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> getCategories() async {
    try {
      final Response response = await _apiService.get(
        '${AppUrl.baseUrl}${AppUrl.getCategories}',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getGenerateQuiz(String id) async {
    try {
      Map<String, dynamic> data = {
        'id': id,
      };
      final Response response = await _apiService.get(
        '${AppUrl.baseUrl}${AppUrl.getQuizByCategory}',
        queryParameters: data,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> startQuiz(String id) async {
    try {
      String? userId = await storage.read(key: 'userId');

      Map<String, dynamic> data = {'quiz_id': id, 'user_id': userId};
      final Response response = await _apiService.get(
        '${AppUrl.baseUrl}${AppUrl.startQuiz}',
        queryParameters: data,
      );
      //
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> endQuiz(
      int id, String quizResult, String correctedQuestionsId) async {
    try {
      Map<String, dynamic> data = {
        'id': id,
        'quiz_result': quizResult,
        'correct_answers': correctedQuestionsId
      };
      final Response response = await _apiService.get(
        '${AppUrl.baseUrl}${AppUrl.endQuiz}',
        queryParameters: data,
      );
      //
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
