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

  Config({
    required this.mutagens,
    required this.brightness,
    required this.yearDivide,
    required this.horoscopeDivide,
    required this.ageDivide,
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
  OptionType type;
  String dateStr;
  int timeIndex;
  GenderName gender;
  bool isLeapMonth;
  bool fixLeap;
  Config? config;

  Option({
    required this.type,
    required this.dateStr,
    required this.timeIndex,
    required this.gender,
    required this.isLeapMonth,
    required this.fixLeap,
    this.config,
  });
}
