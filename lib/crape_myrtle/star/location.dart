import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/astro/palace.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/lunar_lite/utils/misc.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';
import 'package:lunar/lunar.dart';

/// 起紫微星诀算法
///
/// - 六五四三二，酉午亥辰丑，
/// - 局数除日数，商数宫前走；
/// - 若见数无余，便要起虎口，
/// - 日数小於局，还直宫中守。
///
/// 举例：
/// - 例一：27日出生木三局，以三除27，循环0次就可以整除，27➗3=9，从寅进9格，在戍安紫微。
/// - 例二：13日出生火六局，以六除13，最少需要加5才能整除， 18➗8=3，从寅进3格为辰，添加数为5（奇数），故要逆回五宫，在亥安紫微。
/// - 例三：6日出生土五局，以五除6，最少需要加4才能整除，10➗5=2，从寅进2格为卯，添加数为4（偶数），顺行4格为未，在未安紫微。
///
/// @param solarDateStr 公历日期 YYYY-MM-DD
/// @param timeIndex 时辰索引【0～12】
/// @param fixLeap 是否调整农历闰月（若该月不是闰月则不会生效）
/// @returns 紫微和天府星所在宫位索引
Map<String, int> getStartIndex(AstrolabeParams params) {
  var soulAndBody = getSoulAndBody(params);
  HeavenlyStemName heavenlyStemOfSoul = soulAndBody.heavenlyStenName;
  EarthlyBranchName earthlyBranchOfSoul = soulAndBody.earthlyBranchName;
  int lunarDay = solar2Lunar(params.solarDate).lunarDay;

  /// 如果已传入干支，则用传入干支起五行局
  /// 确定用于起五行局的地盘干支
  final baseHeavenlyStem = params.from?.heavenlyStem ?? heavenlyStemOfSoul;
  final baseEarthlyBranch = params.from?.earthlyBranch ?? earthlyBranchOfSoul;
  FiveElementsFormat fiveElements = getFiveElementClass(
    baseHeavenlyStem,
    baseEarthlyBranch,
  );

  int remainder = -1; // 余数
  int quotient; // 商
  int offset = -1; // 循环次数

  // 获取当月最大天数
  int maxDays = getTotalDaysOfLunarMonth(params.solarDate);
  // 如果timeIndex等于12说明是晚子时，需要加一天
  int day = params.timeIndex == 12 ? lunarDay + 1 : lunarDay;

  if (day > maxDays) {
    // 假如日期超过当月最大天数，说明跨月了，需要处理为合法日期
    day -= maxDays;
  }

  do {
    // 农历出生日（初一为1，以此类推）加上偏移量作为除数，以这个数处以五行局的数向下取整
    // 需要一直运算到余数为0为止
    offset++;

    int divisor = day + offset;

    quotient = (divisor ~/ fiveElements.value).floor();
    remainder = divisor % fiveElements.value;
  } while (remainder != 0);

  // 将商除以12取余数
  quotient %= 12;

  // 以商减一（因为需要从0开始）作为起始位置
  int ziweiIndex = quotient - 1;

  if (offset % 2 == 0) {
    // 若循环次数为偶数，则索引逆时针数到循环数
    ziweiIndex += offset;
  } else {
    // 若循环次数为偶数，则索引顺时针数到循环数
    ziweiIndex -= offset;
  }

  ziweiIndex = fixIndex(ziweiIndex);

  // 天府星位置与紫微星相对
  int tianfuIndex = fixIndex(12 - ziweiIndex);

  return {'ziweiIndex': ziweiIndex, 'tianfuIndex': tianfuIndex};
}

