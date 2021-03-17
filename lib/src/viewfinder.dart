/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import '../src/common.dart';
import '../src/defaults.dart';

abstract class Viewfinder implements Serializable {
  final String _type;

  Viewfinder(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class LaserlineViewfinder extends Viewfinder {
  DoubleWithUnit width = Defaults.laserlineViewfinderDefaults.width;
  Color enabledColor = Defaults.laserlineViewfinderDefaults.enabledColor;
  Color disabledColor = Defaults.laserlineViewfinderDefaults.disabledColor;

  LaserlineViewfinder() : super('laserline');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll(
        {'width': width.toMap(), 'enabledColor': enabledColor.jsonValue, 'disabledColor': disabledColor.jsonValue});
    return json;
  }
}

class RectangularViewfinder extends Viewfinder {
  SizeWithUnitAndAspect _sizeWithUnitAndAspect = Defaults.rectangularViewfinderDefaults.size;
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  Color color = Defaults.rectangularViewfinderDefaults.color;

  void setSize(SizeWithUnit size) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndHeight(size);
  }

  void setWidthAndAspectRatio(DoubleWithUnit width, double heightToWidthAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndAspectRatio(width, heightToWidthAspectRatio);
  }

  void setHeightAndAspectRatio(DoubleWithUnit height, double widthToHeightAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.heightAndAspectRatio(height, widthToHeightAspectRatio);
  }

  RectangularViewfinder() : super('rectangular');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'color': color.jsonValue, 'size': _sizeWithUnitAndAspect.toMap()});
    return json;
  }
}

class AimerViewfinder extends Viewfinder {
  Color frameColor = Defaults.aimerViewfinderDefaults.frameColor;
  Color dotColor = Defaults.aimerViewfinderDefaults.dotColor;

  AimerViewfinder() : super('aimer');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'frameColor': frameColor.jsonValue, 'dotColor': dotColor.jsonValue});
    return json;
  }
}
