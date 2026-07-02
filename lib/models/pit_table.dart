class PitTable {
  final String tblCode;

  const PitTable({required this.tblCode});

  factory PitTable.fromJson(Map<String, dynamic> json) {
    return PitTable(
      tblCode: json['TblCode']?.toString() ?? '',
    );
  }
}