/// 按年干支计算禄存、擎羊，陀罗、天马的索引
///
/// 定禄存、羊、陀诀（按年干）
///
/// - 甲禄到寅宫，乙禄居卯府。
/// - 丙戊禄在巳，丁己禄在午。
/// - 庚禄定居申，辛禄酉上补。
/// - 壬禄亥中藏，癸禄居子户。
/// - 禄前羊刃当，禄后陀罗府。
///
/// 安天马（按年支），天马只会出现在四马地【寅申巳亥】
///
/// - 寅午戍流马在申，申子辰流马在寅。
/// - 巳酉丑流马在亥，亥卯未流马在巳。
///
/// @param heavenlyStemName 天干
/// @param earthlyBranchName 地支
/// @returns 禄存、擎羊，陀罗、天马的索引
Map<String, int> getLuYangTuoMaIndex(
  HeavenlyStemName heavenlyStemName,
  EarthlyBranchName earthlyBranchName,
) {
  int luIndex = -1; // 禄存索引
  int maIndex = 0; // 天马索引
  switch (earthlyBranchName) {
    case EarthlyBranchName.yinEarthly:
    case EarthlyBranchName.wuEarthly:
    case EarthlyBranchName.xuEarthly:
      maIndex = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
      break;
    case EarthlyBranchName.shenEarthly:
    case EarthlyBranchName.ziEarthly:
    case EarthlyBranchName.chenEarthly:
      maIndex = fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly);
      break;
    case EarthlyBranchName.siEarthly:
    case EarthlyBranchName.youEarthly:
    case EarthlyBranchName.chouEarthly:
      maIndex = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
      break;
    case EarthlyBranchName.haiEarthly:
    case EarthlyBranchName.maoEarthly:
    case EarthlyBranchName.weiEarthly:
      maIndex = fixEarthlyBranchIndex(EarthlyBranchName.siEarthly);
      break;
  }

  switch (heavenlyStemName) {
    case HeavenlyStemName.jiaHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly);
      break;
    case HeavenlyStemName.yiHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly);
      break;
    case HeavenlyStemName.bingHeavenly:
    case HeavenlyStemName.wuHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.siEarthly);
      break;
    case HeavenlyStemName.dingHeavenly:
    case HeavenlyStemName.jiHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly);
      break;
    case HeavenlyStemName.gengHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
      break;
    case HeavenlyStemName.xinHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.youEarthly);
      break;
    case HeavenlyStemName.renHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
      break;
    case HeavenlyStemName.guiHeavenly:
      luIndex = fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly);
      break;
  }
  return {
    'luIndex': luIndex,
    'maIndex': maIndex,
    'yangIndex': fixIndex(luIndex + 1),
    'tuoIndex': fixIndex(luIndex - 1),
  };
}

/// 获取天魁天钺所在宫位索引（按年干）
///
/// - 甲戊庚之年丑未
/// - 乙己之年子申
/// - 辛年午寅
/// - 壬癸之年卯巳
/// - 丙丁之年亥酉
///
/// @param heavenlyStemName 天干
/// @returns
Map<String, int> getKuiYueIndex(HeavenlyStemName heavenlyStemName) {
  int kuiIndex = -1;
  int yueIndex = -1;
  switch (heavenlyStemName) {
    case HeavenlyStemName.jiaHeavenly:
    case HeavenlyStemName.wuHeavenly:
    case HeavenlyStemName.gengHeavenly:
      kuiIndex = fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly);
      yueIndex = fixEarthlyBranchIndex(EarthlyBranchName.weiEarthly);
      break;
    case HeavenlyStemName.yiHeavenly:
    case HeavenlyStemName.jiHeavenly:
      kuiIndex = fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly);
      yueIndex = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
      break;
    case HeavenlyStemName.xinHeavenly:
      kuiIndex = fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly);
      yueIndex = fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly);
      break;
    case HeavenlyStemName.bingHeavenly:
    case HeavenlyStemName.dingHeavenly:
      kuiIndex = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
      yueIndex = fixEarthlyBranchIndex(EarthlyBranchName.youEarthly);
      break;
    case HeavenlyStemName.renHeavenly:
    case HeavenlyStemName.guiHeavenly:
      kuiIndex = fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly);
      yueIndex = fixEarthlyBranchIndex(EarthlyBranchName.siEarthly);
      break;
  }

  return {'kuiIndex': kuiIndex, 'yueIndex': yueIndex};
}

/// 获取左辅右弼的索引（按生月）
///
/// - 辰上顺正寻左辅
/// - 戌上逆正右弼当
///
/// 解释：
///
/// - 从辰顺数农历月份数是左辅的索引
/// - 从戌逆数农历月份数是右弼的索引
///
/// @param lunarMonth 农历月份
/// @returns 左辅、右弼索引
Map<String, int> getZuoYouIndex(int lunarMonth) {
  final zuoIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly) + (lunarMonth - 1),
  );
  final youIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) - (lunarMonth - 1),
  );
  return {"zuoIndex": zuoIndex, "youIndex": youIndex};
}

/// 获取文昌文曲的索引（按时支）
///
/// - 辰上顺时文曲位
/// - 戌上逆时觅文昌
///
/// 解释：
///
/// - 从辰顺数到时辰地支索引是文曲的索引
/// - 从戌逆数到时辰地支索引是文昌的索引
///
/// 由于时辰地支的索引即是时辰的序号，所以可以直接使用时辰的序号
///
/// @param timeIndex 时辰索引【0～12】
/// @returns 文昌、文曲索引
Map<String, int> getChangQuIndex(int timeIndex) {
  final changIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) - fixIndex(timeIndex),
  );
  final quIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly) + fixIndex(timeIndex),
  );
  return {"changIndex": changIndex, "quIndex": quIndex};
}

