import 'package:ballysfoodbeverage/models/category.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';



class CategoryRepository {
  final ApiService apiService;

  CategoryRepository(this.apiService);

  Future<List<Category>> fetchCategories(String deptCode) async {
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
        {
          "Para_Data": deptCode,
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
        (response['CommonResult']['Table'] as List).isNotEmpty) {
      final tableData = response['CommonResult']['Table'] as List<dynamic>;
      print('Fetched ${tableData.length} categories for department: $deptCode');
      return tableData
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('No categories found for department: $deptCode');
    }
  }
}