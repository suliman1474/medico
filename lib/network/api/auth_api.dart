import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/constants/flutter_secure_storage.dart';

import '../../constants/app_url.dart';
import '../service/api_service.dart';

class AuthApi {
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

  Future<Response> signUpUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    //{Map<String, dynamic>? data}
    try {
      Map<String, dynamic> data = {
        'email': email,
        'username': username,
        'password': password,
        'name': name,
      };

      //v1/users/signup
      final Response response = await _apiService.get(
        '${AppUrl.baseUrl}${AppUrl.registerUrl}',
        queryParameters: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login(
    String email,
    String password,
  ) async {
    //{Map<String, dynamic>? data}
    try {
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      //v1/users/signup
      final Response response = await _apiService.post(
        '${AppUrl.baseUrl}${AppUrl.loginUrl}',
        queryParameters: data,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMyProfile() async {
    //{Map<String, dynamic>? data}
    try {
      final id = await storage.read(key: 'userId');
      print('id of user: $id');
      Map<String, dynamic> data = {
        'id': id,
      };

      //v1/users/signup
      final Response response = await _apiService.post(
        '${AppUrl.baseUrl}${AppUrl.getUserById}',
        queryParameters: data,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateUser(String name, String email, String username,
      String phone, XFile? profilePic) async {
    //{Map<String, dynamic>? data}
    try {
      final id = await storage.read(key: 'userId');

      final formData = FormData.fromMap({
        'id': id,
        'email': email,
        'name': name,
        'username': username,
        'phone': phone,
        if (profilePic != null)
          'photo': await MultipartFile.fromFile(profilePic.path),
      });

      final Response response = await _apiService.post(
        '${AppUrl.baseUrl}${AppUrl.updateUser}',
        data: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
    // try {
    //   final id = await storage.read(key: 'userId');
    //   print('id of user: $id');
    //   var data = FormData.fromMap({
    //     'id': id,
    //     'email': email,
    //     'name': name,
    //     'username': username,
    //     'phone': phone,
    //     'photo':
    //         await MultipartFile.fromFile(imagePath, filename: 'profile.jpg'),
    //   });
    //   final Response response = await _apiService.post(
    //     '${AppUrl.baseUrl}${AppUrl.updateUser}',
    //     queryParameters: data,
    //   );
    //
    //   return response;
    // } catch (e) {
    //   rethrow;
    // }
  }
  // Future<Response> loginUser(String email, String password) async {
  //   //{Map<String, dynamic>? data}
  //   try {
  //     Map<String, dynamic> data = {'email': email, 'password': password};
  //
  //     final Response response = await _apiService.post(
  //       AppUrl.loginUser,
  //       data: data,
  //     );
  //
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<Response> logoutUser() async {
  //   try {
  //     dio.options.headers.remove('Authorization');
  //     final Response response = await _apiService.get(AppUrl.logoutUser);
  //     await storage.delete(key: 'jwt');
  //     await storage.delete(key: 'role');
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // Future<Response> putUser(String id, {Map<String, dynamic>? data}) async {
  //   try {
  //     final Response response = await _apiService.put(
  //       '${AppUrl.projects}/$id',
  //       data: data,
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<Response> deleteUser(String id) async {
  //   try {
  //     final Response response = await _apiService.delete(
  //       '${AppUrl.projects}/$id',
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
