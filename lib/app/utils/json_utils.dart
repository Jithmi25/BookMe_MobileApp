class JsonUtils {
  const JsonUtils._();

  static DateTime? parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static String? writeDateTime(DateTime? value) {
    return value?.toIso8601String();
  }

  static List<String> parseStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList(growable: false);
    }

    return const <String>[];
  }
}