/// 获取日系星索引，包括
///
/// 三台，八座，恩光，天贵
///
/// - 安三台八座
///   - 由左辅之宫位起初一，顺行至生日安三台。
///   - 由右弼之宫位起初一，逆行至生日安八座。
///
/// - 安恩光天贵
///   - 由文昌之宫位起初一，顺行至生日再退一步起恩光。
///   - 由文曲之宫位起初一，顺行至生日再退一步起天贵。
///
/// @param solarDateStr 阳历日期
/// @param timeIndex 时辰索引【0～12】
/// @returns 三台，八座索引
Map<String, int> getDailyStarIndex(
  String solarDateStr,
  int timeIndex, [
  bool? fixLeap,
]) {
  final lunar = solar2Lunar(solarDateStr);
  final changQuIndex = getChangQuIndex(timeIndex);
  final dayIndex = fixeLunarDayIndex(lunar.lunarDay, timeIndex);
  final monthIndex = fixLunarMonthIndex(solarDateStr, timeIndex, fixLeap);
  final zuoYouIndex = getZuoYouIndex(monthIndex + 1);
  final zuoIndex = zuoYouIndex["zuoIndex"] ?? -1;
  final youIndex = zuoYouIndex["youIndex"] ?? -1;
  final quIndex = changQuIndex["quIndex"] ?? -1;
  final changIndex = changQuIndex["changIndex"] ?? -1;
  // var extra = 0;
  // if (fixLeap == true) {
  //   // 当lunarMonth 为闰月月份并且是后半月时，需要额外加1
  //   final year = LunarYear(lunar.lunarYear);
  //   final leapMonth = year.getLeapMonth();
  //   if (leapMonth > 0 && lunar.lunarMonth == leapMonth && lunar.lunarDay > 15) {
  //     extra = 1;
  //   }
  // }
  final sanTaiIndex = fixIndex(((zuoIndex + dayIndex) % 12));
  final baZuoIndex = fixIndex(((youIndex - dayIndex) % 12));
  final enguangIndex = fixIndex((changIndex + dayIndex) % 12 - 1);
  final tianGuiIndex = fixIndex((quIndex + dayIndex) % 12 - 1);

  return {
    "sanTaiIndex": sanTaiIndex,
    "baZuoIndex": baZuoIndex,
    "tianGuiIndex": tianGuiIndex,
    "enguangIndex": enguangIndex,
  };
}

/// 获取时系星耀索引，包括台辅，封诰
///
/// @param timeIndex 时辰序号【0～12】
/// @returns 台辅，封诰索引
Map<String, int> getTimelyStarIndex(int timeIndex) {
  final taiFuIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly) + fixIndex(timeIndex),
  );
  final fenggaoIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly) + fixIndex(timeIndex),
  );
  return {"taiFuIndex": taiFuIndex, "fenggaoIndex": fenggaoIndex};
}

/// 获取地空地劫的索引（按时支）
///
/// - 亥上子时顺安劫
/// - 逆回便是地空亡
///
/// 解释：
///
/// - 从亥顺数到时辰地支索引是地劫的索引
/// - 从亥逆数到时辰地支索引是地空的索引
///
/// 由于时辰地支的索引即是时辰的序号，所以可以直接使用时辰的序号
///
/// @param timeIndex 时辰索引【0～12】
/// @returns 地空、地劫索引
Map<String, int> getKongJieIndex(int timeIndex) {
  final fixedTimeIndex = fixIndex(timeIndex);
  final haiIndex = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
  final kongIndex = fixIndex(haiIndex - fixedTimeIndex);
  final jieIndex = fixIndex(haiIndex + fixedTimeIndex);
  return {"kongIndex": kongIndex, "jieIndex": jieIndex};
}

/// 获取火星铃星索引（按年支以及时支）
///
/// - 申子辰人寅戌扬
/// - 寅午戌人丑卯方
/// - 巳酉丑人卯戌位
/// - 亥卯未人酉戌房
///
/// 起火铃二耀先据出生年支，依口诀定火铃起子时位。
///
/// 例如壬辰年卯时生人，据[申子辰人寅戌扬]口诀，故火星在寅宫起子时，铃星在戌宫起子时，顺数至卯时，即火星在巳，铃星在丑。
///
/// @param earthlyBranchName 地支
/// @param timeIndex 时辰序号
/// @returns 火星、铃星索引
Map<String, int> getHuoLingIndex(
  EarthlyBranchName earthlyBranchName,
  int timeIndex,
) {
  var huoIndex = -1;
  var lingIndex = -1;
  final fixedTimeIndex = fixIndex(timeIndex);
  switch (earthlyBranchName) {
    case EarthlyBranchName.yinEarthly:
    case EarthlyBranchName.wuEarthly:
    case EarthlyBranchName.xuEarthly:
      huoIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly) + fixedTimeIndex;
      lingIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly) + fixedTimeIndex;
      break;
    case EarthlyBranchName.shenEarthly:
    case EarthlyBranchName.ziEarthly:
    case EarthlyBranchName.chenEarthly:
      huoIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly) + fixedTimeIndex;
      lingIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) + fixedTimeIndex;
      break;
    case EarthlyBranchName.siEarthly:
    case EarthlyBranchName.youEarthly:
    case EarthlyBranchName.chouEarthly:
      huoIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly) + fixedTimeIndex;
      lingIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) + fixedTimeIndex;
      break;
    case EarthlyBranchName.haiEarthly:
    case EarthlyBranchName.weiEarthly:
    case EarthlyBranchName.maoEarthly:
      huoIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.youEarthly) + fixedTimeIndex;
      lingIndex =
          fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) + fixedTimeIndex;
      break;
  }
  return {"huoIndex": fixIndex(huoIndex), "lingIndex": fixIndex(lingIndex)};
}

