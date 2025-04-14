import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/types.dart';
import 'package:flutter/foundation.dart';

/// 运限对象
///
/// @property
/// - index 所在宫位的索引
/// - heavenlyStem 该运限天干
/// - palaceNames 该运限的十二宫
/// - mutagen 四化星
/// - stars 流耀
class HoroscopeItem {
  /// 所在宫位的索引
  int index;

  /// 运限名称
  String name;

  /// 该运限天干
  HeavenlyStemName heavenlyStem;

  /// 该运限地支
  EarthlyBranchName earthlyBranch;

  /// 该运限的十二宫
  List<PalaceName> palaceNames;

  /// 四化星
  List<StarName> mutagen;

  /// 流耀
  List<List<FunctionalStar>>? stars;

  HoroscopeItem({
    required this.index,
    required this.name,
    required this.heavenlyStem,
    required this.earthlyBranch,
    required this.palaceNames,
    required this.mutagen,
    this.stars,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'HoroscopeItem { index: $index, name: $name, heavenlyStem: ${heavenlyStem.title}, earthlyBranch: ${earthlyBranch.title}, palaceNames: ${palaceNames.map((e) => e.title).toString()}, mutagen: ${mutagen.map((e) => e.title).toString()}, stars: ${stars} }';
  }
}

/// 大限
///
/// @property
/// - range 大限起止年龄 [起始年龄, 截止年龄]
/// - heavenlyStem 大限天干
/// - earthlyBranch 大限地支
class Decadal {
  /// 大限起止年龄 [起始年龄, 截止年龄]
  List<int> range;

  /// 大限天干
  HeavenlyStemName heavenlyStem;

  /// 大限地支
  EarthlyBranchName earthlyBranch;

  Decadal({
    required this.range,
    required this.heavenlyStem,
    required this.earthlyBranch,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'range $range, heavelyStem = ${heavenlyStem.title}, earthlyBranch ${earthlyBranch.title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Decadal &&
        listEquals(other.range, range) &&
        other.heavenlyStem == heavenlyStem &&
        other.earthlyBranch == earthlyBranch;
  }

  @override
  int get hashCode =>
      range.hashCode ^ heavenlyStem.hashCode ^ earthlyBranch.hashCode;
}

/// 运限
///
/// @property
/// - lunarDate 农历日期
/// - solarDate 阳历日期
/// - decadal 大限
/// - age 小限
/// - yearly 流年
/// - monthly 流月
/// - daily 流日
class Horoscope {
  /// 农历日期
  String lunarDate;

  /// 阳历日期
  String solarDate;

  /// 大限
  HoroscopeItem decadal;

  /// 小限
  AgeHoroscope age;

  /// 流年
  YearlyHoroscope yearly;

  /// 流月
  HoroscopeItem monthly;

  /// 流日
  HoroscopeItem daily;

  /// 流时
  HoroscopeItem hourly;

  Horoscope({
    required this.lunarDate,
    required this.solarDate,
    required this.decadal,
    required this.age,
    required this.yearly,
    required this.monthly,
    required this.daily,
    required this.hourly,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'Horoscope { lunarDate: $lunarDate, solarDate: $solarDate, decadal: $decadal, age: $age, yearly: $yearly, monthly: $monthly, daily: $daily, hourly: $hourly }';
  }
}

/// 小限
class AgeHoroscope extends HoroscopeItem {
  /** 虚岁 */
  int nominalAge;

  AgeHoroscope({
    required super.heavenlyStem,
    required super.earthlyBranch,
    required super.palaceNames,
    required super.mutagen,
    super.stars,
    required this.nominalAge,
    required super.index,
    required super.name,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'AgeHoroscope { heavenlyStem: ${heavenlyStem.title}, earthlyBranch: ${earthlyBranch.title}, palaceNames: $palaceNames, mutagen: $mutagen, stars: $stars, nominalAge: $nominalAge, index: $index, name: $name }';
  }
}

/// 流年
class YearlyHoroscope extends HoroscopeItem {
  List<StarName>? jiangQian12;
  List<StarName>? suiQian12;

  YearlyHoroscope({
    required super.heavenlyStem,
    required super.earthlyBranch,
    required super.palaceNames,
    required super.mutagen,
    super.stars,
    this.jiangQian12,
    this.suiQian12,
    required super.index,
    required super.name,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'YearlyHoroscope { heavenlyStem: ${heavenlyStem.title}, earthlyBranch: ${earthlyBranch.title}, palaceNames: $palaceNames, mutagen: $mutagen, stars: $stars, jiangQian12: $jiangQian12, suiQian12: $suiQian12, index: $index, name: $name }';
  }
}

class LunarDateObj {
  late LunarDate lunarDate;
  late HeavenlyStemAndEarthlyBranchDate chineseDate;

