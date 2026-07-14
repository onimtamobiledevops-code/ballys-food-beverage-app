import 'dart:convert';
import 'dart:typed_data';

/// A guest seated at a table (from the @Iid=6 members API).
///
/// This is intentionally separate from `UserModel`, which represents the
/// logged-in app user.
class Guest {
  final String mid;
  final String mName;

  /// Decoded profile photo bytes (from the base64 `MemImage2` field),
  /// or `null` when absent/invalid.
  final Uint8List? image;

  const Guest({
    required this.mid,
    required this.mName,
    this.image,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      mid: json['MID']?.toString() ?? '',
      mName: json['MName']?.toString() ?? '',
      image: _decodeImage(json['MemImage2']?.toString()),
    );
  }

  static Uint8List? _decodeImage(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      // Strip any data-uri prefix (e.g. "data:image/jpeg;base64,....").
      final normalized = raw.contains(',') ? raw.split(',').last : raw;
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }
}
