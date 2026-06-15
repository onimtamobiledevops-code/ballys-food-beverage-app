/// Represents a successfully authenticated user.
class UserModel {
  final String name;      // Emp_Name from login response
  final int secLevel;     // Sec_Lvl from login response
  final int deviceId;     // Device_Id from device-check response
  final String docNo;     // Doc_No from device-check response

  const UserModel({
    required this.name,
    required this.secLevel,
    required this.deviceId,
    required this.docNo,
  });
}