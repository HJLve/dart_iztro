import 'package:flutter_test/flutter_test.dart';
import 'package:dart_iztro/lunar_lite/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/tools/strings.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    // 初始化翻译服务
    IztroTranslationService.init(initialLocale: 'zh_CN');
  });

  group('test ui getx enviroment', () {
    testWidgets('test multi-laungage enviromnent', (WidgetTester tester) async {
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

    group('ziwei util function', () {
      test('fixIndex should return correct index', () {
        expect(fixIndex(1), 1);
        expect(fixIndex(11), 11);
        expect(fixIndex(15, max: 20), 15);
        expect(fixIndex(-2), 10);
        expect(fixIndex(-3), 9);
        expect(fixIndex(-13), 11);
        expect(fixIndex(-2, max: 10), 8);
        expect(fixIndex(-3, max: 10), 7);
        expect(fixIndex(-15, max: 10), 5);
        expect(fixIndex(-27, max: 10), 3);
        expect(fixIndex(12), 0);
        expect(fixIndex(13), 1);
        expect(fixIndex(23), 11);
        expect(fixIndex(23, max: 10), 3);
        expect(fixIndex(37, max: 10), 7);
      });

      test('time to index()', () {
        final data = [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 2],
          [4, 2],
          [5, 3],
          [6, 3],
          [7, 4],
          [8, 4],
          [9, 5],
          [10, 5],
          [11, 6],
          [12, 6],
          [13, 7],
          [14, 7],
          [15, 8],
          [16, 8],
          [17, 9],
          [18, 9],
          [19, 10],
          [20, 10],
          [21, 11],
          [22, 11],
          [23, 12],
        ];
        // data.forEach(([key, value]) => {});
        data.asMap().forEach((key, value) {
          final result = timeToIndex(key);
          print('utils time to index $result, key $key, value $value');
          expect(result, value.last);
        });
      });

      test('getAgeIndex()', () {
        final data = {
          yinEarthly: 2,
          wuEarthly: 2,
          xuEarthly: 2,
          shenEarthly: 8,
          ziEarthly: 8,
          chenEarthly: 8,
          siEarthly: 5,
          youEarthly: 5,
          chouEarthly: 5,
          haiEarthly: 11,
          maoEarthly: 11,
          weiEarthly: 11,
        };

        data.forEach((key, value) {
          expect(getAgeIndex(getMyEarthlyBranchNameFrom(key)), value);
        });
      });

      test('earthlyBranchIndexToPalaceIndex()', () {
        final data = {
          yinEarthly: 0,
          maoEarthly: 1,
          chenEarthly: 2,
          siEarthly: 3,
          wuEarthly: 4,
          weiEarthly: 5,
          shenEarthly: 6,
          youEarthly: 7,
          xuEarthly: 8,
          haiEarthly: 9,
          ziEarthly: 10,
          chouEarthly: 11,
        };
        data.forEach((key, value) {
          expect(
            earthlyBranchIndexToPalaceIndex(getMyEarthlyBranchNameFrom(key)),
            value,
          );
        });
      });

      test('getBrightness() should return correnct value', () {
        final result1 = getBrightness(
          StarName.poJunMaj,
          fixEarthlyBranchIndex(EarthlyBranchName.wuEarthly),
        );
        final result2 = getBrightness(
          StarName.taiYinMaj,
          fixEarthlyBranchIndex(EarthlyBranchName.youEarthly),
        );
        final result3 = getBrightness(
          StarName.tianJiMaj,
          fixEarthlyBranchIndex(EarthlyBranchName.weiEarthly),
        );
        final result4 = getBrightness(
          StarName.tianFuMaj,
          fixEarthlyBranchIndex(EarthlyBranchName.shenEarthly),
        );
        final result5 = getBrightness(
          StarName.lianZhenMaj,
          fixEarthlyBranchIndex(EarthlyBranchName.ziEarthly),
        );
        final result6 = getBrightness(
          StarName.tuoLuoMin,
          fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly),
        );
        final result7 = getBrightness(
          StarName.qingYangMin,
          fixEarthlyBranchIndex(EarthlyBranchName.haiEarthly),
        );
        final result8 = getBrightness(
          StarName.qingYangMin,
          fixEarthlyBranchIndex(EarthlyBranchName.youEarthly),
        );
        expect(result1?.key, miao);
        expect(result2?.key, bu);
        expect(result3?.key, xian);
        expect(result4?.key, de);
        expect(result5?.key, ping);
        expect(result6?.key, xian);
        expect(result7, null);
        expect(result8?.key, xian);
        print(
          'getBrightness result1 ${result1?.title}, result2 ${result2?.title}, result3 ${result3?.title}, result4= ${result4?.title}, result5 = ${result5?.title}, result6 = ${result6?.title}, result7 = ${result7?.title}, result8 = ${result8?.title}',
        );
      });
    });
  });
}
