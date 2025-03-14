import 'package:get/get.dart';

/// 地支
enum EarthlyBranchName {
  ziEarthly,
  chouEarthly,
  yinEarthly,
  maoEarthly,
  chenEarthly,
  siEarthly,
  wuEarthly,
  weiEarthly,
  shenEarthly,
  youEarthly,
  xuEarthly,
  haiEarthly,
}

extension EarthlyBranchNameEx on EarthlyBranchName {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

/// 将字符串转为宫位四化
EarthlyBranchName getMyEarthlyBranchNameFrom(String str) {
  var isContainStr = false;
  for (int i = 0; i < EarthlyBranchName.values.length; i++) {
    final value = EarthlyBranchName.values[i];
    if (value.key == str) {
      isContainStr = true;
      break;
    }
  }
  if (isContainStr) {
    return EarthlyBranchName.values.firstWhere(
      (e) => e.key == str,
      orElse: () => throw ArgumentError('invalid earhlyBranchName String'),
    );
  } else {
    return EarthlyBranchName.values.firstWhere(
      (element) => element.title == str,
      orElse: () => throw ArgumentError('invalid earhlyBranchName String'),
    );
  }
}
