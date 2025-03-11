import 'dart:math';

import 'package:lunar/calendar/Solar.dart';
import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/astro/yearly_stems_branches.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/data/earth_branches.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

/// 获取命宫以及身宫数据
///
/// 1. 定寅首
/// - 甲己年生起丙寅，乙庚年生起戊寅，
/// - 丙辛年生起庚寅，丁壬年生起壬寅，
/// - 戊癸年生起甲寅。
///
/// 2. 安命身宫诀
/// - 寅起正月，顺数至生月，逆数生时为命宫。
/// - 寅起正月，顺数至生月，顺数生时为身宫。
///
/// @param solarDate 公历日期，用公历日期比较方便，因为农历日期需要考虑闰月问题，如果得到的数据是农历，可以用 lunar2solar 方法得到公历日期
/// @param timeIndex 出生时索引
/// @param fixLeap 是否修正闰月，若修正，则闰月前15天按上月算，后15天按下月算
/// @returns SoulAndBody
SoulAndBody getSoulAndBody(String solarDate, int timeIndex, bool? fixLeap) {
  final heavenlyStemEarthlyBranch = getHeavenlyStemAndEarthlyBranchSolarDate(
      solarDate, timeIndex, getConfig().yearDivide);
  final earthlyBranchOfTime =
      getMyEarthlyBranchNameFrom(heavenlyStemEarthlyBranch.hourly[1]);
  final heavenlyStemOfYear =
      getMyHeavenlyStemNameFrom(heavenlyStemEarthlyBranch.yearly[0]);

  // 紫薇斗数以寅宫位第一个宫位
  final firstIndex = earthlyBranches.indexOf('yinEarthly');
  final monthIndex = fixLunarMonthIndex(solarDate, timeIndex, fixLeap);

  // 命宫索引，以寅宫为0，顺时针数到生月地支索引，再逆时针数到生时地支索引
  // 此处数到生月地支索引其实就是农历月份，所以不再计算生月地支索引
  final soulIndex =
      fixIndex(monthIndex - earthlyBranches.indexOf(earthlyBranchOfTime.key));
// 身宫索引，以寅宫为0，顺时针数到生月地支索引，再顺时针数到生时地支索引
  // 与命宫索引一样，不再赘述
  final bodyIndex =
      fixIndex(monthIndex + earthlyBranches.indexOf(earthlyBranchOfTime.key));

  // 用五虎盾取得寅宫的天干
  final startHevenlyStem = tigerRules[heavenlyStemOfYear.key];
  // 获取命宫天干索引，起始天干索引加上命宫的索引即是
  final heavenlyStemOfSoulIndex =
      fixIndex(heavenlyStems.indexOf(startHevenlyStem!) + soulIndex, max: 10);
  // 命宫的天干
  final heavenlyStemOfSoul =
      getMyHeavenlyStemNameFrom(heavenlyStems[heavenlyStemOfSoulIndex]);

  // 命宫的地支
  final earthlyBranchOfSoul = getMyEarthlyBranchNameFrom(
      earthlyBranches[fixIndex(soulIndex + firstIndex)]);

  return SoulAndBody(
      soulIndex: soulIndex,
      bodyIndex: bodyIndex,
      heavenlyStenName: heavenlyStemOfSoul,
      earthlyBranchName: earthlyBranchOfSoul);
}

/// 定五行局法（以命宫天干地支而定）
///
/// 纳音五行计算取数巧记口诀：
///
/// - 甲乙丙丁一到五，子丑午未一来数，
/// - 寅卯申酉二上走，辰巳戌亥三为足。
/// - 干支相加多减五，五行木金水火土。
///
/// 注解：
///
/// 1、五行取数：木1 金2 水3 火4 土5
///
///  天干取数：
///  - 甲乙 ——> 1
///  - 丙丁 ——> 2
///  - 戊己 ——> 3
///  - 庚辛 ——> 4
///  - 壬癸 ——> 5
///
///  地支取数：
///  - 子午丑未 ——> 1
///  - 寅申卯酉 ——> 2
///  - 辰戌巳亥 ——> 3
///
/// 2、计算方法：
///
///  干支数相加，超过5者减去5，以差论之。
///  - 若差为1则五行属木
///  - 若差为2则五行属金
///  - 若差为3则五行属水
///  - 若差为4则五行属火
///  - 若差为5则五行属土
///
/// 3、举例：
///  - 丙子：丙2 子1=3 ——> 水 ——> 水二局
///  - 辛未：辛4 未1=5 ——> 土 ——> 土五局
///  - 庚申：庚4 申2=6 ——> 6-5=1 ——> 木 ——> 木三局
///
/// @param heavenlyStemName 天干
/// @param earthlyBranchName 地支
/// @returns 水二局 ｜ 木三局 ｜ 金四局 ｜ 土五局 ｜ 火六局
FiveElementsFormat getFiveElementClass(
    HeavenlyStemName heavenlyStemName, EarthlyBranchName earthlyBranchName) {
  const fiveElementsTable = [
    'wood3rd',
    'metal4th',
    'water2nd',
    'fire6th',
    'earth5th'
  ];
  final heavenlyStemNumber =
      (heavenlyStems.indexOf(heavenlyStemName.key) / 2).floor() + 1;
  final earthlyBranchNumber =
      (fixIndex(earthlyBranches.indexOf(earthlyBranchName.key), max: 6) / 2)
              .floor() +
          1;
  var index = heavenlyStemNumber + earthlyBranchNumber;
  while (index > 5) {
    index -= 5;
  }
  return FiveElementsFormat.fiveElementFrom(fiveElementsTable[index - 1]);
}

