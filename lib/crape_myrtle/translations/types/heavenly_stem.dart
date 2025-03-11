import 'package:get/get.dart';

/// 天干
enum HeavenlyStemName {
  jiaHeavenly,
  yiHeavenly,
  bingHeavenly,
  dingHeavenly,
  wuHeavenly,
  jiHeavenly,
  gengHeavenly,
  xinHeavenly,
  renHeavenly,
  guiHeavenly,
}

extension HeavenlyStemNameEx on HeavenlyStemName {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

HeavenlyStemName getMyHeavenlyStemNameFrom(String str) {
  var isContainStr = false;
  for (int i = 0; i < HeavenlyStemName.values.length; i++) {
    final value = HeavenlyStemName.values[i];
    if (value.key == str) {
      isContainStr = true;
      break;
    }
  }
  if (isContainStr) {
    return HeavenlyStemName.values.firstWhere((e) => e.key == str,
        orElse: () => throw ArgumentError('invalid str'));
  } else {
    return HeavenlyStemName.values.firstWhere((e) => e.title == str,
        orElse: () => throw ArgumentError('invalid Heavenly stem name string'));
  }
}