/// 获取红鸾天喜所在宫位索引
///
/// - 卯上起子逆数之
/// - 数到当生太岁支
/// - 坐守此宫红鸾位
/// - 对宫天喜不差移
///
/// @param earthlyBranchName 年支
/// @returns 红鸾、天喜索引
Map<String, int> getLuanXiIndex(EarthlyBranchName earthlyBranchName) {
  final hongLuanIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly) -
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  final tianXiIndex = fixIndex(hongLuanIndex + 6);
  return {"hongLuanIndex": hongLuanIndex, "tianXiIndex": tianXiIndex};
}

/// 安华盖
/// - 子辰申年在辰，丑巳酉年在丑
/// - 寅午戍年在戍，卯未亥年在未。
///
/// 安咸池
/// - 子辰申年在酉，丑巳酉年在午
/// - 寅午戍年在卯，卯未亥年在子。
///
/// @param earthlyBranchName 地支
/// @returns 华盖、咸池索引
Map<String, int> getHuaGaiXianChiIndex(EarthlyBranchName earthlyBranchName) {
  var hgIdx = -1;
  var xcIdx = -1;
  switch (earthlyBranchName) {
    case EarthlyBranchName.yinEarthly:
    case EarthlyBranchName.wuEarthly:
    case EarthlyBranchName.xuEarthly:
      hgIdx = fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly);
      xcIdx = fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly);
      break;
    case EarthlyBranchName.shenEarthly:
    case EarthlyBranchName.ziEarthly:
    case EarthlyBranchName.chenEarthly:
      hgIdx = fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly);
      xcIdx = fixEarthlyBranchIndex(EarthlyBranchName.youEarthly);
      break;
    case EarthlyBranchName.siEarthly:
    case EarthlyBranchName.youEarthly:
    case EarthlyBranchName.chouEarthly:
      hgIdx = fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly);
      xcIdx = fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly);
      break;
    case EarthlyBranchName.haiEarthly:
    case EarthlyBranchName.weiEarthly:
    case EarthlyBranchName.maoEarthly:
      hgIdx = fixEarthlyBranchIndex(EarthlyBranchName.weiEarthly);
      xcIdx = fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly);
      break;
  }

  return {"hgIdx": fixIndex(hgIdx), "xcIdx": fixIndex(xcIdx)};
}

/// 安孤辰寡宿
/// - 寅卯辰年安巳丑
/// - 巳午未年安申辰
/// - 申酉戍年安亥未
/// - 亥子丑年安寅戍。
///
/// @param earthlyBranchName 地支
/// @returns 孤辰、寡宿索引
Map<String, int> getGuGuaIndex(EarthlyBranchName earthlyBranchName) {
  var guIdx = -1;
  var guaIdx = -1;
  switch (earthlyBranchName) {
    case EarthlyBranchName.yinEarthly:
    case EarthlyBranchName.maoEarthly:
    case EarthlyBranchName.chenEarthly:
      guIdx = fixEarthlyBranchIndex(EarthlyBranchName.siEarthly);
      guaIdx = fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly);
      break;
    case EarthlyBranchName.siEarthly:
    case EarthlyBranchName.wuEarthly:
    case EarthlyBranchName.weiEarthly:
      guIdx = fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly);
      guaIdx = fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly);
      break;
    case EarthlyBranchName.shenEarthly:
    case EarthlyBranchName.youEarthly:
    case EarthlyBranchName.xuEarthly:
      guIdx = fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly);
      guaIdx = fixEarthlyBranchIndex(EarthlyBranchName.weiEarthly);
      break;
    case EarthlyBranchName.haiEarthly:
    case EarthlyBranchName.ziEarthly:
    case EarthlyBranchName.chouEarthly:
      guIdx = fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly);
      guaIdx = fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly);
      break;
  }
  return {"guChenIndex": fixIndex(guIdx), "guaSuIndex": fixIndex(guaIdx)};
}

