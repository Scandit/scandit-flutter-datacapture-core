enum LogoStyle {
  extended,
  minimal,
}

extension LogoStyleDeserializer on LogoStyle {
  static LogoStyle fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'minimal':
        return LogoStyle.minimal;
      case 'extended':
        return LogoStyle.extended;
      default:
        throw Exception("Missing LogoStyle for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case LogoStyle.minimal:
        return 'minimal';
      case LogoStyle.extended:
        return 'extended';
      default:
        throw Exception("Missing Json Value for '$this' logo style");
    }
  }
}
