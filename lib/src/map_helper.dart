import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'common.dart';
import 'scandit_icon.dart';

T? parseValue<T>(Map<String, dynamic> map, String key, T? Function(dynamic value) parser) {
  if (map.containsKey(key) && map[key] != null) {
    final value = map[key];
    try {
      return parser(value);
    } catch (e) {
      log('Error parsing $T for key "$key" with value $value.', error: e);
    }
  }
  return null;
}

double? parseDouble(Map<String, dynamic> map, String key) {
  return parseValue<double>(map, key, (value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value);
    }
    throw FormatException('Unsupported type for double parsing: ${value.runtimeType}');
  });
}

Color? parseColor(Map<String, dynamic> map, String key) {
  return parseValue<Color>(map, key, (value) {
    return ColorDeserializer.fromRgbaHex(value);
  });
}

ScanditIcon? parseScanditIcon(Map<String, dynamic> map, String key) {
  return parseValue<ScanditIcon>(map, key, (value) {
    return ScanditIcon.fromJSON(value);
  });
}

Anchor? parseAnchor(Map<String, dynamic> map, String key) {
  return parseValue<Anchor>(map, key, (value) {
    return AnchorDeserializer.fromJSON(value);
  });
}

Anchor parseAnchorOrDefault(Map<String, dynamic> map, String key, Anchor defaultValue) {
  return parseValue<Anchor>(map, key, (value) {
        return AnchorDeserializer.fromJSON(value);
      }) ??
      defaultValue;
}

String? jsonEncodeOrNull(Serializable? object) {
  if (object == null) return null;
  return jsonEncode(object.toMap());
}
