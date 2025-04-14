import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

/// 安主星，寅宫下标为0，若下标对应的数组为空数组则表示没有星耀
///
/// 安紫微诸星诀
/// - 紫微逆去天机星，隔一太阳武曲辰，
/// - 连接天同空二宫，廉贞居处方是真。
///
/// 安天府诸星诀
/// - 天府顺行有太阴，贪狼而后巨门临，
/// - 随来天相天梁继，七杀空三是破军。
///
/// @param params 通用排盘参数
/// @return 从寅宫开始每一个宫的星耀
List<List<FunctionalStar>> getMajorStar(AstrolabeParams params) {
  var indexMaps = getStartIndex(params);
  int ziweiIndex = indexMaps["ziweiIndex"] ?? -1;
  int tianFuIndex = indexMaps["tianfuIndex"] ?? -1;

  final heavenlyStemBranch = getHeavenlyStemAndEarthlyBranchSolarDate(
    params.solarDate,
    params.timeIndex,
    getConfig().yearDivide,
  );
  final stars = initStars();

  const ziweiGroup = [
    ziWeiMaj,
    tianJiMaj,
    '',
    taiYangMaj,
    wuQuMaj,
    tianTongMaj,
    '',
    '',
    lianZhenMaj,
  ];
  const tianfuGroup = [
    tianFuMaj,
    taiYinMaj,
    tanLangMaj,
    juMenMaj,
    tianXiangMaj,
    tianLiangMaj,
    qiShaMaj,
    '',
    '',
    '',
    poJunMaj,
  ];
  for (int i = 0; i < ziweiGroup.length; i++) {
    final element = ziweiGroup[i];
    if (element.isNotEmpty) {
      final star = FunctionalStar(
        Star(
          name: getStarNameFrom(element),
          type: StarType.major,
          scope: Scope.origin,
          brightness: getBrightness(
            getStarNameFrom(element),
            fixIndex(ziweiIndex - i),
          ),
          mutagen: getMutagen(
            getStarNameFrom(element),
            getMyHeavenlyStemNameFrom(heavenlyStemBranch.yearly[0]),
          ),
        ),
      );
      stars[fixIndex(ziweiIndex - i)].add(star);
    }
  }

  for (int i = 0; i < tianfuGroup.length; i++) {
    final element = tianfuGroup[i];
    if (element.isNotEmpty) {
      final star = FunctionalStar(
        Star(
          name: getStarNameFrom(element),
          type: StarType.major,
          scope: Scope.origin,
          brightness: getBrightness(
            getStarNameFrom(element),
            fixIndex(tianFuIndex + i),
          ),
          mutagen: getMutagen(
            getStarNameFrom(element),
            getMyHeavenlyStemNameFrom(heavenlyStemBranch.yearly[0]),
          ),
        ),
      );
      stars[fixIndex(tianFuIndex + i)].add(star);
    }
  }

  return stars;
}
