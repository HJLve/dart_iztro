import 'package:get/get.dart';

/// 宫位
enum PalaceName {
  soulPalace, // 命宫
  bodyPalace, // 身宫
  siblingsPalace, // 兄弟宫
  spousePalace, // 夫妻宫
  childrenPalace, // 子女宫
  wealthPalace, // 财帛宫
  healthPalace, // 疾厄宫
  surfacePalace, // 迁移宫
  friendsPalace, // 仆役宫
  careerPalace, // 官禄宫
  propertyPalace, // 田宅宫
  spiritPalace, // 福德宫
  parentsPalace, // 父母宫
  originalPalace, // 来因宫
}

extension PalaceEx on PalaceName {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

PalaceName getMyPalaceNameFrom(String str) {
  var isContainStr = false;
  for (int i = 0; i < PalaceName.values.length; i++) {
    final value = PalaceName.values[i];
    if (value.key == str) {
      isContainStr = true;
      break;
    }
  }
  if (isContainStr) {
    return PalaceName.values.firstWhere((e) => e.key == str,
        orElse: () => throw ArgumentError('invalid palace name str'));
  } else {
    return PalaceName.values.firstWhere((e) => e.title == str,
        orElse: () => throw ArgumentError('invalid palace name string'));
  }
}
