
class UserModel {
  final String name;      
  final int secLevel;     
  final int deviceId;   
  final String docNo;    

  const UserModel({
    required this.name,
    required this.secLevel,
    required this.deviceId,
    required this.docNo,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'secLevel': secLevel,
        'deviceId': deviceId,
        'docNo': docNo,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] as String? ?? '',
        secLevel: (json['secLevel'] as num?)?.toInt() ?? 0,
        deviceId: (json['deviceId'] as num?)?.toInt() ?? 0,
        docNo: json['docNo']?.toString() ?? '',
      );
}