/// 获取从寅宫开始的各个宫名
///Z
/// @param fromIndex 命宫索引
/// @returns 从寅宫开始的各个宫名
List<PalaceName> getPalaceNames(int fromIndex) {
  List<PalaceName> names = [];
  for (int i = 0; i < palaces.length; i++) {
    int idx = fixIndex(i - fromIndex);
    // names[i] = getMyPalaceNameFrom(palaces[idx]);
    names.add(getMyPalaceNameFrom(palaces[idx]));
  }
  return names;
}

/// 起大限
///
/// - 大限由命宫起，阳男阴女顺行；
/// - 阴男阳女逆行，每十年过一宫限。
///
/// @param solarDateStr 公历日期
/// @param timeIndex 出生时索引
/// @param gender 性别
/// @param fixLeap 是否修正闰月，若修正，则闰月前15天按上月算，后15天按下月算
/// @returns 从寅宫开始的大限年龄段
Map<String, dynamic>? getHoroscope(
    String solarDateStr, int timeIndex, GenderName gender, bool fixLeap) {
  List<Decadal> decadals = List.filled(
      12,
      Decadal(
          range: [0, 1],
          heavenlyStem: HeavenlyStemName.jiaHeavenly,
          earthlyBranch: EarthlyBranchName.ziEarthly));
  final genderKey = gender.key;
  final heavenlyStemAndEarthlyBranch = getHeavenlyStemAndEarthlyBranchSolarDate(
      solarDateStr, timeIndex, getConfig().yearDivide);
  final heavenlyStem =
      getMyHeavenlyStemNameFrom(heavenlyStemAndEarthlyBranch.yearly[0]).key ??
          "Heavenly";
  final earthlyBranch =
      getMyEarthlyBranchNameFrom(heavenlyStemAndEarthlyBranch.yearly[1]).key ??
          "Earthly";
  final soulAndBody = getSoulAndBody(solarDateStr, timeIndex, fixLeap);
  final fiveElementClass = getFiveElementClass(
      soulAndBody.heavenlyStenName, soulAndBody.earthlyBranchName);

  /// 用五虎遁获取大限起始天干
  final startHeavenlyStem = tigerRules[heavenlyStem]!;

  for (int i = 0; i < 12; i++) {
    final idx =
        genderMap[genderKey] == earthlyBranchesMap[earthlyBranch]?['yinYang']
            ? fixIndex(soulAndBody.soulIndex + i)
            : fixIndex(soulAndBody.soulIndex - i);
    final start = fiveElementClass.value + 10 * i;
    final heavenlyStemIndex =
        fixIndex(heavenlyStems.indexOf(startHeavenlyStem) + idx, max: 10);
    final earthlyBranchIndex =
        fixIndex(earthlyBranches.indexOf('yinEarthly') + idx);
    decadals[idx] = Decadal(
        range: [start, start + 9],
        heavenlyStem:
            getMyHeavenlyStemNameFrom(heavenlyStems[heavenlyStemIndex]),
        earthlyBranch:
            getMyEarthlyBranchNameFrom(earthlyBranches[earthlyBranchIndex]));
  }
  final ageIdx = getAgeIndex(getMyEarthlyBranchNameFrom(
      heavenlyStemAndEarthlyBranch.yearly[1] ?? "Earthly"));
  List<List<int>> ages = List.filled(12, [0]);
  for (int i = 0; i < 12; i++) {
    List<int> innerAge = [];
    for (int j = 0; j < 10; j++) {
      innerAge.add(12 * j + i + 1);
    }
    final idx =
        genderKey == 'male' ? fixIndex(ageIdx + i) : fixIndex(ageIdx - i);
    ages[idx] = innerAge;
  }
  // for 循环120次获取他的流年, 从出生日期的年份开始，一次递增一年，然后将年转为干支纪年法，
  final birthYear = int.parse(solarDateStr.split('-')[0]);
  final birthMonth = int.parse(solarDateStr.split('-')[1]);
  final birthDay = int.parse(solarDateStr.split('-')[2]);
  List<YearlyStemsBranches> yearlyStemsBranches = [];
  for (int i = 0; i < EarthlyBranchName.values.length; i++) {
    final idx =
        genderKey == 'male' ? fixIndex(ageIdx + i) : fixIndex(ageIdx - i);
    final branch = YearlyStemsBranches(
      earthlyBranchName: EarthlyBranchName.values[idx],
      ages: [],
    );
    yearlyStemsBranches.add(branch);
  }
  for (int i = birthYear; i < birthYear + 120; i++) {
    var solar = Solar.fromYmdHms(
        i, birthMonth, birthDay, max(timeIndex * 2 - 1, 0), 30, 0);
    var lunar = solar.getLunar();
    var yearlyZhi = getConfig().yearDivide == DivideType.normal
        ? lunar.getYearZhi()
        : lunar.getYearZhiByLiChun();
    final yearlyStemsBranch = yearlyStemsBranches.firstWhere(
        (e) => e.earthlyBranchName == getMyEarthlyBranchNameFrom(yearlyZhi));
    yearlyStemsBranch.ages.add(i - birthYear + 1);
  }
  print("yearlyStemsBranches $yearlyStemsBranches");
  final result = {
    "decades": decadals,
    "ages": ages,
    'yearlies': yearlyStemsBranches
  };
  return result;
}
