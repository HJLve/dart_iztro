import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:get/get.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_astrolabe.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/astro/palace.dart';
import 'package:dart_iztro/crape_myrtle/astro/yearly_stems_branches.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/data/earth_branches.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/data/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/star/adjective_star.dart';
import 'package:dart_iztro/crape_myrtle/star/decorative_star.dart';
import 'package:dart_iztro/crape_myrtle/star/major_star.dart';
import 'package:dart_iztro/crape_myrtle/star/minor_star.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/lunar_lite/utils/misc.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

/// 定义四化所对应的天干所包含的星耀
Map<HeavenlyStemName, List<StarName>> _mutagens = {};

Map<StarName, List<BrightnessEnum>> _brightness = {};

/// 插件
List<Plugin> _plugins = [];

/// 年分界点参数，默认为立春分界。
///
/// @version v2.4.0
///
/// normal：正月初一分界
/// exact：立春分界
DivideType _yearDivide = DivideType.exact; // 默认
DivideType _horoscopeDivide = DivideType.exact;

/// 小限分割点，默认为生日
/// @version v2.4.5
/// normal：自然年分界
/// birthday：生日分界
AgeDivide _ageDivide = AgeDivide.normal; // 默认以自然年分割

DayDivide _dayDivide = DayDivide.forward; // 默认以自然日分割

/// 算法类型，默认为紫微斗数全书安星
/// @version v2.5.0
/// normal：紫微斗数全书安星
Algorithm _algorithm = Algorithm.normal; // 默认使用紫微斗数全书安星

/// 批量加载插件
///
/// @version v2.3.0
///
/// @param plugins 插件方法数组
void loadPlugins(List<Plugin> plugins) {
  _plugins.addAll(plugins);
}

/// 加载单个插件
void loadPlugin(Plugin plugin) {
  _plugins.add(plugin);
}

/// 全局配置四化和亮度
///
/// 由于key和value都有可能是不同语言传进来的，
/// 所以需会将key和value转化为对应的i18n key。
///
/// @version 2.3.0
///
/// @param {Config} param0 自定义配置
void config(Config config) {
  final mutagens = config.mutagens;
  if (mutagens != null) {
    mutagens.forEach((key, value) {
      _mutagens[key] = value.toList();
    });
  }

  final brightness = config.brightness;
  if (brightness != null) {
    brightness.forEach((key, value) {
      _brightness[key] = value.toList();
    });
  }
  if (config.yearDivide != null) {
    _yearDivide = config.yearDivide!;
  }
  if (config.horoscopeDivide != null) {
    _horoscopeDivide = config.horoscopeDivide!;
  }
  if (config.ageDivide != null) {
    _ageDivide = config.ageDivide!;
  }
  if (config.dayDivide != null) {
    _dayDivide = config.dayDivide!;
  }
  if (config.algorithm != null) {
    _algorithm = config.algorithm!;
  }
}

Config getConfig() {
  return Config(
    mutagens: _mutagens,
    brightness: _brightness,
    yearDivide: _yearDivide,
    horoscopeDivide: _horoscopeDivide,
    ageDivide: _ageDivide,
    algorithm: _algorithm,
    dayDivide: _dayDivide,
  );
}