/// 安劫杀诀 （年支）
/// 申子辰人蛇开口、亥卯未人猴速走
/// 寅午戌人猪面黑、巳酉丑人虎咆哮
/// @version 2.5.0
/// @param earthlyBranchName 地支
/// @returns 劫杀、诀索引
int getJieShaAdjIndex(EarthlyBranchName earthlyBranchName) {
  switch (earthlyBranchName) {
    case EarthlyBranchName.shenEarthly:
    case EarthlyBranchName.ziEarthly:
    case EarthlyBranchName.chenEarthly:
      return 3;
    case EarthlyBranchName.haiEarthly:
    case EarthlyBranchName.maoEarthly:
    case EarthlyBranchName.weiEarthly:
      return 6;
    case EarthlyBranchName.yinEarthly:
    case EarthlyBranchName.wuEarthly:
    case EarthlyBranchName.xuEarthly:
      return 9;
    case EarthlyBranchName.siEarthly:
    case EarthlyBranchName.youEarthly:
    case EarthlyBranchName.chouEarthly:
      return 0;
  }
}

/// 安大耗诀 年支
///  但用年支去对冲、阴阳移位过一宫
///   阳顺阴逆移其位、大耗原来不可逢
///   大耗安法，是在年支之对宫，前一位或后一位安星。阳支顺行前一位，阴支逆行后一位。
///   @version 2.5.0
///    @param earthlyBranchName 地支
///    @returns 大耗、诀索引
int getDaHaoIndex(EarthlyBranchName earthlyBranchName) {
  final index = earthlyBranches.indexOf(earthlyBranchName.key);
  final matchedEarhlyBranchName =
      [
        EarthlyBranchName.weiEarthly,
        EarthlyBranchName.wuEarthly,
        EarthlyBranchName.youEarthly,
        EarthlyBranchName.shenEarthly,
        EarthlyBranchName.haiEarthly,
        EarthlyBranchName.xuEarthly,
        EarthlyBranchName.chouEarthly,
        EarthlyBranchName.ziEarthly,
        EarthlyBranchName.maoEarthly,
        EarthlyBranchName.yinEarthly,
        EarthlyBranchName.siEarthly,
        EarthlyBranchName.chenEarthly,
      ][earthlyBranches.indexOf(earthlyBranchName.key)];
  return fixIndex(earthlyBranches.indexOf(matchedEarhlyBranchName.key) - 2);
}

