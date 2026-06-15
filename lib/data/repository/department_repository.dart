import 'package:ballysfoodbeverage/models/department.dart';
import 'package:ballysfoodbeverage/services/api_service.dart';



class DepartmentRepository {
  final ApiService apiService;

  DepartmentRepository(this.apiService);

  Future<List<Department>> fetchDepartments() async {
    final response = await apiService.post('CommonExecute', {
      "HasReturnData": "T",
      "Parameters": [
        {
          "Para_Data": "3",
          "Para_Direction": "Input",
          "Para_Lenth": 1,
          "Para_Name": "@Iid",
          "Para_Type": "int",
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
          .map((json) => Department.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load departments: unexpected response structure.');
    }
  }
}