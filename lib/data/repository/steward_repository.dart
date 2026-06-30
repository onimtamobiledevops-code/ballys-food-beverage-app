import 'package:ballysfoodbeverage/models/steward.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';

class StewardRepository {
  final ApiService apiService;

  StewardRepository(this.apiService);

  /// Fetches the list of stewards.
  ///
  /// [searchText] maps to the @Text1 parameter (varchar(100)). Pass an
  /// empty string (default) to fetch the full list, matching the
  /// behaviour observed in Postman.
  Future<List<Steward>> fetchStewards({String searchText = ''}) async {
    final response = await apiService.post('CommonExecute', {
      "HasReturnData": "T",
      "Parameters": [
        {
          "Para_Data": "12",
          "Para_Direction": "Input",
          "Para_Lenth": 1,
          "Para_Name": "@Iid",
          "Para_Type": "int",
        },
        {
          "Para_Data": searchText,
          "Para_Direction": "Input",
          "Para_Lenth": 100,
          "Para_Name": "@Text1",
          "Para_Type": "varchar",
        },
      ],
      "SpName": "sp_Android_Common_API",
      "con": "1",
    });

    if (response['CommonResult'] != null &&
        response['CommonResult']['Table'] is List &&
        response['CommonResult']['Table'].isNotEmpty) {
      final tableData = response['CommonResult']['Table'] as List<dynamic>;
      return tableData
          .map((json) => Steward.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stewards: unexpected response structure.');
    }
  }
}