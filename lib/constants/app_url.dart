class AppUrl {
  AppUrl._();

  // base url
  static const String baseUrl =
      "https://quiz.app-desk.com/webservices/"; //"http://192.168.43.182:4000/api/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String baseImage = 'https://quiz.app-desk.com';
  static const String registerUrl = 'register_1.php';
  static const String loginUrl = 'login.php';
  static const String getUserById = 'get_user_by_id.php';
  static const String updateUser = 'update_user.php';
  static const String getCategories = 'get_quiz_categories.php';
  static const String getQuizByCategory = 'get_quizzes_by_category.php';
  static const String startQuiz = 'quiz_start.php';
  static const String endQuiz = 'quiz_end.php';
}
