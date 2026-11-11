import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/calling_list_model.dart';
import '../models/call_lead_model.dart';
import 'mock_data_fallback.dart';

class CallingListService {
  final ApiClient _apiClient;

  CallingListService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch lists for user
  Future<List<CallingListModel>> getLists({required String userId}) async {
    try {
      final res = await _apiClient.get(
        ApiConstants.list,
        queryParams: {'userId': userId},
      );

      if (res is Map<String, dynamic>) {
        return [CallingListModel.fromJson(res)];
      } else if (res is List) {
        return res.map((item) => CallingListModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [MockDataFallback.defaultList];
    } catch (_) {
      return [MockDataFallback.defaultList];
    }
  }

  /// Fetch list details (stats + leads)
  Future<CallingListDetailsModel> getListDetails({required String listId}) async {
    try {
      final res = await _apiClient.get(
        ApiConstants.listDetails(listId),
      );

      if (res is Map<String, dynamic>) {
        return CallingListDetailsModel.fromJson(res);
      }
      return MockDataFallback.defaultListDetails;
    } catch (_) {
      return MockDataFallback.defaultListDetails;
    }
  }
}

