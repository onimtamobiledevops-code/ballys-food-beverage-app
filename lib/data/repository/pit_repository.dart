import 'package:ballysfoodbeverage/models/pit.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';

class PitRepository {
  final ApiService apiService;

  PitRepository(this.apiService);

  /// Fetches the list of pits (areas).
  ///
  /// Uses @Iid = 4 on the "2" connection, matching the behaviour observed
  /// in Postman.
  Future<List<Pit>> fetchPits() async {
    final response = await apiService.post('CommonExecute', {
      "HasReturnData": "T",
      "Parameters": [
        {
          "Para_Data": "4",
          "Para_Direction": "Input",
          "Para_Lenth": 1,
          "Para_Name": "@Iid",
          "Para_Type": "int",
        },
      ],
      "SpName": "sp_Android_Common_API",
      "con": "2",
    });

    if (response['CommonResult'] != null &&
        response['CommonResult']['Table'] is List &&
        response['CommonResult']['Table'].isNotEmpty) {
      final tableData = response['CommonResult']['Table'] as List<dynamic>;
      return tableData
          .map((json) => Pit.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load pits: unexpected response structure.');
    }
  }
}
