import 'package:dart_iztro/crape_myrtle/astro/analyzer.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/data/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';

import '../translations/types/star_name.dart';

abstract class IFunctionlSurpalaces implements SurroundedPalaces {
  /// 判断某一个宫位三方四正是否包含目标星耀，必须要全部包含才会返回true
  /// @stars 星耀名称，可以包含 主星，辅星，杂星
  /// @return true / false
  bool have(List<StarName> stars);

  /// 判断某一个宫位三方四正是否不包含目标星耀，必须要全部都不在三方四正内含才会返回true
  /// @stars  星耀名称，可以包含 主星，辅星，杂星
  /// @return true / false
  bool notHave(List<StarName> stars);

  /// 判断三方四正内是否含有传入星耀的其中一个，只要命中一个就会返回true
  /// @stars  星耀名称，可以包含 主星，辅星，杂星
  /// @return true / false
  bool haveOneOf(List<StarName> stars);

  /// 判断某一个宫位三方四正是否有四化
  /// @mutagen 四化名称【禄｜权｜科｜忌】
  /// @return true / false
  bool haveMutagen(Mutagen mutagen);

  /// 判断某一个宫位三方四正是否没有四化
  /// @mutagen 四化名称【禄｜权｜科｜忌】
  /// @return true / false
  bool notHaveMutagen(Mutagen mutagen);
}

class FunctionalSurpalaces implements IFunctionlSurpalaces {
  @override
  late IFunctionalPalace career;

  @override
  late IFunctionalPalace opposite;

  @override
  late IFunctionalPalace target;

  @override
  late IFunctionalPalace wealth;

  FunctionalSurpalaces(SurroundedPalaces data) {
    career = data.career;
    opposite = data.opposite;
    target = data.target;
    wealth = data.wealth;
  }

  @override
  bool have(List<StarName> stars) {
    // TODO: implement have
    return isSurroundedByStars(this, stars);
  }

  @override
  bool haveMutagen(Mutagen mutagen) {
    // TODO: implement haveMutagen
    return target.hasMutagen(mutagen) ||
        opposite.hasMutagen(mutagen) ||
        wealth.hasMutagen(mutagen) ||
        career.hasMutagen(mutagen);
  }

  @override
  bool haveOneOf(List<StarName> stars) {
    // TODO: implement haveOneOf
    return isSurroundedByOneOfStars(this, stars);
  }

  @override
  bool notHave(List<StarName> stars) {
    // TODO: implement notHave
    return notSurroundedByStars(this, stars);
  }

  @override
  bool notHaveMutagen(Mutagen mutagen) {
    // TODO: implement notHaveMutagen
    return haveMutagen(mutagen);
  }
}
