import 'package:get/get.dart';

enum BrightnessEnum {
  miao,
  wang,
  de,
  li,
  ping,
  bu,
  xian,
}

extension BrightnessEx on BrightnessEnum {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

/// 将字符串转为宫位四化
BrightnessEnum getMyBrightnessNameFrom(String str) {
  var isContainStr = false;
  for (int i = 0; i < BrightnessEnum.values.length; i++) {
    final value = BrightnessEnum.values[i];
    if (value.key == str) {
      isContainStr = true;
      break;
    }
  }
  if (isContainStr) {
    return BrightnessEnum.values.firstWhere((e) => e.key == str,
        orElse: () => throw ArgumentError('invalid BrightnessEnum String'));
  } else {
    return BrightnessEnum.values.firstWhere((element) => element.title == str,
        orElse: () => throw ArgumentError('invalid BrightnessEnum String'));
  }
}
