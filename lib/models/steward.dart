class Steward {
  final double idNo;
  final String stwCode;
  final String stwName;
  final bool isActive;

  const Steward({
    required this.idNo,
    required this.stwCode,
    required this.stwName,
    required this.isActive,
  });

  factory Steward.fromJson(Map<String, dynamic> json) {
    return Steward(
      idNo: (json['Id_No'] as num?)?.toDouble() ?? 0.0,
      stwCode: json['Stw_Code']?.toString() ?? '',
      stwName: json['Stw_Name']?.toString() ?? '',
      isActive: json['ISActive'] as bool? ?? false,
    );
  }
}