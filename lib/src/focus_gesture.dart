import 'common.dart';

abstract class FocusGesture extends Serializable {}

class TapToFocus extends FocusGesture {
  TapToFocus();

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'tapToFocus'};
  }
}

extension FocusGestureDeserializer on FocusGesture {
  static FocusGesture? fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'tapToFocus':
        return TapToFocus();
      default:
        return null;
    }
  }
}