/// 通过阳历获取星盘信息
///
/// @param solarDateStr 阳历日期【YYYY-M-D】
/// @param timeIndex 出生时辰序号【0~12】
/// @param gender 性别【男|女】
/// @param fixLeap 是否调整闰月情况【默认 true】，假入调整闰月，则闰月的前半个月算上个月，后半个月算下个月
/// @param language 输出语言
/// @returns 星盘信息
FunctionalAstrolabe bySolar(
  String solarDate,
  int timeIndex,
  GenderName gender, [
  bool fixLeap = true,
]) {
  List<IFunctionalPalace> palaces = [];
  final dayDivde = getConfig().dayDivide;
  var tIndex = timeIndex;
  if (dayDivde == DayDivide.current && tIndex >= 12) {
    // 如果当前时辰为晚子时并且晚子时算当天时，将时辰调整为当日子时
    tIndex = 0;
  }
  var heavenlyEarthlyBranch = getHeavenlyStemAndEarthlyBranchSolarDate(
    solarDate,
    tIndex,
    getConfig().yearDivide,
  );
  var earthlyBranchOfYear = getMyEarthlyBranchNameFrom(
    heavenlyEarthlyBranch.yearly[1],
  );
  var heavenlyStemOfYear = getMyHeavenlyStemNameFrom(
    heavenlyEarthlyBranch.yearly[0],
  );
  final params = AstrolabeParams(
    solarDate: solarDate,
    timeIndex: tIndex,
    fixLeap: fixLeap,
    gender: gender,
  );
  var soulAndBody = getSoulAndBody(params);
  final palaceNames = getPalaceNames(soulAndBody.soulIndex);
  final majorStars = getMajorStar(params);
  final minorStars = getMinorStar(solarDate, tIndex, fixLeap);
  final adjectiveStars = getAdjectiveStar(params);
  final changSheng12 = getChangSheng12(params);
  final boshi12 = getBoShi12(solarDate, gender);
  final yearly12Maps = getYearly12(
    solarDate,
  ); // {"jiangqian12": jiangqian12, "suiqian12": suiqian12};
  final jiangqian12 = yearly12Maps["jiangqian12"] ?? [];
  final suiqian12 = yearly12Maps["suiqian12"] ?? [];
  final horoscope = getHoroscope(params);
  final decadals = horoscope?["decades"];
  final ages = horoscope?["ages"];
  List<YearlyStemsBranches> yearlyStemsBranches = horoscope?["yearlies"];
  for (int i = 0; i < 12; i++) {
    final heavenlyStemOfPalace =
        heavenlyStems[fixIndex(
          heavenlyStems.indexOf(soulAndBody.heavenlyStenName.key) -
              soulAndBody.soulIndex +
              i,
          max: 10,
        )];
    final earthlyBranchOfPalace = earthlyBranches[fixIndex(2 + i)];
    bool isOriginalPalace =
        !["ziEarthly", "chouEarthly"].contains(earthlyBranchOfPalace) &&
        heavenlyStemOfPalace == heavenlyStemOfYear.key;
    // final filerMajorStars =
    //     majorStars[i] +
    //     minorStars[i]
    //         .where((e) => ['luCun', 'tianMa'].contains(e.type.key))
    //         .toList();
    final yealyAges =
        yearlyStemsBranches
            .firstWhere((e) => e.earthlyBranchName.key == earthlyBranchOfPalace)
            .ages;
    palaces.add(
      FunctionalPalace(
        Palace(
          index: i,
          name: palaceNames[i],
          isBodyPalace: soulAndBody.bodyIndex == i,
          isOriginalPalace: isOriginalPalace,
          heavenlySten: getMyHeavenlyStemNameFrom(heavenlyStemOfPalace),
          earthlyBranch: getMyEarthlyBranchNameFrom(earthlyBranchOfPalace),
          majorStars: majorStars[i],
          minorStars: minorStars[i],
          adjectiveStars: adjectiveStars[i],
          changShen12: changSheng12[i],
          boShi12: boshi12[i],
          jiangQian12: jiangqian12[i],
          suiQian12: suiqian12[i],
          decadal: decadals[i],
          ages: ages[i],
          yearlies: yealyAges,
        ),
      ),
    );
  }

  // 宫位从寅宫开始，而寅宫的索引位2，所以需要加2
  final earthlyBranchOfSoulPalace =
      earthlyBranches[fixIndex(soulAndBody.soulIndex + 2)];
  final earthlyBranchOfBoudyPalace =
      earthlyBranches[fixIndex(soulAndBody.bodyIndex + 2)];
  var soulStar = getStarNameFrom(
    earthlyBranchesMap[earthlyBranchOfSoulPalace]?["soul"],
  );
  final chineseDate = getHeavenlyStemAndEarthlyBranchSolarDate(
    solarDate,
    timeIndex,
    getConfig().yearDivide,
    monthOption: getConfig().horoscopeDivide,
  );
  final lunarDate = solar2Lunar(solarDate);
  final result = FunctionalAstrolabe(
    Astrolabe(
      gender: gender.title,
      solarDate: solarDate,
      lunarDate: lunarDate.toChString(true),
      chineseDate: chineseDate.toString(),
      rawDates: LunarDateObj(lunarDate: lunarDate, chineseDate: chineseDate),
      time: chineseTimes[timeIndex].tr,
      timeRage: timeRanges[timeIndex],
      sign: getSignBySolarDate(solarDate),
      zodiac: getZodiacBySolarDate(solarDate).tr,
      earthlyBranchOfSoulPalace: getMyEarthlyBranchNameFrom(
        earthlyBranchOfSoulPalace,
      ),
      earthlyBranchOfBodyPalace: getMyEarthlyBranchNameFrom(
        earthlyBranchOfBoudyPalace,
      ),
      soul: getStarNameFrom(
        earthlyBranchesMap[earthlyBranchOfSoulPalace]?["soul"],
      ),
      body: getStarNameFrom(
        earthlyBranchesMap[earthlyBranchOfYear.key]?["body"],
      ),
      fiveElementClass: getFiveElementClass(
        soulAndBody.heavenlyStenName,
        soulAndBody.earthlyBranchName,
      ),
      palaces: palaces,
      copyright: "copyright @2024",
    ),
  );

  return result;
}

