import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    IztroTranslationService.init(initialLocale: 'zh_CN');
    Get.addTranslations(IztroTranslationService().keys);
  });

  group("test astro analyzer", () {
    testWidgets('init test app', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('首页'))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('首页'), findsOneWidget);
    });

    test("getPalace()", () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      List<String> palaceNames = [
        '疾厄',
        '财帛',
        '子女',
        '夫妻',
        '兄弟',
        '命宫',
        '父母',
        '福德',
        '田宅',
        '官禄',
        '仆役',
        '迁移',
      ];

      palaceNames.asMap().forEach((index, element) {
        var palaceName = getMyPalaceNameFrom(element);
        expect(result.palace(index)?.name.title, equals(element));
        expect(result.palace(palaceName)?.name.title, equals(element));
      });
      expect(
        result.palace(getMyPalaceNameFrom('来因'))?.name.title,
        equals('官禄'),
      );
      expect(
        result.palace(getMyPalaceNameFrom('身宫'))?.name.title,
        equals('命宫'),
      );

      try {
        result.palace(-1);
      } catch (error) {
        // expect(, matcher)
        print("error $error");
      }
      try {
        result.palace(12);
      } catch (error) {
        print("error $error");
      }
    });

    test('hasStars()', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      expect(result.palace(1)?.has([StarName.taiYangMaj]), false);
      expect(result.palace(1)?.has([StarName.tianXiangMaj]), true);
      expect(
        result.palace(2)?.has([StarName.tianJiMaj, StarName.tianLiangMaj]),
        true,
      );
      expect(
        result.palace(3)?.has([StarName.ziWeiMaj, StarName.tianLiangMaj]),
        false,
      );
      expect(
        result.palace(4)?.has([
          StarName.tianXi,
          StarName.tianYao,
          StarName.tianGuan,
          StarName.taiFu,
        ]),
        true,
      );
      expect(
        result.palace(7)?.has([
          StarName.lianZhenMaj,
          StarName.poJunMaj,
          StarName.zuoFuMin,
          StarName.huoXingMin,
        ]),
        true,
      );
      expect(
        result.palace(9)?.has([
          StarName.tianFuMaj,
          StarName.tuoLuoMin,
          StarName.diKongMin,
          StarName.diJieMin,
          StarName.tianChu,
        ]),
        true,
      );
      expect(
        result.palace(PalaceName.soulPalace)?.has([StarName.wuQuMaj]),
        false,
      );
      expect(
        result.palace(PalaceName.surfacePalace)?.has([
          StarName.wuQuMaj,
          StarName.tanLangMaj,
          StarName.qingYangMin,
          StarName.sanTai,
          StarName.baZuo,
        ]),
        true,
      );
      expect(
        result.palace(PalaceName.wealthPalace)?.has([StarName.tianXiangMaj]),
        true,
      );
      expect(
        result.palace(PalaceName.childrenPalace)?.has([
          StarName.tianJiMaj,
          StarName.tianLiangMaj,
          StarName.wenQuMin,
          StarName.tianKong,
          StarName.yinSha,
        ]),
        true,
      );
    });

    test('notHaveStars()', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      expect(result.palace(1)?.notHave([StarName.taiYangMaj]), true);
      expect(result.palace(1)?.notHave([StarName.tianXiangMaj]), false);
      expect(
        result.palace(2)?.notHave([StarName.tianJiMaj, StarName.tianLiangMaj]),
        false,
      );
      expect(
        result.palace(3)?.notHave([StarName.ziWeiMaj, StarName.tianLiangMaj]),
        false,
      );
      expect(
        result.palace(4)?.notHave([
          StarName.tianXi,
          StarName.tianYao,
          StarName.tianGuan,
          StarName.taiFu,
        ]),
        false,
      );
      expect(
        result.palace(7)?.notHave([
          StarName.lianZhenMaj,
          StarName.poJunMaj,
          StarName.zuoFuMin,
          StarName.huoXingMin,
        ]),
        false,
      );
      expect(
        result.palace(9)?.notHave([
          StarName.tianFuMaj,
          StarName.tuoLuoMin,
          StarName.diKongMin,
          StarName.diJieMin,
          StarName.tianChu,
        ]),
        false,
      );

      expect(
        result.palace(PalaceName.soulPalace)?.notHave([StarName.wuQuMaj]),
        true,
      );
      expect(
        result.palace(PalaceName.surfacePalace)?.notHave([
          StarName.wuQuMaj,
          StarName.tanLangMaj,
          StarName.qingYangMin,
          StarName.sanTai,
          StarName.baZuo,
        ]),
        false,
      );

      expect(
        result.palace(PalaceName.wealthPalace)?.notHave([
          StarName.tianXiangMaj,
        ]),
        false,
      );
      expect(
        result.palace(PalaceName.childrenPalace)?.notHave([
          StarName.tianJiMaj,
          StarName.tianLiangMaj,
          StarName.wenQuMin,
          StarName.tianKong,
          StarName.yinSha,
        ]),
        false,
      );
    });

    test('hasOneOfStars()', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      expect(
        result.palace(1)?.hasOneOf([
          StarName.taiYangMaj,
          StarName.tianXiangMaj,
        ]),
        true,
      );
      expect(
        result.palace(2)?.hasOneOf([StarName.tianJiMaj, StarName.tianLiangMaj]),
        true,
      );
      expect(
        result.palace(3)?.hasOneOf([StarName.ziWeiMaj, StarName.tianLiangMaj]),
        true,
      );
      expect(
        result.palace(7)?.hasOneOf([
          StarName.tianXi,
          StarName.tianYao,
          StarName.tianGuan,
          StarName.taiFu,
        ]),
        false,
      );
      expect(
        result.palace(9)?.hasOneOf([
          StarName.taiYangMaj,
          StarName.tianLiangMaj,
          StarName.tianGuan,
          StarName.tianYao,
          StarName.tianChu,
        ]),
        true,
      );
      expect(
        result.palace(PalaceName.soulPalace)?.hasOneOf([
          StarName.wuQuMaj,
          StarName.tianGui,
        ]),
        true,
      );
      expect(
        result.palace(PalaceName.parentsPalace)?.hasOneOf([
          StarName.yueDe,
          StarName.tianWu,
          StarName.juMenMaj,
        ]),
        true,
      );
    });

    test('have() is surrounded palaces', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).have([
          StarName.wuQuMaj,
          StarName.tanLangMaj,
          StarName.qingYangMin,
          StarName.tianXiangMaj,
          StarName.tianKuiMin,
          StarName.tianYue,
          StarName.diKongMin,
          StarName.diJieMin,
        ]),
        true,
      );
      expect(
        result.isSurrounded(PalaceName.soulPalace, [
          StarName.wuQuMaj,
          StarName.tanLangMaj,
          StarName.qingYangMin,
          StarName.tianXiangMaj,
          StarName.tianKuiMin,
          StarName.tianYueMin,
          StarName.diKongMin,
          StarName.diJieMin,
        ]),
        true,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).have([
          StarName.wuQuMaj,
          StarName.qingYangMin,
          StarName.tianXiangMaj,
          StarName.tianKuiMin,
          StarName.tianYueMin,
          StarName.diKongMin,
          StarName.diJieMin,
          StarName.taiYinMaj,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).have([
          StarName.taiYangMaj,
          StarName.juMenMaj,
          StarName.yueDe,
          StarName.tianWu,
          StarName.tianXi,
          StarName.tianYao,
          StarName.tianGuan,
          StarName.taiFu,
          StarName.wenChangMin,
          StarName.lingXingMin,
          StarName.tianCai,
          StarName.tianShou,
          StarName.tianXing,
          StarName.fengGao,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).have([
          StarName.tianJiMaj,
          StarName.tianLiangMaj,
          StarName.wenQuMin,
          StarName.tianKong,
          StarName.yinSha,
          StarName.xunKong,
          StarName.wenChangMin,
          StarName.lingXingMin,
          StarName.tianCai,
          StarName.tianShou,
          StarName.yueDe,
          StarName.tianWu,
          StarName.tianTongMaj,
          StarName.taiYinMaj,
          StarName.luCunMin,
          StarName.jieShen,
          StarName.hongLuan,
          StarName.xianChi,
          StarName.tianShang,
          StarName.tianDe,
          StarName.jieKong,
        ]),
        false,
      );
    });

    test('getSurroundedPalaces() by palace index', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      final palace = result.surroundedPalaces(0);
      expect(palace.target.name.title, '疾恶');
      expect(palace.opposite.name.title, '父母');
      expect(palace.wealth.name.title, '田宅');
      expect(palace.career.name.title, '兄弟');
    });

    test('getSurroundedPalaces() by palace name', () {
      final result = bySolar('2023-08-15', 0, GenderName.female, true);
      final palace = result.surroundedPalaces(PalaceName.soulPalace);
      expect(palace.target.name.title, '命宫');
      expect(palace.opposite.name.title, '迁移');
      expect(palace.wealth.name.title, '财帛');
      expect(palace.career.name.title, '官禄');
    });

    test('haveOneOf() in surrounded palaces', () {
      final result = bySolar('2023-08-16', 2, GenderName.female, true);
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).haveOneOf([
          StarName.taiYangMaj,
          StarName.wenQuMin,
        ]),
        true,
      );
      expect(
        result.isSurroundedOneOf(PalaceName.soulPalace, [
          StarName.taiYangMaj,
          StarName.wenQuMin,
        ]),
        true,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).notHave([
          StarName.tianXi,
          StarName.tianYueMin,
        ]),
        true,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).notHave([
          StarName.tianLiangMaj,
          StarName.luCunMin,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).notHave([
          StarName.zuoFuMin,
          StarName.youBiMin,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(PalaceName.soulPalace).notHave([
          StarName.diKongMin,
          StarName.diJieMin,
        ]),
        true,
      );
      expect(
        result.surroundedPalaces(3).notHave([
          StarName.wuQuMaj,
          StarName.tianMaMin,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(3).notHave([
          StarName.huoXingMin,
          StarName.tanLangMaj,
        ]),
        false,
      );
      expect(
        result.surroundedPalaces(3).notHave([
          StarName.tianKuiMin,
          StarName.tianGuan,
        ]),
        true,
      );
    });

    test('nothaveMutagenInPalce', () {
      final result = bySolar('2013-08-21', 4, GenderName.female, true);
      expect(
        result
            .palace(PalaceName.surfacePalace)
            ?.nothaveMutagen(Mutagen.siHuaLu),
        false,
      );
      expect(
        result.palace(PalaceName.siblingsPalace)?.hasMutagen(Mutagen.siHuaQuan),
        true,
      );
      expect(
        result.palace(PalaceName.childrenPalace)?.hasMutagen(Mutagen.siHuaKe),
        true,
      );
      expect(
        result.palace(PalaceName.spousePalace)?.hasMutagen(Mutagen.siHuaJi),
        true,
      );
      expect(
        result.palace(PalaceName.soulPalace)?.hasMutagen(Mutagen.siHuaJi),
        false,
      );
    });

    test('hasMutagen() in opposite Palace', () {
      final result = bySolar('2013-08-21', 4, GenderName.female, true);
      expect(
        result.star(StarName.ziWeiMaj)?.withMutagen([Mutagen.siHuaLu]),
        false,
      );
      expect(
        result.star(StarName.poJunMaj)?.withMutagen([Mutagen.siHuaLu]),
        true,
      );
      expect(
        result.star(StarName.juMenMaj)?.withMutagen([Mutagen.siHuaQuan]),
        true,
      );
      expect(
        result.star(StarName.taiYinMaj)?.withMutagen([Mutagen.siHuaKe]),
        true,
      );
      expect(
        result.star(StarName.tanLangMaj)?.withMutagen([Mutagen.siHuaJi]),
        true,
      );
      expect(
        result.star(StarName.tanLangMaj)?.withMutagen([
          Mutagen.siHuaJi,
          Mutagen.siHuaQuan,
        ]),
        true,
      );
      expect(
        result.star(StarName.tanLangMaj)?.withMutagen([
          Mutagen.siHuaKe,
          Mutagen.siHuaQuan,
        ]),
        false,
      );
    });

    test('withBrightness() in functionalStar', () {
      final result = bySolar('2013-08-21', 4, GenderName.female, true);
      expect(
        result.star(StarName.ziWeiMaj)?.withBrightness([BrightnessEnum.miao]),
        false,
      );
      expect(
        result.star(StarName.ziWeiMaj)?.withBrightness([
          BrightnessEnum.miao,
          BrightnessEnum.de,
        ]),
        true,
      );
      expect(
        result.star(StarName.juMenMaj)?.withBrightness([BrightnessEnum.miao]),
        true,
      );
      expect(
        result.star(StarName.taiYinMaj)?.withBrightness([
          BrightnessEnum.bu,
          BrightnessEnum.xian,
        ]),
        false,
      );
      expect(
        result.star(StarName.tanLangMaj)?.withBrightness([BrightnessEnum.ping]),
        true,
      );
    });

    test('oppsitePalace() in funcationalStar', () {
      final result = bySolar('2013-08-21', 4, GenderName.female, true);
      expect(
        result.star(StarName.ziWeiMaj)?.oppositePalace()?.name.title,
        '迁移',
      );
      expect(
        result.star(StarName.tianTongMaj)?.oppositePalace()?.name.title,
        '父母',
      );
      expect(
        result.star(StarName.juMenMaj)?.oppositePalace()?.name.title,
        '仆役',
      );
      expect(
        result.star(StarName.taiYinMaj)?.oppositePalace()?.name.title,
        '田宅',
      );
      expect(
        result.star(StarName.tanLangMaj)?.oppositePalace()?.name.title,
        '官禄',
      );
      expect(
        result
            .star(StarName.lianZhenMaj)
            ?.oppositePalace()
            ?.hasMutagen(Mutagen.siHuaJi),
        true,
      );
      expect(
        result
            .star(StarName.tianXiangMaj)
            ?.oppositePalace()
            ?.hasMutagen(Mutagen.siHuaLu),
        true,
      );
      expect(
        result
            .star(StarName.huoXingMin)
            ?.oppositePalace()
            ?.hasMutagen(Mutagen.siHuaKe),
        true,
      );
      expect(
        result
            .star(StarName.tianCai)
            ?.oppositePalace()
            ?.hasMutagen(Mutagen.siHuaQuan),
        true,
      );
      expect(
        result
            .star(StarName.wenChangMin)
            ?.oppositePalace()
            ?.hasMutagen(Mutagen.siHuaLu),
        false,
      );
    });

    test('surroundedPalaces() in functionalStar', () {
      final result = bySolar('2013-08-21', 4, GenderName.female, true);
      expect(
        result.star(StarName.xianChi)?.surroundedPalaces()?.target.name.title,
        '福德',
      );
      expect(
        result
            .star(StarName.xianChi)
            ?.surroundedPalaces()
            ?.target
            .earthlyBranch,
        EarthlyBranchName.wuEarthly,
      );
      expect(
        result
            .star(StarName.xianChi)
            ?.surroundedPalaces()
            ?.haveMutagen(Mutagen.siHuaLu),
        true,
      );
      expect(
        result
            .star(StarName.zuoFuMin)
            ?.surroundedPalaces()
            ?.haveMutagen(Mutagen.siHuaJi),
        true,
      );
      expect(
        result
            .star(StarName.ziWeiMaj)
            ?.surroundedPalaces()
            ?.haveMutagen(Mutagen.siHuaJi),
        false,
      );
    });
  });
}
