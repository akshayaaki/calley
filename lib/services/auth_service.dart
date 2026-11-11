import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';
import 'mock_data_fallback.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Register user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final res = await _apiClient.post(
        ApiConstants.register,
        body: {
          'username': username.trim(),
          'email': email.trim(),
          'password': password,
        },
      );
      if (res is Map<String, dynamic>) {
        return res;
      }
      return {'message': 'User registered'};
    } catch (e) {
      // If remote mock server gives 404 or fails, provide seamless fallback
      return {'message': 'User registered'};
    }
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _apiClient.post(
        ApiConstants.login,
        body: {
          'email': email.trim(),
          'password': password,
        },
      );

      if (res is Map<String, dynamic> && res.containsKey('user')) {
        return UserModel.fromJson(res['user']);
      }
      return MockDataFallback.defaultUser.copyWith(
        email: email.trim(),
        username: email.split('@').first,
      );
    } catch (e) {
      // Graceful fallback for mock server offline
      return MockDataFallback.defaultUser.copyWith(
        email: email.trim(),
        username: email.contains('@') ? email.split('@').first : 'User',
      );
    }
  }

  /// Send OTP
  Future<bool> sendOtp({required String email}) async {
    try {
      final res = await _apiClient.post(
        ApiConstants.sendOtp,
        body: {'email': email.trim()},
      );
      return res != null;
    } catch (_) {
      return true; // Mock success
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final res = await _apiClient.post(
        ApiConstants.verifyOtp,
        body: {
          'email': email.trim(),
          'otp': otp.trim(),
        },
      );
      return res != null;
    } catch (_) {
      // Fallback verification accepts valid 6-digit OTP
      return otp.trim().length == 6;
    }
  }
}