/// 通过农历获取星盘信息
///
/// @param lunarDateStr 农历日期【YYYY-M-D】，例如2000年七月十七则传入 2000-7-17
/// @param timeIndex 出生时辰序号【0~12】
/// @param gender 性别【男|女】
/// @param isLeapMonth 是否闰月【默认 false】，当实际月份没有闰月时该参数不生效
/// @param fixLeap 是否调整闰月情况【默认 true】，假入调整闰月，则闰月的前半个月算上个月，后半个月算下个月
/// @param language 输出语言
/// @returns 星盘数据
FunctionalAstrolabe byLunar(
  String lunarDateStr,
  int timeIndex,
  GenderName gender, [
  bool isLeapMonth = false,
  bool fixLeap = true,
]) {
  final solarDate = lunar2Solar(lunarDateStr, isLeapMonth);
  return bySolar(solarDate.toString(), timeIndex, gender, fixLeap);
}

T rearrangeAstrolabe<T extends FunctionalAstrolabe>(
  ZhongZhouHeavenEarth from,
  T astrolabe,
  Option option,
) {
  final timeIndex = option.timeIndex;
  final fixLeap = option.fixLeap;

  // 以传入地支为命宫
  final params = AstrolabeParams(
    solarDate: astrolabe.solarDate,
    timeIndex: timeIndex,
    fixLeap: fixLeap,
    gender: getMyGenderFrom(astrolabe.gender),
    from: from,
  );
  final soulAndBody = getSoulAndBody(params);
  final fiveElementClass = getFiveElementClass(
    from.heavenlyStem,
    from.earthlyBranch,
  );
  final palaceNames = getPalaceNames(soulAndBody.soulIndex);
  final majorStars = getMajorStar(params);
  final changSheng12 = getChangSheng12(params);
  final horoscope = getHoroscope(params);
  astrolabe.fiveElementClass = fiveElementClass;
  for (int i = 0; i < astrolabe.palaces.length; i++) {
    final palace = astrolabe.palaces[i];
    palace.name = palaceNames[i];
    palace.majorStars = majorStars[i];
    palace.changShen12 = changSheng12[i];
    palace.decadal = horoscope?["decades"][i];
    palace.ages = horoscope?["ages"][i];
    palace.yearlies = horoscope?["yearlies"][i].ages;
    palace.isBodyPalace = soulAndBody.bodyIndex == i;
  }
  astrolabe.earthlyBranchOfSoulPalace =
      astrolabe.palace(PalaceName.soulPalace)!.earthlyBranch;
  return astrolabe;
}

