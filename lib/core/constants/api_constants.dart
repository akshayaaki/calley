class ApiConstants {
  static const String baseUrl = 'https://mock-api.calleyacd.com/api';
  
  // Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // Lists Endpoints
  static const String list = '/list';
  static String listDetails(String listId) => '/list/$listId';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration receiveTimeout = Duration(seconds: 12);
}

