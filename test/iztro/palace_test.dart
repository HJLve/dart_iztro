import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/astro/palace.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:get/get.dart';

void main() {
  // 初始化翻译服务
  IztroTranslationService.init(initialLocale: 'zh_CN');
  Get.addTranslations(IztroTranslationService().keys);

  group('测试 palace function', () {
    testWidgets('test multi-laungage enviromnent', (WidgetTester tester) async {
      Get.updateLocale(const Locale('zh', 'CN'));
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('首页'))),
        ),
      );
    });

    test('getSoulAndBody function', () {
      final data = [
        {
          'date': '2023-01-22',
          'timeIndex': 5,
          'result': {
            'soulIndex': 7,
            'bodyIndex': 5,
            'havenlyStemOfSoul': jiHeavenly,
            'earthlyBranchOfSoul': youEarthly,
          },
        },
        {
          'date': '2023-01-22',
          'timeIndex': 6,
          'result': {
            'soulIndex': 6,
            'bodyIndex': 6,
            'havenlyStemOfSoul': wuHeavenly,
            'earthlyBranchOfSoul': shenEarthly,
          },
        },
        {
          'date': '2023-02-19',
          'timeIndex': 12,
          'result': {
            'soulIndex': 0,
            'bodyIndex': 0,
            'havenlyStemOfSoul': jiaHeavenly,
            'earthlyBranchOfSoul': yinEarthly,
          },
        },
      ];
      data.forEach((item) {
        final date = item['date'] as String;
        final timeIndex = item['timeIndex'] as int;
        final result = item['result'] as Map<String, dynamic>;
        final result1 = getSoulAndBody(date, timeIndex, true);
        expect(result1.soulIndex, result?['soulIndex'] as int);
        expect(result1.bodyIndex, result?['bodyIndex'] as int);
        expect(
          result1.heavenlyStenName,
          getMyHeavenlyStemNameFrom(result?['havenlyStemOfSoul'] as String),
        );
        expect(
          result1.earthlyBranchName,
          getMyEarthlyBranchNameFrom(result?['earthlyBranchOfSoul'] as String),
        );
      });
    });

    test('getFiveElementCLass()', () {
      expect(
        getFiveElementClass(
          HeavenlyStemName.gengHeavenly,
          EarthlyBranchName.shenEarthly,
        ),
        FiveElementsFormat.wood3rd,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.jiHeavenly,
          EarthlyBranchName.weiEarthly,
        ),
        FiveElementsFormat.fire6th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.wuHeavenly,
          EarthlyBranchName.weiEarthly,
        ),
        FiveElementsFormat.fire6th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.dingHeavenly,
          EarthlyBranchName.siEarthly,
        ),
        FiveElementsFormat.earth5th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.bingHeavenly,
          EarthlyBranchName.chenEarthly,
        ),
        FiveElementsFormat.earth5th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.yiHeavenly,
          EarthlyBranchName.maoEarthly,
        ),
        FiveElementsFormat.water2nd,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.jiaHeavenly,
          EarthlyBranchName.yinEarthly,
        ),
        FiveElementsFormat.water2nd,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.yiHeavenly,
          EarthlyBranchName.chouEarthly,
        ),
        FiveElementsFormat.metal4th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.jiaHeavenly,
          EarthlyBranchName.ziEarthly,
        ),
        FiveElementsFormat.metal4th,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.guiHeavenly,
          EarthlyBranchName.haiEarthly,
        ),
        FiveElementsFormat.water2nd,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.renHeavenly,
          EarthlyBranchName.xuEarthly,
        ),
        FiveElementsFormat.water2nd,
      );
      expect(
        getFiveElementClass(
          HeavenlyStemName.xinHeavenly,
          EarthlyBranchName.youEarthly,
        ),
        FiveElementsFormat.wood3rd,
      );
    });

    test('getPalaceNames() should return correct list', () {
      final targetList = [
        PalaceName.siblingsPalace,
        PalaceName.soulPalace,
        PalaceName.parentsPalace,
        PalaceName.spiritPalace,
        PalaceName.propertyPalace,
        PalaceName.careerPalace,
        PalaceName.friendsPalace,
        PalaceName.surfacePalace,
        PalaceName.healthPalace,
        PalaceName.wealthPalace,
        PalaceName.childrenPalace,
        PalaceName.spousePalace,
      ];
      expect(getPalaceNames(1), equals(targetList));
      expect(getPalaceNames(13), equals(targetList));
      expect(getPalaceNames(-11), equals(targetList));
    });

    test('getHoroscope() female', () {
      final result = getHoroscope('2023-11-15', 3, GenderName.female, true);
      final ages = result?['ages'] as List<List<int>>;
      print('getHoroscope $ages');
      final result1 = [
        [12, 24, 36, 48, 60, 72, 84, 96, 108, 120],
        [11, 23, 35, 47, 59, 71, 83, 95, 107, 119],
        [10, 22, 34, 46, 58, 70, 82, 94, 106, 118],
        [9, 21, 33, 45, 57, 69, 81, 93, 105, 117],
        [8, 20, 32, 44, 56, 68, 80, 92, 104, 116],
        [7, 19, 31, 43, 55, 67, 79, 91, 103, 115],
        [6, 18, 30, 42, 54, 66, 78, 90, 102, 114],
        [5, 17, 29, 41, 53, 65, 77, 89, 101, 113],
        [4, 16, 28, 40, 52, 64, 76, 88, 100, 112],
        [3, 15, 27, 39, 51, 63, 75, 87, 99, 111],
        [2, 14, 26, 38, 50, 62, 74, 86, 98, 110],
        [1, 13, 25, 37, 49, 61, 73, 85, 97, 109],
      ];
      expect(result1, equals(ages));
    });

    test('getHoroscope() male', () {
      final result = getHoroscope('2023-11-15', 3, GenderName.male, true);
      final ages = result?['ages'] as List<List<int>>;
      final result1 = [
        [2, 14, 26, 38, 50, 62, 74, 86, 98, 110],
        [3, 15, 27, 39, 51, 63, 75, 87, 99, 111],
        [4, 16, 28, 40, 52, 64, 76, 88, 100, 112],
        [5, 17, 29, 41, 53, 65, 77, 89, 101, 113],
        [6, 18, 30, 42, 54, 66, 78, 90, 102, 114],
        [7, 19, 31, 43, 55, 67, 79, 91, 103, 115],
        [8, 20, 32, 44, 56, 68, 80, 92, 104, 116],
        [9, 21, 33, 45, 57, 69, 81, 93, 105, 117],
        [10, 22, 34, 46, 58, 70, 82, 94, 106, 118],
        [11, 23, 35, 47, 59, 71, 83, 95, 107, 119],
        [12, 24, 36, 48, 60, 72, 84, 96, 108, 120],
        [1, 13, 25, 37, 49, 61, 73, 85, 97, 109],
      ];
      expect(ages, equals(result1));
    });

    test('fliesTo() notFlyTo() fliesOneOfTo()', () {
      final astroble = bySolar('2017-12-04', 12, GenderName.male);

      final result = astroble.palace(PalaceName.soulPalace)?.fliesTo(
        PalaceName.siblingsPalace,
        [Mutagen.siHuaJi],
      );
      final result1 = astroble.palace(PalaceName.soulPalace)?.notFlyTo(
        PalaceName.siblingsPalace,
        [Mutagen.siHuaKe],
      );
      final result2 = astroble.palace(PalaceName.propertyPalace)?.fliesTo(
        PalaceName.spiritPalace,
        [Mutagen.siHuaLu, Mutagen.siHuaKe],
      );
      final result3 = astroble.palace(PalaceName.propertyPalace)?.notFlyTo(
        PalaceName.spiritPalace,
        [Mutagen.siHuaLu, Mutagen.siHuaKe],
      );
      final result4 = astroble.palace(PalaceName.siblingsPalace)?.fliesTo(
        PalaceName.spousePalace,
        [Mutagen.siHuaQuan, Mutagen.siHuaKe],
      );
      final result5 = astroble.palace(PalaceName.siblingsPalace)?.fliesOneOfTo(
        PalaceName.spousePalace,
        [Mutagen.siHuaQuan, Mutagen.siHuaKe],
      );
      final result6 = astroble.palace(PalaceName.siblingsPalace)?.notFlyTo(
        PalaceName.spousePalace,
        [Mutagen.siHuaQuan, Mutagen.siHuaKe],
      );
      final result7 = astroble.palace(PalaceName.friendsPalace)?.selfMutaged([
        Mutagen.siHuaKe,
      ]);
      final result8 = astroble
          .palace(PalaceName.friendsPalace)
          ?.selfMutagedOneOf([Mutagen.siHuaKe, Mutagen.siHuaQuan]);
      print(
        'fliesto result3 = $result3， result4 $result4, result5 $result5, result6 $result6, result7 $result7, result8 $result8',
      );
      expect(result, true);
      expect(result1, true);
      expect(result2, true);
      expect(result3, false);
      expect(result4, false);
      expect(result5, true);
      expect(result6, false);
      expect(result7, true);
      expect(result8, true);

      final palaces =
          astroble.palace(PalaceName.soulPalace)?.mutagedPalaces() ?? [];
      expect(palaces[0].name.title, '命宫');
      expect(palaces[1].name.title, '迁移');
      expect(palaces[2].name.title, '交友');
      expect(palaces[3].name.title, '兄弟');
    });
  });
}