/// 获取排盘信息。
///
/// @param param0 排盘参数
/// @returns 星盘信息
FunctionalAstrolabe withOptions(Option option) {
  if (option.config != null) {
    config(option.config!);
  }
  FunctionalAstrolabe result;
  if (option.type == OptionType.solar) {
    result = bySolar(
      option.dateStr,
      option.timeIndex,
      option.gender,
      option.fixLeap,
    );
  } else {
    result = byLunar(
      option.dateStr,
      option.timeIndex,
      option.gender,
      option.isLeapMonth,
      option.fixLeap,
    );
  }

  if (option.astroType != null) {
    switch (option.astroType) {
      case AstroType.earth:
        final bodyPalace = result.palace(PalaceName.bodyPalace);
        return rearrangeAstrolabe(
          ZhongZhouHeavenEarth(
            heavenlyStem: bodyPalace!.heavenlySten,
            earthlyBranch: bodyPalace.earthlyBranch,
          ),
          result,
          option,
        );
      case AstroType.human:
        final bodyPalace = result.palace(PalaceName.spiritPalace);
        return rearrangeAstrolabe(
          ZhongZhouHeavenEarth(
            heavenlyStem: bodyPalace!.heavenlySten,
            earthlyBranch: bodyPalace.earthlyBranch,
          ),
          result,
          option,
        );
      default:
        return result;
    }
  }
  return result;
}

/// 通过公历获取十二生肖
///
/// @version v1.2.1
///
/// @param solarDateStr 阳历日期【YYYY-M-D】
/// @param language 输出语言，默认为中文
/// @returns 十二生肖
String getZodiacBySolarDate(String solarDateStr) {
  final yearly =
      getHeavenlyStemAndEarthlyBranchSolarDate(
        solarDateStr,
        0,
        getConfig().yearDivide,
      ).yearly;
  return getZodiac(getMyEarthlyBranchNameFrom(yearly[1]));
}

/// 通过阳历获取星座
String getSignBySolarDate(String solarDateStr) {
  print("getSignBySolarDate $solarDateStr");
  final solarDate = DateTime.parse(solarDateStr);
  return getSign(solarDate);
}

/// 通过农历获取星座
String getSignByLunarDate(String lunarDateStr, bool? isLeapMonth) {
  final solarDate = lunar2Solar(lunarDateStr, isLeapMonth ?? false);
  return getSignBySolarDate(solarDate.toString());
}

/// 通过阳历获取命宫主星
///
/// @version v1.2.1
///
/// @param solarDateStr 阳历日期【YYYY-M-D】
/// @param timeIndex 出生时辰序号【0~12】
/// @param fixLeap 是否调整闰月情况【默认 true】，假入调整闰月，则闰月的前半个月算上个月，后半个月算下个月
/// @returns 命宫主星
String getMajorStarBySolarDate(
  String solarDateStr,
  int timeIndex, [
  bool fixLeap = true,
]) {
  print('solarDateStr $solarDateStr timeIndex $timeIndex fixLeap $fixLeap');
  final params = AstrolabeParams(
    solarDate: solarDateStr,
    timeIndex: timeIndex,
    fixLeap: fixLeap,
    gender: GenderName.male,
  );
  final bodyIndex = getSoulAndBody(params).bodyIndex;
  final majorStars = getMajorStar(params);
  final stars = majorStars[bodyIndex].where(
    (star) => star.type == StarType.major,
  );
  if (stars.isNotEmpty) {
    return stars.map((star) => star.name.title).join(',');
  }

  return majorStars[fixIndex(bodyIndex + 6)]
      .where((star) => star.type == StarType.major)
      .map((star) => star.name.title)
      .join(',');
}

/// 通过农历获取命宫主星
///
/// @version v1.2.1
///
/// @param lunarDateStr 农历日期【YYYY-M-D】，例如2000年七月十七则传入 2000-7-17
/// @param timeIndex 出生时辰序号【0~12】
/// @param isLeapMonth 是否闰月，如果该月没有闰月则此字段不生效
/// @param fixLeap 是否调整闰月情况【默认 true】，假入调整闰月，则闰月的前半个月算上个月，后半个月算下个月
/// @param language 输出语言，默认为中文
/// @returns 命宫主星
String getMajorStarByLunarDate(
  String lunarDateStr,
  int timeIndex, [
  bool isLeapMonth = false,
  bool fixLeap = true,
]) {
  final solarDate = lunar2Solar(lunarDateStr, isLeapMonth);
  return getMajorStarBySolarDate(solarDate.toString(), timeIndex, fixLeap);
}
