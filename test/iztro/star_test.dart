import 'package:dart_iztro/crape_myrtle/data/types/star.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/star/adjective_star.dart';
import 'package:dart_iztro/crape_myrtle/star/decorative_star.dart';
import 'package:dart_iztro/crape_myrtle/star/funcational_star.dart';
import 'package:dart_iztro/crape_myrtle/star/horoscope_star.dart';
import 'package:dart_iztro/crape_myrtle/star/location.dart';
import 'package:dart_iztro/crape_myrtle/star/major_star.dart';
import 'package:dart_iztro/crape_myrtle/star/minor_star.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:get/get.dart';

void main() {
  // 初始化翻译服务
  IztroTranslationService.init(initialLocale: 'zh_CN');
  Get.addTranslations(IztroTranslationService().keys);

  group('Astro class functio test', () {
    testWidgets('test multi-laungage enviromnent', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('首页'))),
        ),
      );
    });
  });

  group('test star funcation', () {
    testWidgets('getStartIndex', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final data = [
        {
          'timeIndex': 0,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 11, 'tianfuIndex': 1},
        },
        {
          'timeIndex': 1,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 11, 'tianfuIndex': 1},
        },
        {
          'timeIndex': 2,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 2, 'tianfuIndex': 10},
        },
        {
          'timeIndex': 3,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 2, 'tianfuIndex': 10},
        },
        {
          'timeIndex': 4,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 6, 'tianfuIndex': 6},
        },
        {
          'timeIndex': 5,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 6, 'tianfuIndex': 6},
        },
        {
          'timeIndex': 6,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 2, 'tianfuIndex': 10},
        },
        {
          'timeIndex': 7,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 2, 'tianfuIndex': 10},
        },
        {
          'timeIndex': 8,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 6, 'tianfuIndex': 6},
        },
        {
          'timeIndex': 9,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 6, 'tianfuIndex': 6},
        },
        {
          'timeIndex': 10,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 4, 'tianfuIndex': 8},
        },
        {
          'timeIndex': 11,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 4, 'tianfuIndex': 8},
        },
        {
          'timeIndex': 12,
          'solarDate': '2023-08-01',
          'result': {'ziweiIndex': 4, 'tianfuIndex': 8},
        },
        {
          'timeIndex': 12,
          'solarDate': '2023-02-19',
          'result': {'ziweiIndex': 11, 'tianfuIndex': 1},
        },
      ];
      for (Map item in data) {
        final solarDate = item['solarDate'];
        final timeIndex = item['timeIndex'];
        final result = item['result'];
        final result1 = getStartIndex(solarDate, timeIndex);
        print(
          "result $result, result1 = $result1, isEqual ${result == result1}",
        );
      }
    });

    testWidgets('getMajorStar()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getMajorStar('2023-03-06', 4, true);
      print("get major stars $result");
      // expect(
      //   result,
      //   equals([
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.qiShaMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.miao,
      //           scope: Scope.origin,
      //           mutagen: null,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tianTongMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.ping,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.wuQuMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.miao,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.taiYangMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.wang,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.poJunMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.miao,
      //           scope: Scope.origin,
      //           mutagen: Mutagen.siHuaLu,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tianJiMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.xian,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.ziWeiMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.wang,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tianFuMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.de,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.taiYinMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.bu,
      //           scope: Scope.origin,
      //           mutagen: Mutagen.siHuaKe,
      //         ),
      //       ),
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tanLangMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.miao,
      //           scope: Scope.origin,
      //           mutagen: Mutagen.siHuaJi,
      //         ),
      //       ),
      //       FunctionalStar(
      //         Star(
      //           name: StarName.juMenMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.wang,
      //           scope: Scope.origin,
      //           mutagen: Mutagen.siHuaQuan,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.lianZhenMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.ping,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tianXiangMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.miao,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //     [
      //       FunctionalStar(
      //         Star(
      //           name: StarName.tianLiangMaj,
      //           type: StarType.major,
      //           brightness: BrightnessEnum.wang,
      //           scope: Scope.origin,
      //         ),
      //       ),
      //     ],
      //   ]),
      // );
    });

    testWidgets('getMinorStar()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final primaryStars = getMajorStar('2023-03-06', 2, true);
      final secondaryStars = getMinorStar('2023-03-06', 2, true);
      final otherStars = getAdjectiveStar('2023-03-06', 2, true);
      List<List<List<FunctionalStar>>> result = [];
      result.add(primaryStars);
      result.add(secondaryStars);
      result.add(otherStars);
      final result1 = mergeStars(result);
      final sum = result1
          .map((element) => element.length)
          .reduce((prev, next) => prev + next);
      print("get minor stars sum $sum, result1.length = ${result1.length}");
      expect(sum, 66);
      expect(result1.length, 12);
    });

    testWidgets('getChangsheng12()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getChangSheng12('2023-08-15', 0, GenderName.female, true);
      final names = result.map((star) => star.title).toList();
      expect(names, [
        '长生',
        '沐浴',
        '冠带',
        '临官',
        '帝旺',
        '衰',
        '病',
        '死',
        '墓',
        '绝',
        '胎',
        '养',
      ]);
    });

    testWidgets('getBoShi12()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getBoShi12('2023-08-15', GenderName.female);
      expect(result.map((star) => star.title).toList(), [
        '青龙',
        '小耗',
        '将军',
        '奏书',
        '飞廉',
        '喜神',
        '病符',
        '大耗',
        '伏兵',
        '官府',
        '博士',
        '力士',
      ]);
    });

    testWidgets('getYearly12()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getYearly12('2025-08-15');
      List<StarName>? jiangqian12 = result['jiangqian12'];
      List<StarName>? suiqian12 = result['suiqian12'];
      final jiangqian1Result = jiangqian12?.map((star) => star.title).toList();
      final suiqian12Result = suiqian12?.map((star) => star.title).toList();
      print(
        "get Yearly 12 $result, suiqian12Result $suiqian12Result, jiangqian1Result $jiangqian1Result",
      );
      expect(suiqian12Result, [
        '天德',
        '吊客',
        '病符',
        '岁建',
        '晦气',
        '丧门',
        '贯索',
        '官符',
        '小耗',
        '大耗',
        '龙德',
        '白虎',
      ]);
      expect(jiangqian1Result, [
        '劫煞',
        '灾煞',
        '天煞',
        '指背',
        '咸池',
        '月煞',
        '亡神',
        '将星',
        '攀鞍',
        '岁驿',
        '息神',
        '华盖',
      ]);
    });

    testWidgets('getHoroscopeStar() decades', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getHoroscopeStar(
        HeavenlyStemName.gengHeavenly,
        EarthlyBranchName.chenEarthly,
        Scope.decadal,
      );
      final titles =
          result
              .map((list) => list.map((star) => star.name.title).toList())
              .toList();
      print('getHoroscopeStar result $result, titles = $titles');
      expect(titles, [
        ['运马'],
        ['运曲'],
        [],
        ['运喜'],
        [],
        ['运钺', '运陀'],
        ['运禄'],
        ['运羊'],
        [],
        ['运昌', '运鸾'],
        [],
        ['运魁'],
      ]);
    });

    testWidgets('getHoroscopeStar() scope= yearly', (
      WidgetTester tester,
    ) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = getHoroscopeStar(
        HeavenlyStemName.guiHeavenly,
        EarthlyBranchName.maoEarthly,
        Scope.yearly,
      );
      final titles =
          result
              .map((list) => list.map((star) => star.name.title).toList())
              .toList();
      print("getHoroscopeStar result $result, titles $titles");
      expect(titles, [
        [],
        ['流魁', '流昌'],
        [],
        ['流钺', '流马'],
        ['流喜'],
        ['年解'],
        [],
        [],
        [],
        ['流曲', '流陀'],
        ['流禄', '流鸾'],
        ['流羊'],
      ]);
    });

    testWidgets('getJiangQian12StarIndex()', (WidgetTester tester) async {
      // 设置测试环境
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final data = {
        yinEarthly: 4,
        wuEarthly: 4,
        xuEarthly: 4,
        shenEarthly: 10,
        ziEarthly: 10,
        chenEarthly: 10,
        siEarthly: 7,
        youEarthly: 7,
        chouEarthly: 7,
        haiEarthly: 1,
        maoEarthly: 1,
        weiEarthly: 1,
      };
      data.forEach((key, value) {
        final result = getJangQian12StartIndex(getMyEarthlyBranchNameFrom(key));
        print("getJangQian12StartIndex key $key, value $value, result $result");
        expect(result, value);
      });
    });
  });
}