/// 获取年系星的索引，包括
/// 咸池，华盖，孤辰，寡宿, 天厨，破碎，天才，天寿，蜚蠊, 龙池，凤阁，天哭，天虚，
/// 天官，天福
///
/// - 安天才天寿
///   - 天才由命宫起子，顺行至本生年支安之。天寿由身宫起子，顺行至本生年支安之。
///
/// - 安破碎
///   - 子午卯酉年安巳宫，寅申巳亥年安酉宫，辰戍丑未年安丑宫。
///
/// - 安天厨
///   - 甲丁食蛇口，乙戊辛马方。丙从鼠口得，己食于猴房。庚食虎头上，壬鸡癸猪堂。
///
/// - 安蜚蠊
///   - 子丑寅年在申酉戍，卯辰巳年在巳午未，午未申年在寅卯辰，酉戍亥年在亥子丑。
///
/// - 安龙池凤阁
///   - 龙池从辰宫起子，顺至本生年支安之。凤阁从戍宫起子，逆行至本生年支安之。
///
/// - 安天哭天虚
///   - 天哭天虚起午宫，午宫起子两分踪，哭逆行兮虚顺转，数到生年便停留。
///
/// - 安天官天福
///   - 甲喜羊鸡乙龙猴，丙年蛇鼠一窝谋。丁虎擒猪戊玉兔，
///   - 己鸡居然与虎俦。庚猪马辛鸡蛇走，壬犬马癸马蛇游。
///
/// - 安截路空亡（截空）
///   - 甲己之年申酉，乙庚之年午未，
///   - 丙辛之年辰巳，丁壬之年寅卯，
///   - 戊癸之年子丑。
///
/// - 安天空
///   - 生年支顺数的前一位就是。
/// @param solarDate 阳历日期
/// @param timeIndex 时辰序号
/// @param fixLeap 是否修复闰月，假如当月不是闰月则不生效
Map<String, int> getYearlyStarIndex(AstrolabeParams params) {
  final config = getConfig();
  final heavenlyStemEarthlyBranch = getHeavenlyStemAndEarthlyBranchSolarDate(
    params.solarDate,
    params.timeIndex,
    config.horoscopeDivide,
  );
  final soulAndBody = getSoulAndBody(params);
  HeavenlyStemName heavenlyStem = getMyHeavenlyStemNameFrom(
    heavenlyStemEarthlyBranch.yearly[0] ?? "Heavenly",
  );
  EarthlyBranchName earthlyBranchName = getMyEarthlyBranchNameFrom(
    heavenlyStemEarthlyBranch.yearly[1] ?? "Earthly",
  );
  Map<String, int> huaXuanMaps = getHuaGaiXianChiIndex(earthlyBranchName);
  Map<String, int> guGuaMaps = getGuGuaIndex(earthlyBranchName);
  int huaGaiIndex = huaXuanMaps["hgIdx"] ?? -1;
  int xianChiIndex = huaXuanMaps["xcIdx"] ?? -1;
  int guChenIndex = guGuaMaps["guChenIndex"] ?? -1;
  int guasuIndex = guGuaMaps["guaSuIndex"] ?? -1;
  int tianCaiIndex = fixIndex(
    soulAndBody.soulIndex + earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int tianShouIndex = fixIndex(
    soulAndBody.bodyIndex + earthlyBranches.indexOf(earthlyBranchName.key),
  );

  final index = heavenlyStems.indexOf(heavenlyStem.key);
  String tianEarthBranch =
      [
        siEarthly,
        wuEarthly,
        ziEarthly,
        siEarthly,
        wuEarthly,
        shenEarthly,
        yinEarthly,
        wuEarthly,
        youEarthly,
        haiEarthly,
      ][index];
  int tianChuIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(tianEarthBranch)),
  );
  int pusuiEarthBranchIndex =
      earthlyBranches.indexOf(earthlyBranchName.key) % 3;
  String posuiEarthBranch =
      [siEarthly, chouEarthly, youEarthly][pusuiEarthBranchIndex];
  int posuiIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(posuiEarthBranch)),
  );

  int feilianbranchIndex = earthlyBranches.indexOf(earthlyBranchName.key);
  String feilianBranch =
      [
        shenEarthly,
        youEarthly,
        xuEarthly,
        siEarthly,
        wuEarthly,
        weiEarthly,
        yinEarthly,
        maoEarthly,
        chenEarthly,
        haiEarthly,
        ziEarthly,
        chouEarthly,
      ][feilianbranchIndex];
  int feiLianIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(feilianBranch)),
  );

  int longChinIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.chenEarthly) +
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int fenGeIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.xuEarthly) -
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int tianKuIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly) -
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int tianXuIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly) +
        earthlyBranches.indexOf(earthlyBranchName.key),
  );

  int tianGuanBranchIndex = heavenlyStems.indexOf(heavenlyStem.key);
  String tianGuanBranch =
      [
        weiEarthly,
        chenEarthly,
        siEarthly,
        yinEarthly,
        maoEarthly,
        youEarthly,
        haiEarthly,
        youEarthly,
        xuEarthly,
        wuEarthly,
      ][tianGuanBranchIndex];
  int tianGuanIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(tianGuanBranch)),
  );

  int tianFuBranchIndex = heavenlyStems.indexOf(heavenlyStem.key);
  String tianFuEarthlyBranch =
      [
        youEarthly,
        shenEarthly,
        ziEarthly,
        haiEarthly,
        maoEarthly,
        yinEarthly,
        wuEarthly,
        siEarthly,
        wuEarthly,
        siEarthly,
      ][tianFuBranchIndex];
  int tianFuIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(tianFuEarthlyBranch)),
  );

  int tianDeIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.youEarthly) +
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int yueDeIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.siEarthly) +
        earthlyBranches.indexOf(earthlyBranchName.key),
  );
  int tianKongIndex = fixIndex(
    fixEarthlyBranchIndex(
          getMyEarthlyBranchNameFrom(heavenlyStemEarthlyBranch.yearly[1]),
        ) +
        1,
  );

  int jieLuHeanvelyIndex = heavenlyStems.indexOf(heavenlyStem.key) % 5;
  String jieLuEarthlyBranch =
      [
        shenEarthly,
        wuEarthly,
        chenEarthly,
        yinEarthly,
        ziEarthly,
      ][jieLuHeanvelyIndex];
  int jieLuIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(jieLuEarthlyBranch)),
  );

  int kongWangEarthlyIndex = heavenlyStems.indexOf(heavenlyStem.key) % 5;
  String kongWangEarthlyBranch =
      [
        youEarthly,
        weiEarthly,
        siEarthly,
        maoEarthly,
        chouEarthly,
      ][kongWangEarthlyIndex];
  int kongWangIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(kongWangEarthlyBranch)),
  );

  int xunKongIndex = fixIndex(
    fixEarthlyBranchIndex(
          getMyEarthlyBranchNameFrom(heavenlyStemEarthlyBranch.yearly[1]),
        ) +
        heavenlyStems.indexOf(guiHeavenly) -
        heavenlyStems.indexOf(heavenlyStem.key) +
        1,
  );
  // 判断命主出生年年支阴阳属性，如果结果为0则为阳，否则为阴
  final yinyang = earthlyBranches.indexOf(earthlyBranchName.key) % 2;
  if (yinyang != xunKongIndex % 2) {
    xunKongIndex = fixIndex(xunKongIndex + 1);
  }

  // int tianShangIndex = fixIndex(
  //   palaces.indexOf("friendsPalace") + soulAndBody.soulIndex,
  // );
  // int tianShiIndex = fixIndex(
  //   palaces.indexOf("healthPalace") + soulAndBody.soulIndex,
  // );
  /// 中州派没有截路空亡，只有一颗截空星
  /// 生年阳干在阳宫，阴干在阴宫
  final jiekongIndex = yinyang == 0 ? jieLuIndex : kongWangIndex;
  final jieshaAdjIndex = getJieShaAdjIndex(earthlyBranchName);
  final nianjieIndex =
      getNianJieIndex(
        getMyEarthlyBranchNameFrom(heavenlyStemEarthlyBranch.yearly[1]),
      )['nianJieIndex'] ??
      -1;
  final daHaoIndex = getDaHaoIndex(earthlyBranchName);
  final genderYinYang = [GenderName.male, GenderName.female];
  final sameYinYang =
      yinyang == genderYinYang.indexOf(params.gender ?? GenderName.male);
  int tianShangIndex = fixIndex(
    palaces.indexOf(PalaceName.friendsPalace.key) + soulAndBody.soulIndex,
  );
  int tianShiIndex = fixIndex(
    palaces.indexOf(PalaceName.healthPalace.key) + soulAndBody.soulIndex,
  );
  if (config.algorithm == Algorithm.zhongZhou && !sameYinYang) {
    // 中州派的天使天伤与通行版本不一样
    // 天伤奴仆、天使疾厄、夹迁移宫最易寻得
    // 凡阳男阴女，皆依此诀，但若为阴男阳女，则改为天伤居疾厄、天使居奴仆。
    var temp = tianShiIndex;
    tianShiIndex = tianShangIndex;
    tianShangIndex = temp;
  }

  return {
    "xianChiIndex": xianChiIndex,
    "huaGaiIndex": huaGaiIndex,
    "guChenIndex": guChenIndex,
    "guaSuIndex": guasuIndex,
    "tianCaiIndex": tianCaiIndex,
    "tianShouIndex": tianShouIndex,
    "tianChuIndex": tianChuIndex,
    "poSuiIndex": posuiIndex,
    "feiLianIndex": feiLianIndex,
    "longChiIndex": longChinIndex,
    "fenGeIndex": fenGeIndex,
    "tianKuIndex": tianKuIndex,
    "tianXuIndex": tianXuIndex,
    "tianGuanIndex": tianGuanIndex,
    "tianFuIndex": tianFuIndex,
    "tianDeIndex": tianDeIndex,
    "yueDeIndex": yueDeIndex,
    "tianKongIndex": tianKongIndex,
    "jieLuIndex": jieLuIndex,
    "kongWangIndex": kongWangIndex,
    "xunKongIndex": xunKongIndex,
    "tianShangIndex": tianShangIndex,
    "tianShiIndex": tianShiIndex,
    'jieKongIndex': jiekongIndex,
    'jieShaAdjIndex': jieshaAdjIndex,
    'nianJieIndex': nianjieIndex,
    'daHaoAdjIndex': daHaoIndex,
  };
}

