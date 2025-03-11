import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';

class YearlyStemsBranches {
  // 流年干支纪年 从出生的第二年开始算起，到120岁止，每隔1年算一次
  final EarthlyBranchName earthlyBranchName;
  final List<int> ages;

  YearlyStemsBranches({required this.earthlyBranchName, required this.ages});

  @override
  String toString() {
    // TODO: implement toString
    return "YearlyStemsBranches :${earthlyBranchName.title} $ages";
  }
}
