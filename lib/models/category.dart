class Category {
  final String deptCode;
  final String catCode;
  final String catName;
  final double idNo;
  final String insertDate;
  final int imageId;

  const Category({
    required this.deptCode,
    required this.catCode,
    required this.catName,
    required this.idNo,
    required this.insertDate,
    required this.imageId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      deptCode: json['Dept_Code']?.toString() ?? '',
      catCode: json['Cat_Code']?.toString() ?? '',
      catName: json['Cat_Name']?.toString() ?? '',
      idNo: (json['Id_No'] as num?)?.toDouble() ?? 0.0,
      insertDate: json['InsertDate']?.toString() ?? '',
      imageId: (json['ImageID'] as num?)?.toInt() ?? 0,
    );
  }
}