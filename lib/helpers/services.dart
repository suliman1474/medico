import 'package:http/http.dart' as http;

class Service {
  Service._();
  static final instance = Service._();
  Future<String> login(String email, String password) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/login.php?email=$email&password=$password'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      print('logged in');
      return jsonString;
    } else {
      return '0';
    }
  }

  Future<String> register(
      String email, String password, String username, String name) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/register.php?email=$email&password=$password&username=$username&name=$name'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      return '0';
    }
  }

  Future<String> update(String id, String email, String password,
      String username, String name, String phone, String photo) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/update_user.php?id=$id&email=$email&password=$password&name=$name&username=$username&phone=$phone&photo=$photo'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      return '0';
    }
  }

  Future<bool> validateEmail(String email) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/validate_email.php?email=$email'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString == 'true' ? true : false;
    } else {
      return true;
    }
  }

  Future<bool> validateUsername(String username) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/validate_user_name.php?username=$username'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString == 'true' ? true : false;
    } else {
      return true;
    }
  }

  Future<String> getUser(String id) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/get_user_by_id.php?id=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      return '0';
    }
  }

  Future<String> guestUser() async {
    Map<String, String> headers = {};
    var request = http.Request('GET',
        Uri.parse('https://quiz.app-desk.com/webservices/guest_user.php'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      return '0';
    }
  }

  Future<String> resendEmail(String id) async {
    Map<String, String> headers = {};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://quiz.app-desk.com/webservices/resend_email.php?id=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      return '0';
    }
  }
}
