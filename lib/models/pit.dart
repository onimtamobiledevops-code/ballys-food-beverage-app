class Pit {
  final String pitName;

  const Pit({required this.pitName});

  factory Pit.fromJson(Map<String, dynamic> json) {
    return Pit(
      pitName: json['Pit_Name']?.toString() ?? '',
    );
  }
}