/// 获取年解的索引
///
/// - 年解（按年支）
///   - 解神从戌上起子，逆数至当生年太岁上是也
///
/// @param earthlyBranch 地支（年）
/// @returns 年解索引
Map<String, int> getNianJieIndex(EarthlyBranchName earthlyBranchName) {
  int earthlybranchIndex = earthlyBranches.indexOf(earthlyBranchName.key);

  String earthBranch =
      [
        xuEarthly,
        youEarthly,
        shenEarthly,
        weiEarthly,
        wuEarthly,
        siEarthly,
        chenEarthly,
        maoEarthly,
        yinEarthly,
        chouEarthly,
        ziEarthly,
        haiEarthly,
      ][earthlybranchIndex];
  int nianJieIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(earthBranch)),
  );
  return {"nianJieIndex": nianJieIndex};
}

/// 获取以月份索引为基准的星耀索引，包括解神，天姚，天刑，阴煞，天月，天巫
/// 解神分为年解和月解，月解作用更加直接快速，年解稍迟钝，且作用力没有月解那么大
///
/// - 月解（按生月）
///   - 正二在申三四在戍，五六在子七八在寅，九十月坐於辰宫，十一十二在午宫。
///
/// - 安天刑天姚（三合必见）
///   - 天刑从酉起正月，顺至生月便安之。天姚丑宫起正月，顺到生月即停留。
///
/// - 安阴煞
///   - 正七月在寅，二八月在子，三九月在戍，四十月在申，五十一在午，六十二在辰。
///
/// - 安天月
///   - 一犬二蛇三在龙，四虎五羊六兔宫。七猪八羊九在虎，十马冬犬腊寅中。
///
/// - 安天巫
///   - 正五九月在巳，二六十月在申，三七十一在寅，四八十二在亥。
///
/// @param solarDate 阳历日期
/// @param timeIndex 时辰序号
/// @param fixLeap 是否修复闰月，假如当月不是闰月则不生效
/// @returns
Map<String, int> getMonthlyStarIndex(
  String solarDateStr,
  int timeIndex, [
  bool? fixLeap,
]) {
  int monthIndex = fixLunarMonthIndex(solarDateStr, timeIndex, fixLeap);
  final earthlyBranch =
      [
        "shenEarthly",
        "xuEarthly",
        "ziEarthly",
        "yinEarthly",
        "chenEarthly",
        "wuEarthly",
      ][(monthIndex ~/ 2).floor()];
  int jieShenIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(earthlyBranch)),
  );

  int tianYaoIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.chouEarthly) + monthIndex,
  );
  int tianXingIndex = fixIndex(
    fixEarthlyBranchIndex(EarthlyBranchName.youEarthly) + monthIndex,
  );
  final yinShaEarthlyBranch =
      [
        "yinEarthly",
        "ziEarthly",
        "xuEarthly",
        "shenEarthly",
        "wuEarthly",
        "chenEarthly",
      ][monthIndex % 6];
  int yinShaIndex = fixIndex(
    fixEarthlyBranchIndex(getMyEarthlyBranchNameFrom(yinShaEarthlyBranch)),
  );

  int tianYueIndex = fixIndex(
    fixEarthlyBranchIndex(
      getMyEarthlyBranchNameFrom(
        [
          'xuEarthly',
          'siEarthly',
          'chenEarthly',
          'yinEarthly',
          'weiEarthly',
          'maoEarthly',
          'haiEarthly',
          'weiEarthly',
          'yinEarthly',
          'wuEarthly',
          'xuEarthly',
          'yinEarthly',
        ][monthIndex],
      ),
    ),
  );
  int tianWuIndex = fixIndex(
    fixEarthlyBranchIndex(
      getMyEarthlyBranchNameFrom(
        ['siEarthly', 'shenEarthly', 'yinEarthly', 'haiEarthly'][monthIndex %
            4],
      ),
    ),
  );

  return {
    'yueJieIndex': jieShenIndex,
    'tianYaoIndex': tianYaoIndex,
    'tianXingIndex': tianXingIndex,
    'yinShaIndex': yinShaIndex,
    'tianYueIndex': tianYueIndex,
    'tianWuIndex': tianWuIndex,
  };
}

