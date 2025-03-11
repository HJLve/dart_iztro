import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';

List<List<FunctionalStar>> getHoroscopeStar(HeavenlyStemName heavenlyStem,
    EarthlyBranchName earthlyBranch, Scope scope) {
  var horoscoprStars = initStars();
  final kuiYueIndexMaps = getKuiYueIndex(heavenlyStem);
  final changQuIndexMaps = getChangQuIndexByHeavenlyStem(heavenlyStem);
  final luYangTuoMaIndexMaps = getLuYangTuoMaIndex(heavenlyStem, earthlyBranch);
  final luanXiIndexMaps = getLuanXiIndex(earthlyBranch);

  int kuiIndex = kuiYueIndexMaps["kuiIndex"] ?? -1;
  int yueIndex = kuiYueIndexMaps["yueIndex"] ?? -1;
  int changIndex = changQuIndexMaps["changIndex"] ?? -1;
  int quIndex = changQuIndexMaps["quIndex"] ?? -1;
  int luIndex = luYangTuoMaIndexMaps["luIndex"] ?? -1;
  int yangIndex = luYangTuoMaIndexMaps["yangIndex"] ?? -1;
  int tuoIndex = luYangTuoMaIndexMaps["tuoIndex"] ?? -1;
  int maIndex = luYangTuoMaIndexMaps["maIndex"] ?? -1;
  int hongLuanIndex = luanXiIndexMaps["hongLuanIndex"] ?? -1;
  int tianXiIndex = luanXiIndexMaps["tianXiIndex"] ?? -1;

  Map<Scope, Map<String, StarName>> translation = {
    Scope.origin: {
      'tiankui': StarName.tianKuiMin,
      'tianyue': StarName.tianYueMin,
      'wenchang': StarName.wenChangMin,
      'wenqu': StarName.wenQuMin,
      'lucun': StarName.luCunMin,
      'qingyang': StarName.qingYangMin,
      'tuoluo': StarName.tuoLuoMin,
      'tianma': StarName.tianMaMin,
      'hongluan': StarName.hongLuan,
      'tianxi': StarName.tianXi,
    },
    Scope.decadal: {
      'tiankui': StarName.yunKui,
      'tianyue': StarName.yunYue,
      'wenchang': StarName.yunChang,
      'wenqu': StarName.yunQu,
      'lucun': StarName.yunLu,
      'qingyang': StarName.yunYang,
      'tuoluo': StarName.yunTuo,
      'tianma': StarName.yunMa,
      'hongluan': StarName.yunLuan,
      'tianxi': StarName.yunXi,
    },
    Scope.yearly: {
      'tiankui': StarName.liuKui,
      'tianyue': StarName.liuYue,
      'wenchang': StarName.liuChang,
      'wenqu': StarName.liuQu,
      'lucun': StarName.liuLu,
      'qingyang': StarName.liuYang,
      'tuoluo': StarName.liuTuo,
      'tianma': StarName.liuMa,
      'hongluan': StarName.liuLuan,
      'tianxi': StarName.liuXi,
    },
    Scope.monthly: {
      'tiankui': StarName.yueKui,
      'tianyue': StarName.yueYue,
      'wenchang': StarName.yueChang,
      'wenqu': StarName.yueQu,
      'lucun': StarName.yueLu,
      'qingyang': StarName.yueYang,
      'tuoluo': StarName.yueTuo,
      'tianma': StarName.yueMa,
      'hongluan': StarName.yueLuan,
      'tianxi': StarName.yueXi,
    },
    Scope.daily: {
      'tiankui': StarName.riKui,
      'tianyue': StarName.riYue,
      'wenchang': StarName.riChang,
      'wenqu': StarName.riQu,
      'lucun': StarName.riLu,
      'qingyang': StarName.riYang,
      'tuoluo': StarName.riTuo,
      'tianma': StarName.riMa,
      'hongluan': StarName.riLuan,
      'tianxi': StarName.riXi,
    },
    Scope.hourly: {
      'tiankui': StarName.shiKui,
      'tianyue': StarName.shiYue,
      'wenchang': StarName.shiChang,
      'wenqu': StarName.shiQu,
      'lucun': StarName.shiLu,
      'qingyang': StarName.shiYang,
      'tuoluo': StarName.shiTuo,
      'tianma': StarName.shiMa,
      'hongluan': StarName.shiLuan,
      'tianxi': StarName.shiXi,
    },
  };

  if (scope == Scope.yearly) {
    int nianJieIndex = getNianJieIndex(earthlyBranch)["nianJieIndex"] ?? -1;
    horoscoprStars[nianJieIndex].add(FunctionalStar(Star(
        name: StarName.nianJie, type: StarType.helper, scope: Scope.yearly)));
    // } else {
    //   horoscoprStars[kuiIndex].add(FunctionalStar(
    //       Star(name: StarName.yunKui, type: StarType.soft, scope: scope)));
    //   horoscoprStars[yueIndex].add(FunctionalStar(
    //       Star(name: StarName.yunYue, type: StarType.soft, scope: scope)));
    //   horoscoprStars[changIndex].add(FunctionalStar(
    //       Star(name: StarName.yunChang, type: StarType.soft, scope: scope)));
    //   horoscoprStars[quIndex].add(FunctionalStar(
    //       Star(name: StarName.yunQu, type: StarType.soft, scope: scope)));
    //   horoscoprStars[luIndex].add(FunctionalStar(
    //       Star(name: StarName.yunLu, type: StarType.luCun, scope: scope)));
    //   horoscoprStars[yangIndex].add(FunctionalStar(
    //       Star(name: StarName.yunYang, type: StarType.tough, scope: scope)));
    //   horoscoprStars[tuoIndex].add(FunctionalStar(
    //       Star(name: StarName.yunTuo, type: StarType.tough, scope: scope)));
    //   horoscoprStars[maIndex].add(FunctionalStar(
    //       Star(name: StarName.yunMa, type: StarType.tianMa, scope: scope)));
    //   horoscoprStars[hongLuanIndex].add(FunctionalStar(
    //       Star(name: StarName.yunLuan, type: StarType.flower, scope: scope)));
    //   horoscoprStars[tianXiIndex].add(FunctionalStar(
    //       Star(name: StarName.yunXi, type: StarType.flower, scope: scope)));
  }
  horoscoprStars[kuiIndex].add(FunctionalStar(Star(
      name: translation[scope]!['tiankui']!,
      type: StarType.soft,
      scope: scope)));
  horoscoprStars[yueIndex].add(FunctionalStar(Star(
      name: translation[scope]!['tianyue']!,
      type: StarType.soft,
      scope: scope)));
  horoscoprStars[changIndex].add(FunctionalStar(Star(
      name: translation[scope]!['wenchang']!,
      type: StarType.soft,
      scope: scope)));
  horoscoprStars[quIndex].add(FunctionalStar(Star(
      name: translation[scope]!['wenqu']!, type: StarType.soft, scope: scope)));
  horoscoprStars[luIndex].add(FunctionalStar(Star(
      name: translation[scope]!['lucun']!,
      type: StarType.luCun,
      scope: scope)));
  horoscoprStars[yangIndex].add(FunctionalStar(Star(
      name: translation[scope]!['qingyang']!,
      type: StarType.tough,
      scope: scope)));
  horoscoprStars[tuoIndex].add(FunctionalStar(Star(
      name: translation[scope]!['tuoluo']!,
      type: StarType.tough,
      scope: scope)));
  horoscoprStars[maIndex].add(FunctionalStar(Star(
      name: translation[scope]!['tianma']!,
      type: StarType.tianMa,
      scope: scope)));
  horoscoprStars[hongLuanIndex].add(FunctionalStar(Star(
      name: translation[scope]!['hongluan']!,
      type: StarType.flower,
      scope: scope)));
  horoscoprStars[tianXiIndex].add(FunctionalStar(Star(
      name: translation[scope]!['tianxi']!,
      type: StarType.flower,
      scope: scope)));

  return horoscoprStars;
}
