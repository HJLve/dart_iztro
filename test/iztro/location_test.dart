import 'package:dart_iztro/dart_iztro.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() {
    // 初始化翻译服务
    IztroTranslationService.init(initialLocale: 'zh_CN');
  });

  group('测试 获取星座位置的函数方法', () {
    testWidgets('init test app', (WidgetTester tester) async {
      Get.updateLocale(const Locale('zh', 'CN'));
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService.withAppTranslations(),
          locale: IztroTranslationService.currentLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          home: Container(),
        ),
      );
    });
  });

  group('test location funcation', () {
    test('santai bazuo for lunar month', () {
      final option = Option(
        type: OptionType.solar,
        dateStr: '1979-08-21',
        timeIndex: 6,
        gender: GenderName.male,
        isLeapMonth: false,
        fixLeap: true,
      );
      final result = withOptions(option);
      final santaiIndex = result.star(StarName.sanTai)?.palace()?.index;
      final bazuoIndex = result.star(StarName.baZuo)?.palace()?.index;
      expect(santaiIndex, 0);
      expect(bazuoIndex, 10);
    });

    test('xunkong for yin year', () {
      final result = withOptions(
        Option(
          type: OptionType.solar,
          dateStr: '1979-08-21',
          timeIndex: 6,
          gender: GenderName.male,
          isLeapMonth: false,
          fixLeap: true,
        ),
      );
      final xunKongIndex = result.star(StarName.xunKong)?.palace()?.index;
      expect(xunKongIndex, 11);
    });

    test('xunkong for yang year', () {
      final result = withOptions(
        Option(
          type: OptionType.solar,
          dateStr: '1980-08-21',
          timeIndex: 6,
          gender: GenderName.male,
          isLeapMonth: false,
          fixLeap: true,
        ),
      );
      final xunKongIndex = result.star(StarName.xunKong)?.palace()?.index;
      expect(xunKongIndex, 10);
    });

    test('getLuYangTuoMaIndex', () {
      final data = [
        {
          'heavenlyStem': guiHeavenly,
          'earthlyBranch': maoEarthly,
          'result': {
            'luIndex': 10,
            'maIndex': 3,
            'yangIndex': 11,
            'tuoIndex': 9,
          },
        },
        {
          'heavenlyStem': gengHeavenly,
          'earthlyBranch': yinEarthly,
          'result': {'luIndex': 6, 'maIndex': 6, 'yangIndex': 7, 'tuoIndex': 5},
        },
        {
          'heavenlyStem': xinHeavenly,
          'earthlyBranch': siEarthly,
          'result': {'luIndex': 7, 'maIndex': 9, 'yangIndex': 8, 'tuoIndex': 6},
        },
        {
          'heavenlyStem': renHeavenly,
          'earthlyBranch': wuEarthly,
          'result': {
            'luIndex': 9,
            'maIndex': 6,
            'yangIndex': 10,
            'tuoIndex': 8,
          },
        },
        {
          'heavenlyStem': guiHeavenly,
          'earthlyBranch': weiEarthly,
          'result': {
            'luIndex': 10,
            'maIndex': 3,
            'yangIndex': 11,
            'tuoIndex': 9,
          },
        },
        {
          'heavenlyStem': jiaHeavenly,
          'earthlyBranch': shenEarthly,
          'result': {
            'luIndex': 0,
            'maIndex': 0,
            'yangIndex': 1,
            'tuoIndex': 11,
          },
        },
        {
          'heavenlyStem': dingHeavenly,
          'earthlyBranch': haiEarthly,
          'result': {'luIndex': 4, 'maIndex': 3, 'yangIndex': 5, 'tuoIndex': 3},
        },
        {
          'heavenlyStem': yiHeavenly,
          'earthlyBranch': youEarthly,
          'result': {'luIndex': 1, 'maIndex': 9, 'yangIndex': 2, 'tuoIndex': 0},
        },
        {
          'heavenlyStem': wuHeavenly,
          'earthlyBranch': xuEarthly,
          'result': {'luIndex': 3, 'maIndex': 6, 'yangIndex': 4, 'tuoIndex': 2},
        },
        {
          'heavenlyStem': jiHeavenly,
          'earthlyBranch': weiEarthly,
          'result': {'luIndex': 4, 'maIndex': 3, 'yangIndex': 5, 'tuoIndex': 3},
        },
        {
          'heavenlyStem': bingHeavenly,
          'earthlyBranch': wuEarthly,
          'result': {'luIndex': 3, 'maIndex': 6, 'yangIndex': 4, 'tuoIndex': 2},
        },
      ];
      for (var value in data) {
        final heavenlyStem = value['heavenlyStem'] as String;
        final earthlyBranch = value['earthlyBranch'] as String;
        final result = value['result'] as Map<String, int>;
        final result1 = getLuYangTuoMaIndex(
          getMyHeavenlyStemNameFrom(heavenlyStem),
          getMyEarthlyBranchNameFrom(earthlyBranch),
        );
        expect(result, equals(result1));
      }
    });

    test('getKuiYueIndex()', () {
      final data = [
        {
          'heavenlyStem': renHeavenly,
          'result': {'kuiIndex': 1, 'yueIndex': 3},
        },
        {
          'heavenlyStem': guiHeavenly,
          'result': {'kuiIndex': 1, 'yueIndex': 3},
        },
        {
          'heavenlyStem': jiaHeavenly,
          'result': {'kuiIndex': 11, 'yueIndex': 5},
        },
        {
          'heavenlyStem': wuHeavenly,
          'result': {'kuiIndex': 11, 'yueIndex': 5},
        },
        {
          'heavenlyStem': gengHeavenly,
          'result': {'kuiIndex': 11, 'yueIndex': 5},
        },
        {
          'heavenlyStem': yiHeavenly,
          'result': {'kuiIndex': 10, 'yueIndex': 6},
        },
        {
          'heavenlyStem': jiHeavenly,
          'result': {'kuiIndex': 10, 'yueIndex': 6},
        },
        {
          'heavenlyStem': xinHeavenly,
          'result': {'kuiIndex': 4, 'yueIndex': 0},
        },
        {
          'heavenlyStem': bingHeavenly,
          'result': {'kuiIndex': 9, 'yueIndex': 7},
        },
        {
          'heavenlyStem': dingHeavenly,
          'result': {'kuiIndex': 9, 'yueIndex': 7},
        },
      ];
      for (var element in data) {
        final heavenlyStem = element['heavenlyStem'] as String;
        final result = element['result'] as Map<String, int>;
        final result1 = getKuiYueIndex(getMyHeavenlyStemNameFrom(heavenlyStem));
        expect(result, equals(result1));
      }
    });

    test('getZuoYouIndex()', () {
      final data = [
        {
          'lunarMonth': 1,
          'result': {'zuoIndex': 2, 'youIndex': 8},
        },
        {
          'lunarMonth': 2,
          'result': {'zuoIndex': 3, 'youIndex': 7},
        },
        {
          'lunarMonth': 3,
          'result': {'zuoIndex': 4, 'youIndex': 6},
        },
        {
          'lunarMonth': 4,
          'result': {'zuoIndex': 5, 'youIndex': 5},
        },
        {
          'lunarMonth': 5,
          'result': {'zuoIndex': 6, 'youIndex': 4},
        },
        {
          'lunarMonth': 6,
          'result': {'zuoIndex': 7, 'youIndex': 3},
        },
        {
          'lunarMonth': 7,
          'result': {'zuoIndex': 8, 'youIndex': 2},
        },
        {
          'lunarMonth': 8,
          'result': {'zuoIndex': 9, 'youIndex': 1},
        },
        {
          'lunarMonth': 10,
          'result': {'zuoIndex': 11, 'youIndex': 11},
        },
        {
          'lunarMonth': 11,
          'result': {'zuoIndex': 0, 'youIndex': 10},
        },
        {
          'lunarMonth': 12,
          'result': {'zuoIndex': 1, 'youIndex': 9},
        },
      ];

      for (var value in data) {
        final lunarMonth = value['lunarMonth'] as int;
        final result = value['result'] as Map<String, int>;
        final result1 = getZuoYouIndex(lunarMonth);
        expect(result1, equals(result));
      }
    });

    test('getChangQuIndex()', () {
      final data = [
        {'changIndex': 8, 'quIndex': 2},
        {'changIndex': 7, 'quIndex': 3},
        {'changIndex': 6, 'quIndex': 4},
        {'changIndex': 5, 'quIndex': 5},
        {'changIndex': 4, 'quIndex': 6},
        {'changIndex': 3, 'quIndex': 7},
        {'changIndex': 2, 'quIndex': 8},
        {'changIndex': 1, 'quIndex': 9},
        {'changIndex': 0, 'quIndex': 10},
        {'changIndex': 11, 'quIndex': 11},
        {'changIndex': 10, 'quIndex': 0},
        {'changIndex': 9, 'quIndex': 1},
      ];

      data.asMap().forEach((key, value) {
        expect(getChangQuIndex(key), equals(value));
      });
    });

    test('getKongJieIndex()', () {
      final data = [
        {'kongIndex': 9, 'jieIndex': 9},
        {'kongIndex': 8, 'jieIndex': 10},
        {'kongIndex': 7, 'jieIndex': 11},
        {'kongIndex': 6, 'jieIndex': 0},
        {'kongIndex': 5, 'jieIndex': 1},
        {'kongIndex': 4, 'jieIndex': 2},
        {'kongIndex': 3, 'jieIndex': 3},
        {'kongIndex': 2, 'jieIndex': 4},
        {'kongIndex': 1, 'jieIndex': 5},
        {'kongIndex': 0, 'jieIndex': 6},
        {'kongIndex': 11, 'jieIndex': 7},
        {'kongIndex': 10, 'jieIndex': 8},
      ];
      data.asMap().forEach((key, value) {
        expect(getKongJieIndex(key), value);
      });
    });

    test('getHuoLingIndex()', () {
      final data = [
        {
          'timeIndex': 0,
          'result': {'huoIndex': 11, 'lingIndex': 1},
        },
        {
          'timeIndex': 1,
          'result': {'huoIndex': 0, 'lingIndex': 2},
        },
        {
          'timeIndex': 2,
          'result': {'huoIndex': 1, 'lingIndex': 3},
        },
        {
          'timeIndex': 3,
          'result': {'huoIndex': 2, 'lingIndex': 4},
        },
        {
          'timeIndex': 4,
          'result': {'huoIndex': 3, 'lingIndex': 5},
        },
        {
          'timeIndex': 5,
          'result': {'huoIndex': 4, 'lingIndex': 6},
        },
        {
          'timeIndex': 6,
          'result': {'huoIndex': 5, 'lingIndex': 7},
        },
        {
          'timeIndex': 7,
          'result': {'huoIndex': 6, 'lingIndex': 8},
        },
        {
          'timeIndex': 8,
          'result': {'huoIndex': 7, 'lingIndex': 9},
        },
        {
          'timeIndex': 9,
          'result': {'huoIndex': 8, 'lingIndex': 10},
        },
        {
          'timeIndex': 10,
          'result': {'huoIndex': 9, 'lingIndex': 11},
        },
        {
          'timeIndex': 11,
          'result': {'huoIndex': 10, 'lingIndex': 0},
        },
      ];

      for (var value in data) {
        final timeIndex = value['timeIndex'] as int;
        final result = value['result'] as Map<String, int>;
        final result1 = getHuoLingIndex(EarthlyBranchName.wuEarthly, timeIndex);
        expect(
          getHuoLingIndex(EarthlyBranchName.wuEarthly, timeIndex),
          equals(result),
        );
      }

      final data1 = [
        {
          'earthlyBranch': yinEarthly,
          'result': {'huoIndex': 11, 'lingIndex': 1},
        },
        {
          'earthlyBranch': shenEarthly,
          'result': {'huoIndex': 0, 'lingIndex': 8},
        },
        {
          'earthlyBranch': ziEarthly,
          'result': {'huoIndex': 0, 'lingIndex': 8},
        },
        {
          'earthlyBranch': siEarthly,
          'result': {'huoIndex': 1, 'lingIndex': 8},
        },
        {
          'earthlyBranch': youEarthly,
          'result': {'huoIndex': 1, 'lingIndex': 8},
        },
        {
          'earthlyBranch': chouEarthly,
          'result': {'huoIndex': 1, 'lingIndex': 8},
        },
        {
          'earthlyBranch': haiEarthly,
          'result': {'huoIndex': 7, 'lingIndex': 8},
        },
        {
          'earthlyBranch': weiEarthly,
          'result': {'huoIndex': 7, 'lingIndex': 8},
        },
      ];
      for (var value1 in data1) {
        final earthlyBranch = value1['earthlyBranch'] as String;
        final result = value1['result'] as Map<String, int>;
        expect(
          getHuoLingIndex(getMyEarthlyBranchNameFrom(earthlyBranch), 0),
          equals(result),
        );
      }
    });

    test('getLuanXiIndex()', () {
      final data = [
        {
          'earthlyBranch': maoEarthly,
          'result': {'hongLuanIndex': 10, 'tianXiIndex': 4},
        },
        {
          'earthlyBranch': chenEarthly,
          'result': {'hongLuanIndex': 9, 'tianXiIndex': 3},
        },
        {
          'earthlyBranch': siEarthly,
          'result': {'hongLuanIndex': 8, 'tianXiIndex': 2},
        },
        {
          'earthlyBranch': wuEarthly,
          'result': {'hongLuanIndex': 7, 'tianXiIndex': 1},
        },
        {
          'earthlyBranch': weiEarthly,
          'result': {'hongLuanIndex': 6, 'tianXiIndex': 0},
        },
        {
          'earthlyBranch': shenEarthly,
          'result': {'hongLuanIndex': 5, 'tianXiIndex': 11},
        },
        {
          'earthlyBranch': youEarthly,
          'result': {'hongLuanIndex': 4, 'tianXiIndex': 10},
        },
        {
          'earthlyBranch': xuEarthly,
          'result': {'hongLuanIndex': 3, 'tianXiIndex': 9},
        },
        {
          'earthlyBranch': haiEarthly,
          'result': {'hongLuanIndex': 2, 'tianXiIndex': 8},
        },
        {
          'earthlyBranch': ziEarthly,
          'result': {'hongLuanIndex': 1, 'tianXiIndex': 7},
        },
        {
          'earthlyBranch': chouEarthly,
          'result': {'hongLuanIndex': 0, 'tianXiIndex': 6},
        },
        {
          'earthlyBranch': yinEarthly,
          'result': {'hongLuanIndex': 11, 'tianXiIndex': 5},
        },
      ];

      for (var value in data) {
        final earthlyBranch = value['earthlyBranch'] as String;
        final result = value['result'] as Map<String, int>;
        expect(
          getLuanXiIndex(getMyEarthlyBranchNameFrom(earthlyBranch)),
          equals(result),
        );
      }
    });

    test('getNianJieIndex()', () {
      final data = {
        ziEarthly: 8,
        chouEarthly: 7,
        yinEarthly: 6,
        maoEarthly: 5,
        chenEarthly: 4,
        siEarthly: 3,
        wuEarthly: 2,
        weiEarthly: 1,
        shenEarthly: 0,
        youEarthly: 11,
        xuEarthly: 10,
        haiEarthly: 9,
      };
      data.forEach((key, value) {
        final result =
            getNianJieIndex(getMyEarthlyBranchNameFrom(key))['nianJieIndex']
                as int;
        expect(result, value);
      });
    });

    test('getYearlyStarIndex() 2023-03-06', () {
      final result = getYearlyStarIndex('2023-03-06', 2, true);
      expect(
        result,
        equals({
          "xianChiIndex": 10,
          "huaGaiIndex": 5,
          "guChenIndex": 3,
          "guaSuIndex": 11,
          "tianCaiIndex": 2,
          "tianShouIndex": 6,
          "tianChuIndex": 9,
          "poSuiIndex": 3,
          "feiLianIndex": 3,
          "longChiIndex": 5,
          "fenGeIndex": 5,
          "tianKuIndex": 1,
          "tianXuIndex": 7,
          "tianGuanIndex": 4,
          "tianFuIndex": 3,
          "tianDeIndex": 10,
          "yueDeIndex": 6,
          "tianKongIndex": 2,
          "jieLuIndex": 10,
          "kongWangIndex": 11,
          "xunKongIndex": 3,
          "tianShangIndex": 4,
          "tianShiIndex": 6,
        }),
      );
    });

    test('getYearlyStarIndex(2001-08-16)', () {
      final result = getYearlyStarIndex('2001-08-16', 2, true);
      expect(
        result,
        equals({
          "xianChiIndex": 4,
          "huaGaiIndex": 11,
          "guChenIndex": 6,
          "guaSuIndex": 2,
          "tianCaiIndex": 8,
          "tianShouIndex": 0,
          "tianChuIndex": 4,
          "poSuiIndex": 7,
          "feiLianIndex": 5,
          "longChiIndex": 7,
          "fenGeIndex": 3,
          "tianKuIndex": 11,
          "tianXuIndex": 9,
          "tianGuanIndex": 7,
          "tianFuIndex": 3,
          "tianDeIndex": 0,
          "yueDeIndex": 8,
          "tianKongIndex": 4,
          "jieLuIndex": 2,
          "kongWangIndex": 3,
          "xunKongIndex": 7,
          "tianShangIndex": 8,
          "tianShiIndex": 10,
        }),
      );
    });

    test('getMonthlyStarIndex(2021-08-09) ', () {
      final result = getMonthlyStarIndex('2021-08-09', 2, true);
      expect(
        result,
        equals({
          'yueJieIndex': 0,
          'tianYaoIndex': 5,
          'tianXingIndex': 1,
          'yinShaIndex': 0,
          'tianYueIndex': 9,
          'tianWuIndex': 0,
        }),
      );
    });

    test('getDailyStarIndex(2020-08-05)', () {
      final result = getDailyStarIndex('2020-08-05', 1);
      expect(
        result,
        equals({
          'sanTaiIndex': 10,
          'baZuoIndex': 0,
          'tianGuiIndex': 5,
          'enguangIndex': 9,
        }),
      );
    });

    test('getTimlyStarIndex', () {
      final data = [
        {"taiFuIndex": 4, "fenggaoIndex": 0},
        {"taiFuIndex": 5, "fenggaoIndex": 1},
        {"taiFuIndex": 6, "fenggaoIndex": 2},
        {"taiFuIndex": 7, "fenggaoIndex": 3},
        {"taiFuIndex": 8, "fenggaoIndex": 4},
        {"taiFuIndex": 9, "fenggaoIndex": 5},
        {"taiFuIndex": 10, "fenggaoIndex": 6},
        {"taiFuIndex": 11, "fenggaoIndex": 7},
        {"taiFuIndex": 0, "fenggaoIndex": 8},
        {"taiFuIndex": 1, "fenggaoIndex": 9},
        {"taiFuIndex": 2, "fenggaoIndex": 10},
        {"taiFuIndex": 3, "fenggaoIndex": 11},
      ];

      data.asMap().forEach((key, value) {
        expect(getTimelyStarIndex(key), equals(value));
      });
    });

    test('getChangQuIndexByHeavenlyStem()', () {
      final data = [
        {
          'HeavenlyStem': jiaHeavenly,
          'result': {'changIndex': 3, 'quIndex': 7},
        },
        {
          'HeavenlyStem': yiHeavenly,
          'result': {'changIndex': 4, 'quIndex': 6},
        },
        {
          'HeavenlyStem': bingHeavenly,
          'result': {'changIndex': 6, 'quIndex': 4},
        },
        {
          'HeavenlyStem': wuHeavenly,
          'result': {'changIndex': 6, 'quIndex': 4},
        },
        {
          'HeavenlyStem': dingHeavenly,
          'result': {'changIndex': 7, 'quIndex': 3},
        },
        {
          'HeavenlyStem': jiHeavenly,
          'result': {'changIndex': 7, 'quIndex': 3},
        },
        {
          'HeavenlyStem': xinHeavenly,
          'result': {'changIndex': 10, 'quIndex': 0},
        },
        {
          'HeavenlyStem': renHeavenly,
          'result': {'changIndex': 0, 'quIndex': 10},
        },
      ];
      for (var value in data) {
        final heavenlyStem = value['HeavenlyStem'] as String;
        final result = value['result'] as Map<String, int>;
        final result1 = getChangQuIndexByHeavenlyStem(
          getMyHeavenlyStemNameFrom(heavenlyStem),
        );
        expect(result1, equals(result));
      }
    });

    test('getHuaGaiXianChiIndex()', () {
      // {"hgIdx": fixIndex(hgIdx), "xcIdx": fixIndex(xcIdx)};
      final data = {
        yinEarthly: {'hgIdx': 8, 'xcIdx': 1},
        wuEarthly: {'hgIdx': 8, 'xcIdx': 1},
        xuEarthly: {'hgIdx': 8, 'xcIdx': 1},
        shenEarthly: {'hgIdx': 2, 'xcIdx': 7},
        ziEarthly: {'hgIdx': 2, 'xcIdx': 7},
        chenEarthly: {'hgIdx': 2, 'xcIdx': 7},
        siEarthly: {'hgIdx': 11, 'xcIdx': 4},
        youEarthly: {'hgIdx': 11, 'xcIdx': 4},
        chouEarthly: {'hgIdx': 11, 'xcIdx': 4},
        haiEarthly: {'hgIdx': 5, 'xcIdx': 10},
        weiEarthly: {'hgIdx': 5, 'xcIdx': 10},
        maoEarthly: {'hgIdx': 5, 'xcIdx': 10},
      };
      data.forEach((key, value) {
        expect(
          getHuaGaiXianChiIndex(getMyEarthlyBranchNameFrom(key)),
          equals(value),
        );
      });
    });

    test('getGuGuaIndex()', () {
      final data = {
        yinEarthly: {'guChenIndex': 3, 'guaSuIndex': 11},
        maoEarthly: {'guChenIndex': 3, 'guaSuIndex': 11},
        chenEarthly: {'guChenIndex': 3, 'guaSuIndex': 11},
        siEarthly: {'guChenIndex': 6, 'guaSuIndex': 2},
        wuEarthly: {'guChenIndex': 6, 'guaSuIndex': 2},
        weiEarthly: {'guChenIndex': 6, 'guaSuIndex': 2},
        shenEarthly: {'guChenIndex': 9, 'guaSuIndex': 5},
        youEarthly: {'guChenIndex': 9, 'guaSuIndex': 5},
        xuEarthly: {'guChenIndex': 9, 'guaSuIndex': 5},
        haiEarthly: {'guChenIndex': 0, 'guaSuIndex': 8},
        ziEarthly: {'guChenIndex': 0, 'guaSuIndex': 8},
        chouEarthly: {'guChenIndex': 0, 'guaSuIndex': 8},
      };
      data.forEach((key, value) {
        print('getGuGuaIndex key $key, value $value');
        expect(getGuGuaIndex(getMyEarthlyBranchNameFrom(key)), equals(value));
      });
    });
  });
}
