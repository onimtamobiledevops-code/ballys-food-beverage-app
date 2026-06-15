import 'package:ballysfoodbeverage/models/item.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';



class ItemRepository {
  final ApiService apiService;

  ItemRepository(this.apiService);

  Future<List<Item>> fetchItems(String deptCode, String catCode) async {
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
          "Para_Data": deptCode,
          "Para_Direction": "Input",
          "Para_Lenth": 100,
          "Para_Name": "@Text1",
          "Para_Type": "varchar",
        },
        {
          "Para_Data": catCode,
          "Para_Direction": "Input",
          "Para_Lenth": 100,
          "Para_Name": "@Text2",
          "Para_Type": "varchar",
        },
      ],
      "SpName": "sp_Android_Common_API",
      "con": "1",
    });

    if (response['CommonResult'] != null &&
        response['CommonResult']['Table'] is List &&
        (response['CommonResult']['Table'] as List).isNotEmpty) {
      final tableData = response['CommonResult']['Table'] as List<dynamic>;
      return tableData
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('No items found for category: $catCode');
    }
  }
}