/// 通过 大限/流年 天干获取流昌流曲
///
/// - 流昌起巳位	甲乙顺流去
/// - 不用四墓宫	日月同年岁
/// - 流曲起酉位	甲乙逆行踪
/// - 亦不用四墓	年日月相同
///
/// @param heavenlyStemName 天干
/// @returns 文昌、文曲索引
Map<String, int> getChangQuIndexByHeavenlyStem(
  HeavenlyStemName heavenlyStemName,
) {
  var changIndex = -1;
  var quIndex = -1;
  switch (heavenlyStemName) {
    case HeavenlyStemName.jiaHeavenly:
      changIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.siEarthly));
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.youEarthly));
    case HeavenlyStemName.yiHeavenly:
      changIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly));
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly));
    case HeavenlyStemName.bingHeavenly:
    case HeavenlyStemName.wuHeavenly:
      changIndex = fixIndex(
        fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly),
      );
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly));
    case HeavenlyStemName.dingHeavenly:
    case HeavenlyStemName.jiHeavenly:
      changIndex = fixIndex(
        fixEarthlyBranchIndex(EarthlyBranchName.youEarthly),
      );
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.siEarthly));
    case HeavenlyStemName.gengHeavenly:
      changIndex = fixIndex(
        fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly),
      );
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly));
    case HeavenlyStemName.xinHeavenly:
      changIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly));
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly));
    case HeavenlyStemName.renHeavenly:
      changIndex = fixIndex(
        fixEarthlyBranchIndex(EarthlyBranchName.yinEarthly),
      );
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly));
    case HeavenlyStemName.guiHeavenly:
      changIndex = fixIndex(
        fixEarthlyBranchIndex(EarthlyBranchName.maoEarthly),
      );
      quIndex = fixIndex(fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly));
  }
  return {"changIndex": changIndex, "quIndex": quIndex};
}
