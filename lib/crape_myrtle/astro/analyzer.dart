import 'package:get/get.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_astrolabe.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_surpalaces.dart';
import 'package:dart_iztro/crape_myrtle/data/stars.dart';
import 'package:dart_iztro/crape_myrtle/data/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';

/// 将二维数组所有的星转为name的一维数组
List<StarName> _concatStars(List<List<Star>> stars) {
  var names = stars.expand((row) => row).map((item) => item.name).toList();
  return names;
}

/// 是否包含所有的目标宫位
bool _includeAll(List<StarName> allStarsInPalace, List<StarName> targetStars) {
  var keys = targetStars.map((name) => name.starKey);
  return keys.every(
    (key) => allStarsInPalace.map((item) => item.starKey).contains(key),
  );
}

/// 是否不包含目标宫位
bool _excludeAll(List<StarName> allStarsInPalace, List<StarName> targetStars) {
  var keys = targetStars.map((name) => name.starKey);
  return keys.every(
    (key) => !allStarsInPalace.map((item) => item.starKey).contains(key),
  );
}

/// 宫位数组中是否包含目标宫位中的任意一个
bool _includeOneOf(
  List<StarName> allStarsInPalace,
  List<StarName> targetStars,
) {
  var keys = targetStars.map((name) => name.starKey);
  print("_inclideOneOf keys $keys allStarsInPalace $allStarsInPalace");
  return targetStars.any((star) => allStarsInPalace.contains(star));
}

/// 是否包含某个四化
bool _includeMutagen(List<Star> stars, Mutagen mutagen) {
  var key = mutagen.key;
  return stars.any((star) => !star.mutagen.isNull && star.mutagen?.key == key);
}

List<StarName> _getAllStarsInSurroundedPalaces(SurroundedPalaces surrounded) {
  List<List<Star>> stars = [];
  stars.add(surrounded.target.majorStars);
  stars.add(surrounded.target.minorStars);
  stars.add(surrounded.target.adjectiveStars);
  stars.add(surrounded.opposite.majorStars);
  stars.add(surrounded.opposite.minorStars);
  stars.add(surrounded.opposite.adjectiveStars);
  stars.add(surrounded.wealth.majorStars);
  stars.add(surrounded.wealth.minorStars);
  stars.add(surrounded.wealth.adjectiveStars);
  stars.add(surrounded.career.majorStars);
  stars.add(surrounded.career.minorStars);
  stars.add(surrounded.career.adjectiveStars);
  return _concatStars(stars);
}

IFunctionlSurpalaces getSurroundedPalaces(
  IFunctionalAstrolabe astrolabe,
  dynamic indexOfPalace,
) {
  final IFunctionalPalace? palace = getPalace(astrolabe, indexOfPalace);
  if (palace == null) {
    throw UnimplementedError('index or name is inccoreect');
  }
  // 获取目标宫位索引
  final palaceIndex = fixEarthlyBranchIndex(palace.earthlyBranch);
  // 获取对宫
  var palace6 = getPalace(astrolabe, fixIndex(palaceIndex + 6));
  // 获取官禄位
  var palace4 = getPalace(astrolabe, fixIndex(palaceIndex + 4));
  // 获取财帛位
  var palace8 = getPalace(astrolabe, fixIndex(palaceIndex + 8));
  if (palace6 == null || palace8 == null || palace4 == null) {
    throw Exception("index or name is inccourrect");
  }
  var surroundPalace = SurroundedPalaces(
    target: palace,
    opposite: palace6,
    wealth: palace8,
    career: palace4,
  );
  return FunctionalSurpalaces(surroundPalace);
}

/// 获取星盘的某一个宫位
///
/// @version v1.0.0
///
/// @param $ 星盘实例
/// @param indexOrName 宫位索引或者宫位名称
/// @returns 宫位实例
IFunctionalPalace? getPalace(
  IFunctionalAstrolabe astrolabe,
  dynamic indexOfPalace,
) {
  IFunctionalPalace? palace;
  if (indexOfPalace is int) {
    if (indexOfPalace != null) {
      if (indexOfPalace < 0 || indexOfPalace > 11) {
        throw Exception("invalid palace index");
      }
      palace = astrolabe.palaces.elementAt(indexOfPalace);
    }
  } else if (indexOfPalace is PalaceName) {
    palace = astrolabe.palaces.firstWhere((item) {
      if (item!.isOriginalPalace && indexOfPalace?.key == "originalPalace") {
        return true;
      }
      if (item!.isBodyPalace && indexOfPalace?.key == "bodyPalace") {
        return true;
      }
      if (item.name.key == indexOfPalace.key) {
        return true;
      }
      return false;
    });
  }

  palace?.setAstrolabe(astrolabe);
  return palace;
}

