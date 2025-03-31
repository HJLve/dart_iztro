import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/star/decorative_star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:web/helpers.dart';

/// 安杂耀
///
/// @param solarDateStr 阳历日期字符串
/// @param timeIndex 时辰索引【0～12】
/// @param fixLeap 是否修复闰月，假如当月不是闰月则不生效
/// @returns 38杂耀
List<List<FunctionalStar>> getAdjectiveStar(
  String solarDateStr,
  int timeIndex, [
  bool? fixLeap,
]) {
  final stars = initStars();
  final yearly =
      getHeavenlyStemAndEarthlyBranchSolarDate(
        solarDateStr,
        timeIndex,
        getConfig().yearDivide,
      ).yearly;
  final yearlyIndex = getYearlyStarIndex(solarDateStr, timeIndex, fixLeap);
  final monthlyIndex = getMonthlyStarIndex(solarDateStr, timeIndex, fixLeap);
  final dailyIndex = getDailyStarIndex(solarDateStr, timeIndex, fixLeap);
  final timelyIndex = getTimelyStarIndex(timeIndex);

  /// 'yueJieIndex': jieShenIndex,
  //     'tianYaoIndex': tianYaoIndex,
  //     'tianXingIndex': tianXingIndex,
  //     'yinShaIndex': yinShaIndex,
  //     'tianYueIndex': tianYueIndex,
  //     'tianWuIndex': tianWuIndex,
  int tianYaoIndex = monthlyIndex["tianYaoIndex"] ?? 0;
  int yueJieIndex = monthlyIndex["yueJieIndex"] ?? 0;
  int tianXingIndex = monthlyIndex["tianXingIndex"] ?? 0;
  int yinShaIndex = monthlyIndex["yinShaIndex"] ?? 0;
  int tianYueIndex = monthlyIndex["tianYueIndex"] ?? 0;
  int tianWuIndex = monthlyIndex["tianWuIndex"] ?? 0;

  //  "xianChiIndex": xianChiIndex,
  //     "huaGaiIndex": huaGaiIndex,
  //     "guChenIndex": guChenIndex,
  //     "guaSuIndex": guasuIndex,
  //     "tianCaiIndex": tianCaiIndex,
  //     "tianShouIndex": tianShouIndex,
  //     "tianChuIndex": tianChuIndex,
  //     "poSuiIndex": posuiIndex,
  //     "feiLianIndex": feiLianIndex,
  //     "longChiIndex": longChinIndex,
  //     "fenGeIndex": fenGeIndex,
  //     "tianKuIndex": tianKuIndex,
  //     "tianXuIndex": tianXuIndex,
  //     "tianGuanIndex": tianGuanIndex,
  //     "tianFuIndex": tianFuIndex,
  //     "tianDeIndex": tianDeIndex,
  //     "yueDeIndex": yueDeIndex,
  //     "tianKongIndex": tianKongIndex,
  //     "jieLuIndex": jieLuIndex,
  //     "kongWangIndex": kongWangIndex,
  //     "xunKongIndex": xunKongIndex,
  //     "tianShangIndex": tianShangIndex,
  //     "tianShiIndex": tianShiIndex,
  int xianChiIndex = yearlyIndex["xianChiIndex"] ?? 0;
  int huaGaiIndex = yearlyIndex["huaGaiIndex"] ?? 0;
  int guChenIndex = yearlyIndex["guChenIndex"] ?? 0;
  int guaSuIndex = yearlyIndex["guaSuIndex"] ?? 0;
  int tianCaiIndex = yearlyIndex["tianCaiIndex"] ?? 0;
  int tianShouIndex = yearlyIndex["tianShouIndex"] ?? 0;
  int tianChuIndex = yearlyIndex["tianChuIndex"] ?? 0;
  int poSuiIndex = yearlyIndex["poSuiIndex"] ?? 0;
  int feiLianIndex = yearlyIndex["feiLianIndex"] ?? 0;
  int longChiIndex = yearlyIndex["longChiIndex"] ?? 0;
  int fenGeIndex = yearlyIndex["fenGeIndex"] ?? 0;
  int tianKuIndex = yearlyIndex["tianKuIndex"] ?? 0;
  int tianXuIndex = yearlyIndex["tianXuIndex"] ?? 0;
  int tianGuanIndex = yearlyIndex["tianGuanIndex"] ?? 0;
  int tianFuIndex = yearlyIndex["tianFuIndex"] ?? 0;
  int tianDeIndex = yearlyIndex["tianDeIndex"] ?? 0;
  int yueDeIndex = yearlyIndex["yueDeIndex"] ?? 0;
  int tianKongIndex = yearlyIndex["tianKongIndex"] ?? 0;
  int jieLuIndex = yearlyIndex["jieLuIndex"] ?? 0;
  int kongWangIndex = yearlyIndex["kongWangIndex"] ?? 0;
  int xunKongIndex = yearlyIndex["xunKongIndex"] ?? 0;
  int tianShangIndex = yearlyIndex["tianShangIndex"] ?? 0;
  int tianShiIndex = yearlyIndex["tianShiIndex"] ?? 0;

  // final dailyIndex = getDailyStarIndex(solarDateStr, timeIndex);
  //"sanTaiIndex": sanTaiIndex,
  //     "baZuoIndex": baZuoIndex,
  //     "tianGuiIndex": tianGuiIndex,
  //     "enguangIndex": enguangIndex
  int sanTaiIndex = dailyIndex["sanTaiIndex"] ?? 0;
  int baZuoIndex = dailyIndex["baZuoIndex"] ?? 0;
  int tianGuiIndex = dailyIndex["tianGuiIndex"] ?? 0;
  int enguangIndex = dailyIndex["enguangIndex"] ?? 0;

  // final timelyIndex = getTimelyStarIndex(timeIndex);
  // "taiFuIndex": taiFuIndex, "fenggaoIndex": fenggaoIndex
  int taiFuIndex = timelyIndex["taiFuIndex"] ?? 0;
  int fenggaoIndex = timelyIndex["fenggaoIndex"] ?? 0;

  final luanXinMaps = getLuanXiIndex(getMyEarthlyBranchNameFrom(yearly[1]));
  int hongLuanIndex = luanXinMaps["hongLuanIndex"] ?? 0;
  int tianXiIndex = luanXinMaps["tianXiIndex"] ?? 0;

  final suiqian12 = getYearly12(solarDateStr)['suiqian12'] ?? [];
  final longdeIndex = suiqian12.indexOf(StarName.longDe);

  stars[hongLuanIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('hongLuan'),
        type: StarType.flower,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianXiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianXi'),
        type: StarType.flower,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianYaoIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianYao'),
        type: StarType.flower,
        scope: Scope.origin,
      ),
    ),
  );
  stars[xianChiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('xianChi'),
        type: StarType.flower,
        scope: Scope.origin,
      ),
    ),
  );
  stars[yueJieIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('jieShen'),
        type: StarType.helper,
        scope: Scope.origin,
      ),
    ),
  );
  stars[sanTaiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('sanTai'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[baZuoIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('baZuo'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[enguangIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('engGuang'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianGuiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianGui'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[longChiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('longChi'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[fenGeIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('fengGe'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianCaiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianCai'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianShouIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianShou'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[taiFuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('taiFu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[fenggaoIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('fengGao'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianWuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianWu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[huaGaiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('huaGai'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianGuanIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianGuan'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianFuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianFu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianChuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianChu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianYueIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianYue'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianDeIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianDe'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[yueDeIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('yueDe'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianKongIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianKong'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[xunKongIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('xunKong'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[jieLuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('jieLu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[kongWangIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('kongWang'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[guChenIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('guChen'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[guaSuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('guaSu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[feiLianIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('feiLian'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[poSuiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('poSui'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianXingIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianXing'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[yinShaIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('yinSha'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianKuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianKu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianXuIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianXu'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianShiIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianShi'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[tianShangIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('tianShang'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  stars[longdeIndex].add(
    FunctionalStar(
      Star(
        name: getStarNameFrom('longDe'),
        type: StarType.adjective,
        scope: Scope.origin,
      ),
    ),
  );
  return stars;
}
