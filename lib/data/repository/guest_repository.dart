import 'package:ballysfoodbeverage/models/guest.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';

class GuestRepository {
  final ApiService apiService;

  GuestRepository(this.apiService);

  /// Fetches the guests seated at a table.
  ///
  /// [tblCode] maps to the @Text1 parameter (e.g. "BAC-40").
  /// Uses @Iid = 6 on the "2" connection.
  Future<List<Guest>> fetchGuests(String tblCode) async {
    final response = await apiService.post('CommonExecute', {
      "HasReturnData": "T",
      "Parameters": [
        {
          "Para_Data": "6",
          "Para_Direction": "Input",
          "Para_Lenth": 1,
          "Para_Name": "@Iid",
          "Para_Type": "int",
        },
        {
          "Para_Data": tblCode,
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
      // An empty list is valid — the table simply has no guests.
      return table
          .map((json) => Guest.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load guests: unexpected response structure.');
    }
  }
}
