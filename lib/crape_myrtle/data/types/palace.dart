import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';

/// 命宫，身宫对象
class SoulAndBody {
  /// 命宫索引
  int soulIndex;

  /// 身宫索引
  int bodyIndex;

  /// 命宫天干
  HeavenlyStemName heavenlyStenName;

  /// 命宫地支
  EarthlyBranchName earthlyBranchName;

  SoulAndBody(
      {required this.soulIndex,
      required this.bodyIndex,
      required this.heavenlyStenName,
      required this.earthlyBranchName});
}

/// 宫位对象
class Palace {
  /// 宫位索引
  int index;

  /// 宫位名称
  PalaceName name;

  /// 是否身宫
  bool isBodyPalace;

  /// 是否来因宫
  bool isOriginalPalace;

  /// 宫位天干
  HeavenlyStemName heavenlySten;

  /// 宫位地支;
  EarthlyBranchName earthlyBranch;

  /// 主星
  List<FunctionalStar> majorStars;

  /// 辅星
  List<FunctionalStar> minorStars;

  /// 杂耀
  List<FunctionalStar> adjectiveStars;

  /// 长生12神
  StarName changShen12;

  /// 博士12神
  StarName boShi12;

  /// 流年将前12神
  StarName jiangQian12;

  /// 流年岁前12神
  StarName suiQian12;

  /// 大限
  Decadal decadal;

  /// 小限
  List<int> ages;

  /// 流年
  List<int> yearlies;

  Palace({
    required this.index,
    required this.name,
    required this.isBodyPalace,
    required this.isOriginalPalace,
    required this.heavenlySten,
    required this.earthlyBranch,
    required this.majorStars,
    required this.minorStars,
    required this.adjectiveStars,
    required this.changShen12,
    required this.boShi12,
    required this.jiangQian12,
    required this.suiQian12,
    required this.decadal,
    required this.ages,
    required this.yearlies,
  });
}

class SurroundedPalaces {
  /// 本宫
  IFunctionalPalace target;

  /// 对宫
  IFunctionalPalace opposite;

  /// 财帛位
  IFunctionalPalace wealth;

  /// 官禄位
  IFunctionalPalace career;

  SurroundedPalaces(
      {required this.target,
      required this.opposite,
      required this.wealth,
      required this.career});
}
