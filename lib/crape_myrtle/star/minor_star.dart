import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';

List<List<FunctionalStar>> getMinorStar(String solarDateStr, int timeIndex,
    [bool? fixLeap]) {
  var stars = initStars();
  final yearly = getHeavenlyStemAndEarthlyBranchSolarDate(
          solarDateStr, timeIndex, getConfig().yearDivide)
      .yearly;
  int monthIndex = fixLunarMonthIndex(solarDateStr, timeIndex, fixLeap);
  final zuoYouIndexMaps = getZuoYouIndex(monthIndex + 1);
  final changQuIndexMaps = getChangQuIndex(timeIndex);
  HeavenlyStemName heavenlyStemName = getMyHeavenlyStemNameFrom(yearly[0]);
  EarthlyBranchName earthlyBranchName = getMyEarthlyBranchNameFrom(yearly[1]);
  final kuiYueIndexMaps = getKuiYueIndex(heavenlyStemName);
  final huoLingIndexMaps = getHuoLingIndex(earthlyBranchName, timeIndex);
  final kongJieIndexMaps = getKongJieIndex(timeIndex);
  final luYangTuoMaMaps =
      getLuYangTuoMaIndex(heavenlyStemName, earthlyBranchName);

  int zuoIndex = zuoYouIndexMaps["zuoIndex"] ?? -1;
  int youIndex = zuoYouIndexMaps["youIndex"] ?? -1;
  int changIndex = changQuIndexMaps["changIndex"] ?? -1;
  int quIndex = changQuIndexMaps["quIndex"] ?? -1;
  int kuiIndex = kuiYueIndexMaps["kuiIndex"] ?? -1;
  int yueIndex = kuiYueIndexMaps["yueIndex"] ?? -1;
  int huoIndex = huoLingIndexMaps["huoIndex"] ?? -1;
  int lingIndex = huoLingIndexMaps["lingIndex"] ?? -1;
  int luIndex = luYangTuoMaMaps["luIndex"] ?? -1;
  int yangIndex = luYangTuoMaMaps["yangIndex"] ?? -1;
  int tuoIndex = luYangTuoMaMaps["tuoIndex"] ?? -1;
  int maIndex = luYangTuoMaMaps["maIndex"] ?? -1;
  int kongIndex = kongJieIndexMaps["kongIndex"] ?? -1;
  int jieIndex = kongJieIndexMaps["jieIndex"] ?? -1;

  // 左辅
  stars[zuoIndex].add(FunctionalStar(Star(
      name: getStarNameFrom('zuoFuMin'),
      type: StarType.soft,
      scope: Scope.origin,
      brightness: getBrightness(getStarNameFrom("zuoFuMin"), zuoIndex),
      mutagen: getMutagen(getStarNameFrom("zuoFuMin"), heavenlyStemName))));
  // 右弼
  stars[youIndex].add(FunctionalStar(Star(
      name: getStarNameFrom('youBiMin'),
      type: StarType.soft,
      scope: Scope.origin,
      brightness: getBrightness(getStarNameFrom("youBiMin"), zuoIndex),
      mutagen: getMutagen(getStarNameFrom('youBiMin'), heavenlyStemName))));
  // 文昌星
  final wenChangStar = getStarNameFrom('wenChangMin');
  stars[changIndex].add(FunctionalStar(Star(
      name: wenChangStar,
      type: StarType.soft,
      scope: Scope.origin,
      brightness: getBrightness(wenChangStar, changIndex),
      mutagen: getMutagen(wenChangStar, heavenlyStemName))));
  // 文曲星
  final wenQuStar = getStarNameFrom("wenQuMin");
  stars[quIndex].add(FunctionalStar(Star(
      name: wenQuStar,
      type: StarType.soft,
      scope: Scope.origin,
      brightness: getBrightness(wenQuStar, quIndex),
      mutagen: getMutagen(wenQuStar, heavenlyStemName))));

  // 天魁星
  final tianKuStar = getStarNameFrom('tianKuiMin');
  stars[kuiIndex].add(FunctionalStar(Star(
    name: tianKuStar,
    type: StarType.soft,
    scope: Scope.origin,
    brightness: getBrightness(tianKuStar, kuiIndex),
  )));
  // 天钺星
  final tianYueStar = getStarNameFrom('tianYueMin');
  stars[yueIndex].add(FunctionalStar(Star(
      name: tianYueStar,
      type: StarType.soft,
      scope: Scope.origin,
      brightness: getBrightness(tianYueStar, yueIndex))));
  // 禄存星
  final luCunStar = getStarNameFrom('luCunMin');
  stars[luIndex].add(FunctionalStar(Star(
      name: luCunStar,
      type: StarType.luCun,
      scope: Scope.origin,
      brightness: getBrightness(luCunStar, luIndex))));
  // 天马星
  final tianMaStar = getStarNameFrom('tianMaMin');
  stars[maIndex].add(FunctionalStar(Star(
      name: tianMaStar,
      type: StarType.tianMa,
      scope: Scope.origin,
      brightness: getBrightness(tianMaStar, maIndex))));
// 地空星
  final diKongStar = getStarNameFrom('diKongMin');
  stars[kongIndex].add(FunctionalStar(Star(
      name: diKongStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(diKongStar, kongIndex))));
  // 地劫
  final diJieStar = getStarNameFrom('diJieMin');
  stars[jieIndex].add(FunctionalStar(Star(
      name: diJieStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(diJieStar, jieIndex))));
  // 火星
  final huoXinStar = getStarNameFrom('huoXingMin');
  stars[huoIndex].add(FunctionalStar(Star(
      name: huoXinStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(huoXinStar, huoIndex))));
  // 玲星
  final lingStar = getStarNameFrom('lingXingMin');
  stars[lingIndex].add(FunctionalStar(Star(
      name: lingStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(lingStar, lingIndex))));
  // 擎羊
  final qingyangStar = getStarNameFrom("qingYangMin");
  stars[yangIndex].add(FunctionalStar(Star(
      name: qingyangStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(qingyangStar, yangIndex))));
  // 陀罗
  final tuoLuoStar = getStarNameFrom('tuoLuoMin');
  stars[tuoIndex].add(FunctionalStar(Star(
      name: tuoLuoStar,
      type: StarType.tough,
      scope: Scope.origin,
      brightness: getBrightness(tuoLuoStar, tuoIndex))));
  return stars;
}
