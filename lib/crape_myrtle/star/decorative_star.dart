import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/astro/palace.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/data/earth_branches.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

/// 长生12神。
///
/// 阳男阴女顺行，阴男阳女逆行，安长生、沐浴、冠带、临官、帝旺、衰、病、死、墓、绝 、胎、养。
///
/// @param solarDateStr 阳历日期字符串
/// @param timeIndex 时辰索引【0～12】
/// @param gender 性别【男｜女】
/// @param fixLeap 是否修复闰月，假如当月不是闰月则不生效
/// @returns 长生12神从寅宫开始的顺序
List<StarName> getChangSheng12(
    String solarDateStr, int timeIndex, GenderName gender,
    [bool? fixLeap]) {
  List<StarName> changSheng12 = List.filled(12, StarName.tai);
  final yearly = getHeavenlyStemAndEarthlyBranchSolarDate(
          solarDateStr, timeIndex, getConfig().yearDivide)
      .yearly;
  final earhtlyBranchOfYear = getMyEarthlyBranchNameFrom(yearly[1]);
  // 获取命宫干支，需要通过命宫干支计算五行局
  final soulAndBody = getSoulAndBody(solarDateStr, timeIndex, fixLeap);
  // 获取五行局，通过五行局获取起运年龄
  final fiveElementClass = getFiveElementClass(
      soulAndBody.heavenlyStenName, soulAndBody.earthlyBranchName);

  const stars = [
    changSheng,
    muYu,
    guanDai,
    linGuan,
    diWang,
    shuai,
    bing,
    si,
    mu,
    jue,
    tai,
    yang,
  ];
  int startIndex = getChangSheng12StartIndex(fiveElementClass);
  for (int i = 0; i < stars.length; i++) {
    int index = 0;
    if (genderMap[gender.key] ==
        earthlyBranchesMap[earhtlyBranchOfYear.key]?["yinYang"]) {
      index = fixIndex(i + startIndex);
    } else {
      index = fixIndex(startIndex - i);
    }
    changSheng12[index] = getStarNameFrom(stars[i]);
  }

  return changSheng12;
}

/// 博士12神。
///
/// 从禄存起，阳男阴女顺行，阴男阳女逆行。安博士、力士、青龙、小耗、将军、奏书、飞廉、喜神、病符、大耗、伏兵、官府。
///
/// @param solarDateStr 阳历日期字符串
/// @param gender 性别【男｜女】
/// @returns 博士12神从寅宫开始的顺序
List<StarName> getBoShi12(String solarDateStr, GenderName gender) {
  final yearly = getHeavenlyStemAndEarthlyBranchSolarDate(
          solarDateStr, 0, getConfig().yearDivide)
      .yearly;
  final heavenlyStem = getMyHeavenlyStemNameFrom(yearly[0]);
  final earthlyBranch = getMyEarthlyBranchNameFrom(yearly[1]);

  const stars = [
    boShi,
    liShi,
    qingLong,
    xiaoHao,
    jiangJun,
    zouShu,
    flyLian,
    xiShen,
    bingFu,
    daHao,
    fuBing,
    guanFu,
  ];
  int luIndex =
      getLuYangTuoMaIndex(heavenlyStem, earthlyBranch)["luIndex"] ?? -1;
  List<StarName> boshi12 = List.filled(12, StarName.tai);
  for (int i = 0; i < stars.length; i++) {
    int idx = fixIndex(genderMap[gender.key] ==
            earthlyBranchesMap[earthlyBranch.key]?["yinYang"]
        ? luIndex + i
        : luIndex - i);
    boshi12[idx] = getStarNameFrom(stars[i]);
  }
  return boshi12;
}

