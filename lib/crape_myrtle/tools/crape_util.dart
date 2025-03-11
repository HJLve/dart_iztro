import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/data/heavenly_stems.dart';
import 'package:dart_iztro/crape_myrtle/data/stars.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

List<StarName> getTargetMutagens(HeavenlyStemName heavenlySten) {
  final config = getConfig();
  List<StarName> result = [];
  if (mutagens != null && mutagens?[heavenlySten] != null) {
    result = mutagens?[heavenlySten] ?? [];
  } else {
    final stems = List<StarName>.from(heavenlyStemsMap[heavenlySten.key]
            ?["mutagen"]
        .map((e) => getStarNameFrom(e)));
    result = stems;
  }

  return result;
}

/// 配置星耀亮度
///
/// @param {StarName} starName 星耀名字
/// @param {number} index 所在宫位索引
BrightnessEnum? getBrightness(StarName starName, int index) {
  final star = starName.starKey;
  final config = getConfig();
  final targetBrightness =
      config.brightness?[starName] ?? starsInfo[star]?["brightness"];
  if (targetBrightness is List) {
    final key = targetBrightness[fixIndex(index)] as String;
    if (key.isNotEmpty) {
      return getMyBrightnessNameFrom(targetBrightness[fixIndex(index)]);
    }
  }
}

/// 获取四化
Mutagen? getMutagen(StarName starName, HeavenlyStemName heavenlyStemName) {
  final target = getTargetMutagens(heavenlyStemName);
  var index = target.indexOf(starName);
  if (index < mutagenArray.length && index != -1) {
    return getMyMutagenFrom(mutagenArray[index]);
  }
}

List<StarName> getMutagensByHeavenlyStem(HeavenlyStemName heavenlyStemName) {
  final target = getTargetMutagens(heavenlyStemName);
  return target;
}

Map<HeavenlyStemName, List<StarName>>? mutagens;
Map<StarName, List<BrightnessEnum>>? brightness;
DivideType yearDivide = DivideType.exact;
DivideType horoscopeDivide = DivideType.exact;

/// 获取全局配置信息
// Config getConfig() {
//   return Config(
//       mutagens: mutagens!,
//       brightness: brightness,
//       yearDivide: yearDivide,
//       horoscopeDivide: horoscopeDivide);
// }

/// 全局配置四化和亮度
/// * 由于key和value都有可能是不同语言传进来的，
///  * 所以需会将key和value转化为对应的i18n key。
void config(Config config) {
  if (config.mutagens != null) {
    mutagens = config.mutagens;
  }
  if (config.brightness != null) {
    brightness = config.brightness;
  }

  if (config.yearDivide != null) {
    yearDivide = config.yearDivide!;
  }
  if (config.horoscopeDivide != null) {
    horoscopeDivide = config.horoscopeDivide!;
  }
}

/// 因为宫位是从寅宫开始的排列的，所以需要将目标地支的序号减去寅的序号才能得到宫位的序号
///
/// @param {EarthlyBranchName} earthlyBranch 地支
/// @returns {number} 该地支对应的宫位索引序号
int earthlyBranchIndexToPalaceIndex(EarthlyBranchName earthlyBranchName) {
  final earthlyBranch = earthlyBranchName.key;
  final yin = EarthlyBranchName.yinEarthly.key;
  return fixIndex(
      earthlyBranches.indexOf(earthlyBranch) - earthlyBranches.indexOf(yin));
}

/// 处理地支相对于十二宫的索引，因为十二宫是以寅宫开始，所以下标需要减去地支寅的索引
///
/// @param {EarthlyBranchName} earthlyBranch 地支
/// @returns {number} Number(0~11)
int fixEarthlyBranchIndex(EarthlyBranchName earthlyBranchName) {
  return fixIndex(earthlyBranches.indexOf(earthlyBranchName.key) -
      earthlyBranches.indexOf(yinEarthly));
}

/// 调整农历月份的索引
///
/// 正月建寅（正月地支为寅），fixLeap为是否调整闰月情况
/// 若调整闰月，则闰月的前15天按上月算，后面天数按下月算
/// 比如 闰二月 时，fixLeap 为 true 时 闰二月十五(含)前
/// 的月份按二月算，之后的按三月算
///
/// @param {string} solarDateStr 阳历日期
/// @param {number} timeIndex 时辰序号
/// @param {boolean} fixLeap 是否调整闰月
/// @returns {number} 月份索引
int fixLunarMonthIndex(String solarDateStr, int timeIndex, bool? fixLeap) {
  final lunar = solar2Lunar(solarDateStr);
  final firstIndex = earthlyBranches.indexOf('yinEarthly');
  if (fixLeap != null) {
    final needToAdd =
        lunar.isLeap && fixLeap! && lunar.lunarDay > 15 && timeIndex != 12;
    return fixIndex(lunar.lunarMonth + 1 - firstIndex + (needToAdd ? 1 : 0));
  }
  return fixIndex(lunar.lunarMonth + 1 - firstIndex);
}

/// 获取农历日期【天】的索引，晚子时将加一天，所以如果是晚子时下标不需要减一
///
/// @param lunarDay 农历日期【天】
/// @param timeIndex 时辰索引
/// @returns {number} 农历日期【天】
int fixeLunarDayIndex(int lunarDay, int timeIndex) {
  return timeIndex >= 12 ? lunarDay : lunarDay - 1;
}

/// 将多个星耀数组合并到一起
///
/// [stars] 星耀数组
/// 返回 合并后的星耀
List<List<FunctionalStar>> mergeStars(List<List<List<FunctionalStar>>> stars) {
  List<List<FunctionalStar>> finalStars = initStars();

  for (var item in stars) {
    for (int index = 0; index < item.length; index++) {
      finalStars[index].addAll(item[index]);
    }
  }
  return finalStars;
}

/// 初始化一个星耀数组
List<List<FunctionalStar>> initStars() {
  return [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
}

/// 将时间的小时转化为时辰的索引
///
/// [hour] 当前时间的小时数
/// 返回 时辰的索引
int timeToIndex(int hour) {
  if (hour == 0) {
    // 00:00～01:00 为早子时
    return 0;
  }

  if (hour == 23) {
    // 23:00～00:00 为晚子时
    return 12;
  }

  return ((hour + 1) / 2).floor();
}

/// 起小限
///
/// - 小限一年一度逢，男顺女逆不相同，
/// - 寅午戍人辰上起，申子辰人自戍宫，
/// - 巳酉丑人未宫始，亥卯未人起丑宫。
///
/// @param {EarthlyBranchName} earthlyBranchName 地支
/// @returns {number} 小限开始的宫位索引
int getAgeIndex(EarthlyBranchName earthlyBranchName) {
  var ageIndex = -1;
  if (["yinEarthly", "wuEarthly", "xuEarthly"]
      .contains(earthlyBranchName.key)) {
    ageIndex = fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly);
  } else if (["shenEarthly", "ziEarthly", "chenEarthly"]
      .contains(earthlyBranchName.key)) {
    ageIndex = fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly);
  } else if (["siEarthly", "youEarthly", "chouEarthly"]
      .contains(earthlyBranchName.key)) {
    ageIndex = fixEarthlyBranchIndex(EarthlyBranchName.weiEarthly);
  } else if (["haiEarthly", "maoEarthly", "weiEarthly"]
      .contains(earthlyBranchName.key)) {
    ageIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly));
  }
  return ageIndex;
}