  LunarDateObj({required this.lunarDate, required this.chineseDate});
}

class Astrolabe {
  /// 性别
  String gender;

  /// 阳历日期Z
  String solarDate;

  /// 农历日期
  String lunarDate;

  /// 干支纪年日期
  String chineseDate;

  /// 原始日期数据，用于今后内部方法试用
  LunarDateObj rawDates;

  /// 时辰
  String time;

  /// 时辰对应的时间段
  String timeRage;

  /// 星座
  String sign;

  /// 生肖
  String zodiac;

  /// 命宫地支
  EarthlyBranchName earthlyBranchOfSoulPalace;

  /// 身宫地支
  EarthlyBranchName earthlyBranchOfBodyPalace;

  /// 命主
  StarName soul;

  /// 身主
  StarName body;

  /// 五行局
  FiveElementsFormat fiveElementClass;

  /// 十二宫数据
  List<IFunctionalPalace> palaces;

  /// 版权
  String copyright;

  Astrolabe({
    required this.gender,
    required this.solarDate,
    required this.lunarDate,
    required this.chineseDate,
    required this.rawDates,
    required this.time,
    required this.timeRage,
    required this.sign,
    required this.zodiac,
    required this.earthlyBranchOfSoulPalace,
    required this.earthlyBranchOfBodyPalace,
    required this.soul,
    required this.body,
    required this.fiveElementClass,
    required this.palaces,
    required this.copyright,
  });
}

enum OptionType {
  /// 阳历
  solar,

  /// 农历
  lunar,
}

enum DivideType { normal, exact }

enum AgeDivide {
  normal, // normal 代表自然年分界
  birthday, // birthday 代表生日分界
}

enum Algorithm {
  normal, // 默认以紫微斗数全书为基础安星
  zhongZhou, // 以中州派安星法为基础安星
}

enum AstroType {
  heaven, // 天盘
  earth, // 地盘
  human, // 人盘
}

class Config {
  /// 四化配置
  Map<HeavenlyStemName, List<StarName>>? mutagens;

  /// 星耀亮度配置
  Map<StarName, List<BrightnessEnum>>? brightness;

  /// 年分割点配置， normal 为正月初一分界， exact 代表立春分界
  DivideType? yearDivide;

  /// 运限分割点配置， normal 代表正月初一分界， exact 代表立春分界
  DivideType? horoscopeDivide;
  AgeDivide? ageDivide;
  Algorithm? algorithm;

  Config({
    required this.mutagens,
    required this.brightness,
    required this.yearDivide,
    required this.horoscopeDivide,
    required this.ageDivide,
    required this.algorithm,
  });
}

// Map<HeavenlyStemName, List<StarName>> _mutagens = {};

// class ConfigMutagens {
//   HeavenlyStemName heavenlyStemName;
//   List<StarName>? starNames;
//
//   ConfigMutagens({required this.heavenlyStemName, required this.starNames});
// }

// Map<StarName, List<Brightness>> _configBrightness = {};
// class ConfigBrightness {
//   StarName starName;
//   List<Brightness>? brightnesses;
//
//   ConfigBrightness({required this.starName, required this.brightnesses});
// }

/// 定义一个接口，表示插件函数的类型
typedef Plugin = ();

class Option {
  /// 日期类型 solar 为阳历， lūnār 为农历
  OptionType type;

  /// 阳历日期 格式为 yyyy-mm-dd
  String dateStr;

  /// 时辰索引，0为早子时，1为丑时，以此类推，12为晚子时
  int timeIndex;

  /// 性别
  GenderName gender;

  /// 是否为闰月 仅阴历类型可用
  bool isLeapMonth;

  /// 是否修正闰月 当修正闰月时，以农历15为界，15之前算当月，之后算下月
  bool fixLeap;

  /// 自定义配置
  Config? config;

  /// 星盘类型
  AstroType? astroType;

  Option({
    required this.type,
    required this.dateStr,
    required this.timeIndex,
    required this.gender,
    required this.isLeapMonth,
    required this.fixLeap,
    this.config,
    this.astroType,
  });
}

class ZhongZhouHeavenEarth {
  HeavenlyStemName heavenlyStem;
  EarthlyBranchName earthlyBranch;

  ZhongZhouHeavenEarth({
    required this.heavenlyStem,
    required this.earthlyBranch,
  });
}

class AstrolabeParams {
  /// 阳历日期 格式为 yyyy-mm-dd
  String solarDate;
  int timeIndex;
  bool fixLeap;
  GenderName? gender;

  /// 五行局起始干支， 用于中州派的地盘，人盘排法，不传该参数则即位天盘数据
  ZhongZhouHeavenEarth? from;

  AstrolabeParams({
    required this.solarDate,
    required this.timeIndex,
    required this.fixLeap,
    this.gender,
    this.from,
  });
}