/// 判断某个宫位内是否有传入的星耀，要所有星耀都在宫位内才会返回true
///
/// @version v1.0.0
///
/// @param $ 宫位实例
/// @param stars 星耀
/// @returns true | false
bool hasStar(IFunctionalPalace palace, List<StarName> stars) {
  List<List<FunctionalStar>> allStars = [];
  allStars.add(palace.majorStars);
  allStars.add(palace.minorStars);
  allStars.add(palace.adjectiveStars);
  final allStarsInPalace = _concatStars(allStars);
  print("-------------------allStarsInPalace.length${allStarsInPalace.length}");
  for (StarName star in allStarsInPalace) {
    print("hasStar starname ${star.title}");
  }
  return _includeAll(allStarsInPalace, stars);
}

/// 判断指定宫位内是否有生年四化
///
/// @version v1.2.0
///
/// @param $ 宫位实例
/// @param mutagen 四化名称【禄｜权｜科｜忌】
/// @returns true | false
bool hasMutagenInPalace(IFunctionalPalace palace, Mutagen mutagen) {
  final allStarsInPalace = [...palace.majorStars, ...palace.minorStars];
  return _includeMutagen(allStarsInPalace, mutagen);
}

/// 判断指定宫位内是否没有生年四化
///
/// @version v1.2.0
///
/// @param $ 宫位实例
/// @param mutagen 四化名称【禄｜权｜科｜忌】
/// @returns true | false
bool notHaveMutagenInPalace(IFunctionalPalace palace, Mutagen mutagen) {
  return !hasMutagenInPalace(palace, mutagen);
}

/// 判断某个宫位内是否有传入的星耀，要所有星耀都不在宫位内才会返回true
///
/// @version v1.0.0
///
/// @param $ 宫位实例
/// @param stars 星耀
/// @returns true | false
bool notHaveStars(IFunctionalPalace palace, List<StarName> stars) {
  List<List<FunctionalStar>> allStars = [
    palace.majorStars,
    palace.minorStars,
    palace.adjectiveStars,
  ];
  final allStarsInPalace = _concatStars(allStars);
  return _excludeAll(allStarsInPalace, stars);
}

/// 判断某个宫位内是否有传入星耀的其中一个，只要命中一个就会返回true
///
/// @version v1.0.0
///
/// @param $ 宫位实例
/// @param stars 星耀
/// @returns true | false
bool hasOneOfStars(IFunctionalPalace palace, List<StarName> stars) {
  List<List<FunctionalStar>> allStars = [
    palace.majorStars,
    palace.minorStars,
    palace.adjectiveStars,
  ];

  final allStarsInPalace = _concatStars(allStars);
  return _includeOneOf(allStarsInPalace, stars);
}

/// 判断某一个宫位三方四正是否包含目标星耀，必须要全部包含才会返回true
///
/// @param $ 三方四正的实例
/// @param stars 星耀名称数组
/// @returns true | false
bool isSurroundedByStars(IFunctionlSurpalaces palace, List<StarName> stars) {
  final allStarsInPalace = _getAllStarsInSurroundedPalaces(palace);
  print("isSurroundedByStars allStarsInPalace $allStarsInPalace, stars $stars");
  return _includeAll(allStarsInPalace, stars);
}

/// 判断三方四正内是否有传入星耀的其中一个，只要命中一个就会返回true
///
/// @param $ 三方四正的实例
/// @param stars 星耀名称数组
/// @returns true | false
bool isSurroundedByOneOfStars(
  IFunctionlSurpalaces palace,
  List<StarName> stars,
) {
  final allStarsInPalace = _getAllStarsInSurroundedPalaces(palace);
  return _includeOneOf(allStarsInPalace, stars);
}

/// 判断某一个宫位三方四正是否不含目标星耀，必须要全部都不在三方四正内含才会返回true
///
/// @param $ 三方四正的实例
/// @param stars 星耀名称数组
/// @returns true | false
bool notSurroundedByStars(IFunctionlSurpalaces palace, List<StarName> stars) {
  final allStarsInPalace = _getAllStarsInSurroundedPalaces(palace);
  return _excludeAll(allStarsInPalace, stars);
}

List<StarName> mutagensToStars(
  HeavenlyStemName heavenlyStem,
  List<Mutagen> mutagens,
) {
  List<StarName> stars = [];
  List<StarName>? mutagenStars = getMutagensByHeavenlyStem(heavenlyStem);

  for (Mutagen withMutagen in mutagens) {
    int? mutagenIndex = mutagenArray.indexOf(withMutagen.key);

    if (mutagenIndex < mutagenStars.length) {
      stars.add(mutagenStars[mutagenIndex]);
    }
  }

  return stars;
}
