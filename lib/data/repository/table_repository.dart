import 'package:ballysfoodbeverage/models/pit_table.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';

class TableRepository {
  final ApiService apiService;

  TableRepository(this.apiService);

  /// Fetches the tables belonging to a pit.
  ///
  /// [pitName] maps to the @Text1 parameter (e.g. "A", "VVIP", "BAR").
  /// Uses @Iid = 5 on the "2" connection.
  Future<List<PitTable>> fetchTables(String pitName) async {
    final response = await apiService.post('CommonExecute', {
      "HasReturnData": "T",
      "Parameters": [
        {
          "Para_Data": "5",
          "Para_Direction": "Input",
          "Para_Lenth": 1,
          "Para_Name": "@Iid",
          "Para_Type": "int",
        },
        {
          "Para_Data": pitName,
          "Para_Direction": "Input",
          "Para_Lenth": 100,
          "Para_Name": "@Text1",
          "Para_Type": "varchar",
        },
      ],
      "SpName": "sp_Android_Common_API",
      "con": "2",
    });

    final table = response['CommonResult']?['Table'];
    if (table is List) {
      // An empty list is valid — the pit simply has no tables.
      return table
          .map((json) => PitTable.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load tables: unexpected response structure.');
    }
  }
}