/// 获取长生12神开始的宫位索引
///
/// - 水二局长生在申
/// - 木三局长生在亥
/// - 金四局长生在巳
/// - 土五局长生在申
/// - 火六局长生在寅，
/// @param fiveElementClassName 五行局
/// @returns 长生12神开始的索引
int getChangSheng12StartIndex(FiveElementsFormat fiveElementClass) {
  var startIndex = 0;
  switch (fiveElementClass.value) {
    case 2:
      startIndex = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
    case 3:
      startIndex = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
    case 4:
      startIndex = fixEarthlyBranchIndex(EarthlyBranchName.siEarthly);
    case 5:
      startIndex = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
    case 6:
      startIndex = fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly);
  }
  return startIndex;
}

/// 安流年将前诸星（按流年地支起将星）
/// - 寅午戍年将星午，申子辰年子将星，
/// - 巳酉丑将酉上驻，亥卯未将卯上停。
/// - 攀鞍岁驿并息神，华盖劫煞灾煞轻，
/// - 天煞指背咸池续，月煞亡神次第行。
///
/// @param earthlyBranchName 地支
/// @returns 将前诸星起始索引
int getJangQian12StartIndex(EarthlyBranchName earthlyBranchName) {
  int jqStartIndex = -1;
  if (["yinEarthly", "wuEarthly", "xuEarthly"]
      .contains(earthlyBranchName.key)) {
    jqStartIndex = fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly);
  } else if (['shenEarthly', 'ziEarthly', 'chenEarthly']
      .contains(earthlyBranchName.key)) {
    jqStartIndex = fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly);
  } else if (['siEarthly', 'youEarthly', 'chouEarthly']
      .contains(earthlyBranchName.key)) {
    jqStartIndex = fixEarthlyBranchIndex(EarthlyBranchName.youEarthly);
  } else if (['haiEarthly', 'maoEarthly', 'weiEarthly']
      .contains(earthlyBranchName.key)) {
    jqStartIndex = fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly);
  }
  return fixIndex(jqStartIndex);
}

/// 流年诸星。
///
/// - 流年岁前诸星
///   - 流年地支起岁建，岁前首先是晦气，
///   - 丧门贯索及官符，小耗大耗龙德继，
///   - 白虎天德连吊客，病符居后须当记。
///
/// - 安流年将前诸星（按流年地支起将星）
///   - 寅午戍年将星午，申子辰年子将星，
///   - 巳酉丑将酉上驻，亥卯未将卯上停。
///   - 攀鞍岁驿并息神，华盖劫煞灾煞轻，
///   - 天煞指背咸池续，月煞亡神次第行。
///
/// @param solarDateStr 阳历日期字符串
/// @returns 流年诸星从寅宫开始的顺序
Map<String, List<StarName>> getYearly12(String solarDateStr) {
  List<StarName> jiangqian12 = List.filled(12, StarName.tai);
  List<StarName> suiqian12 = List.filled(12, StarName.tai);
  // 流年神煞应该用立春为界，但为了满足不同流派的需求允许配置
  final yearly = getHeavenlyStemAndEarthlyBranchSolarDate(
          solarDateStr, 0, getConfig().horoscopeDivide)
      .yearly;

  List<String> ts12shen = [
    suiJian,
    huiQi,
    sangMen,
    guanSuo,
    gwanFu,
    xiaoHao,
    daHao,
    longDe,
    baiHu,
    tianDe,
    diaoKe,
    bingFu,
  ];

  for (int i = 0; i < ts12shen.length; i++) {
    int idx = fixIndex(
        fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(yearly[1])) + i);
    suiqian12[idx] = getStarNameFrom(ts12shen[i]);
  }

  List<String> jq12shen = [
    jiangXin,
    panAn,
    suiYi,
    xiiShen,
    huaGai,
    jieSha,
    zhaiSha,
    tianSha,
    zhiBei,
    xianChi,
    yueSha,
    wangShen,
  ];

  int jiangQian12StartIndex =
      getJangQian12StartIndex(getMyEarthlyBranchNameFrom(yearly[1]));
  for (int i = 0; i < jq12shen.length; i++) {
    int idx = fixIndex(jiangQian12StartIndex + i);
    jiangqian12[idx] = getStarNameFrom(jq12shen[i]);
  }
  return {"jiangqian12": jiangqian12, "suiqian12": suiqian12};
}
