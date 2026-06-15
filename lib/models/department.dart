class Department {
  final String deptCode;
  final String deptName;
  final double idNo;
  final String insertDate;
  final int imageId;

  const Department({
    required this.deptCode,
    required this.deptName,
    required this.idNo,
    required this.insertDate,
    required this.imageId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptCode: json['Dept_Code']?.toString() ?? '',
      deptName: json['Dept_Name']?.toString() ?? '',
      idNo: (json['Id_No'] as num?)?.toDouble() ?? 0.0,
      insertDate: json['InsertDate']?.toString() ?? '',
      imageId: (json['ImageID'] as num?)?.toInt() ?? 0,
    );
  }
}