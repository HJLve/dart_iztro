import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_iztro/crape_myrtle/translations/translation_service.dart';
import 'package:dart_iztro/crape_myrtle/astro/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/five_element_class.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/gender.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/heavenly_stem.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // 初始化 Get 配置，但不更新 locale
    IztroTranslationService.init(initialLocale: 'zh_CN');
    Get.addTranslations(IztroTranslationService().keys);
  });

  group('Astro class functio test', () {
    testWidgets('test multi-laungage enviromnent', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService.withAppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          home: Container(),
        ),
      );
    });
  });

  group('test astro funcation', () {
    testWidgets('bySolar', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );

      final result = bySolar('2000-08-16', 2, GenderName.female, true);
      expect(result.solarDate, '2000-08-16');
      expect(result.lunarDate, '二〇〇〇年七月十七');
      expect(result.chineseDate, '庚辰 甲申 丙午 庚寅');
      expect(result.time, '寅时');
      expect(result.sign, '狮子座');
      expect(result.zodiac, '龙');
      expect(result.earthlyBranchOfSoulPalace.title, '午');
      expect(result.earthlyBranchOfBodyPalace.title, '戌');
      expect(result.soul, StarName.poJunMaj);
      expect(result.body, StarName.wenChangMin);
      expect(result.fiveElementClass.title, '木三局');

      var result1 = result.palace(PalaceName.parentsPalace)?.isEmpty([]);
      var result2 = result.palace(PalaceName.parentsPalace)?.isEmpty([
        StarName.tuoLuoMin,
      ]);
      var result3 = result.palace(PalaceName.soulPalace)?.isEmpty([]);
      var result4 = result.palace(PalaceName.parentsPalace)?.isEmpty([
        StarName.wenChangMin,
        StarName.wenQuMin,
      ]);

      expect(result1, true);
      expect(result2, false);
      expect(result3, false);
      expect(result4, true);

      final horoscope = result.horoscope(date: '2023-08-19 03:12:00');
      print("horoscope solarDate ${horoscope.solarDate}");
      expect(horoscope.solarDate, '2023-8-19');
      expect(horoscope.decadal.index, 2);
      expect(horoscope.decadal.heavenlyStem, HeavenlyStemName.gengHeavenly);
      expect(horoscope.decadal.earthlyBranch, EarthlyBranchName.chenEarthly);
      expect(horoscope.decadal.palaceNames, [
        PalaceName.spousePalace,
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
      ]);
      expect(
        horoscope.decadal.mutagen,
        equals([
          StarName.taiYangMaj,
          StarName.wuQuMaj,
          StarName.taiYinMaj,
          StarName.tianTongMaj,
        ]),
      );
      expect(horoscope.age.index, 9);
      expect(horoscope.age.nominalAge, 24);
      expect(horoscope.yearly.index, 1);
      expect(horoscope.yearly.heavenlyStem, HeavenlyStemName.guiHeavenly);
      expect(horoscope.yearly.earthlyBranch, EarthlyBranchName.maoEarthly);
      expect(
        horoscope.yearly.palaceNames,
        equals([
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
        ]),
      );
      expect(
        horoscope.yearly.mutagen,
        equals([
          StarName.poJunMaj,
          StarName.juMenMaj,
          StarName.taiYinMaj,
          StarName.tanLangMaj,
        ]),
      );
      expect(horoscope.monthly.index, 3);
      expect(horoscope.monthly.heavenlyStem, HeavenlyStemName.gengHeavenly);
      expect(horoscope.monthly.earthlyBranch, EarthlyBranchName.shenEarthly);
      expect(
        horoscope.monthly.palaceNames,
        equals([
          PalaceName.childrenPalace,
          PalaceName.spousePalace,
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
        ]),
      );
      expect(
        horoscope.monthly.mutagen,
        equals([
          StarName.taiYangMaj,
          StarName.wuQuMaj,
          StarName.taiYinMaj,
          StarName.tianTongMaj,
        ]),
      );

      expect(horoscope.daily.index, 6);
      expect(horoscope.daily.heavenlyStem, HeavenlyStemName.jiHeavenly);
      expect(horoscope.daily.earthlyBranch, EarthlyBranchName.youEarthly);
      expect(
        horoscope.daily.palaceNames,
        equals([
          PalaceName.surfacePalace,
          PalaceName.healthPalace,
          PalaceName.wealthPalace,
          PalaceName.childrenPalace,
          PalaceName.spousePalace,
          PalaceName.siblingsPalace,
          PalaceName.soulPalace,
          PalaceName.parentsPalace,
          PalaceName.spiritPalace,
          PalaceName.propertyPalace,
          PalaceName.careerPalace,
          PalaceName.friendsPalace,
        ]),
      );
      expect(
        horoscope.daily.mutagen,
        equals([
          StarName.wuQuMaj,
          StarName.tanLangMaj,
          StarName.tianLiangMaj,
          StarName.wenQuMin,
        ]),
      );

      expect(horoscope.hourly.index, 8);
      expect(horoscope.hourly.heavenlyStem, HeavenlyStemName.bingHeavenly);
      expect(horoscope.hourly.earthlyBranch, EarthlyBranchName.yinEarthly);
      //soulPalace, // 命宫
      //   bodyPalace, // 身宫
      //   siblingsPalace, // 兄弟宫
      //   spousePalace, // 夫妻宫
      //   childrenPalace, // 子女宫
      //   wealthPalace, // 财帛宫
      //   healthPalace, // 疾厄宫
      //   surfacePalace, // 迁移宫
      //   friendsPalace, // 仆役宫
      //   careerPalace, // 官禄宫
      //   propertyPalace, // 田宅宫
      //   spiritPalace, // 福德宫
      //   parentsPalace, // 父母宫
      //   originalPalace, // 来因宫
      expect(
        horoscope.hourly.palaceNames,
        equals([
          PalaceName.careerPalace,
          PalaceName.friendsPalace,
          PalaceName.surfacePalace,
          PalaceName.healthPalace,
          PalaceName.wealthPalace,
          PalaceName.childrenPalace,
          PalaceName.spousePalace,
          PalaceName.siblingsPalace,
          PalaceName.soulPalace,
          PalaceName.parentsPalace,
          PalaceName.spiritPalace,
          PalaceName.propertyPalace,
        ]),
      );
      expect(
        horoscope.hourly.mutagen,
        equals([
          StarName.tianTongMaj,
          StarName.tianJiMaj,
          StarName.wenChangMin,
          StarName.lianZhenMaj,
        ]),
      );

      expect(
        horoscope.hasHotoscopeStars(PalaceName.healthPalace, Scope.decadal, [
          StarName.liuTuo,
          StarName.liuQu,
          StarName.yunChang,
        ]),
        true,
      );
      expect(
        horoscope.hasHotoscopeStars(PalaceName.wealthPalace, Scope.yearly, [
          StarName.liuTuo,
          StarName.liuQu,
          StarName.yunChang,
        ]),
        true,
      );
      expect(
        horoscope.hasHotoscopeStars(PalaceName.surfacePalace, Scope.monthly, [
          StarName.liuTuo,
          StarName.liuQu,
          StarName.yunChang,
        ]),
        true,
      );
      expect(
        horoscope.hasHotoscopeStars(PalaceName.propertyPalace, Scope.daily, [
          StarName.liuTuo,
          StarName.liuQu,
          StarName.yunChang,
        ]),
        true,
      );
      expect(
        horoscope.nothaveHoroscopeStars(
          PalaceName.healthPalace,
          Scope.decadal,
          [StarName.liuTuo, StarName.liuQu, StarName.yunChang],
        ),
        false,
      );
      expect(
        horoscope.nothaveHoroscopeStars(
          PalaceName.healthPalace,
          Scope.decadal,
          [StarName.liuTuo, StarName.liuLuan, StarName.yunChang],
        ),
        false,
      );
      expect(
        horoscope.nothaveHoroscopeStars(
          PalaceName.healthPalace,
          Scope.decadal,
          [StarName.liuXi, StarName.liuLuan, StarName.liuKui],
        ),
        true,
      );
      expect(
        horoscope.hasOneOfHoroscopeStars(
          PalaceName.healthPalace,
          Scope.decadal,
          [StarName.liuTuo, StarName.liuQu, StarName.yunChang],
        ),
        true,
      );
      expect(
        horoscope.hasOneOfHoroscopeStars(
          PalaceName.healthPalace,
          Scope.decadal,
          [StarName.liuXi, StarName.liuLuan, StarName.liuKui],
        ),
        false,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.siblingsPalace,
          Scope.decadal,
          Mutagen.siHuaLu,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.spousePalace,
          Scope.decadal,
          Mutagen.siHuaQuan,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.healthPalace,
          Scope.decadal,
          Mutagen.siHuaKe,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.childrenPalace,
          Scope.decadal,
          Mutagen.siHuaJi,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.friendsPalace,
          Scope.yearly,
          Mutagen.siHuaLu,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.spousePalace,
          Scope.yearly,
          Mutagen.siHuaQuan,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.wealthPalace,
          Scope.yearly,
          Mutagen.siHuaKe,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.childrenPalace,
          Scope.yearly,
          Mutagen.siHuaJi,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.spousePalace,
          Scope.monthly,
          Mutagen.siHuaLu,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.childrenPalace,
          Scope.monthly,
          Mutagen.siHuaQuan,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.surfacePalace,
          Scope.monthly,
          Mutagen.siHuaKe,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.wealthPalace,
          Scope.monthly,
          Mutagen.siHuaJi,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.surfacePalace,
          Scope.daily,
          Mutagen.siHuaLu,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.careerPalace,
          Scope.daily,
          Mutagen.siHuaQuan,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.healthPalace,
          Scope.daily,
          Mutagen.siHuaKe,
        ),
        true,
      );
      expect(
        horoscope.hasHoroscopeMutagen(
          PalaceName.spousePalace,
          Scope.daily,
          Mutagen.siHuaJi,
        ),
        true,
      );

      final agePalace = horoscope.agePalace();
      expect(agePalace?.name.title, '仆役');
      expect(agePalace?.heavenlySten.title, '丁');
      expect(agePalace?.earthlyBranch.title, '亥');

      final originalPalace = horoscope.palace(
        PalaceName.soulPalace,
        Scope.origin,
      );
      expect(originalPalace?.name.title, '命宫');
      expect(originalPalace?.heavenlySten, HeavenlyStemName.renHeavenly);
      expect(originalPalace?.earthlyBranch, EarthlyBranchName.wuEarthly);

      final decadalPalace = horoscope.palace(
        PalaceName.soulPalace,
        Scope.decadal,
      );
      expect(decadalPalace?.name.title, '夫妻');
      expect(decadalPalace?.heavenlySten, HeavenlyStemName.gengHeavenly);
      expect(decadalPalace?.earthlyBranch, EarthlyBranchName.chenEarthly);

      final dcadalSurpalces = horoscope.surroundPalace(
        PalaceName.soulPalace,
        Scope.decadal,
      );
      expect(dcadalSurpalces?.target.name.title, '夫妻');
      expect(
        dcadalSurpalces?.target.heavenlySten,
        HeavenlyStemName.gengHeavenly,
      );
      expect(
        dcadalSurpalces?.target.earthlyBranch,
        EarthlyBranchName.chenEarthly,
      );
      expect(dcadalSurpalces?.opposite.name.title, '官禄');
      expect(
        dcadalSurpalces?.opposite.heavenlySten,
        HeavenlyStemName.bingHeavenly,
      );
      expect(
        dcadalSurpalces?.opposite.earthlyBranch,
        EarthlyBranchName.xuEarthly,
      );
      expect(dcadalSurpalces?.career.name.title, '福德');
      expect(
        dcadalSurpalces?.career.heavenlySten,
        HeavenlyStemName.jiaHeavenly,
      );
      expect(
        dcadalSurpalces?.career.earthlyBranch,
        EarthlyBranchName.shenEarthly,
      );
      expect(dcadalSurpalces?.wealth.name.title, '迁移');
      expect(dcadalSurpalces?.wealth.heavenlySten, HeavenlyStemName.wuHeavenly);
      expect(
        dcadalSurpalces?.wealth.earthlyBranch,
        EarthlyBranchName.ziEarthly,
      );

      final originalSurpalaces = horoscope.surroundPalace(
        PalaceName.spousePalace,
        Scope.origin,
      );
      expect(originalSurpalaces?.target.name.title, '夫妻');
      expect(
        originalSurpalaces?.target.heavenlySten,
        HeavenlyStemName.gengHeavenly,
      );
      expect(
        originalSurpalaces?.target.earthlyBranch,
        EarthlyBranchName.chenEarthly,
      );
      expect(originalSurpalaces?.opposite.name.title, '官禄');
      expect(
        originalSurpalaces?.opposite.heavenlySten,
        HeavenlyStemName.bingHeavenly,
      );
      expect(
        originalSurpalaces?.opposite.earthlyBranch,
        EarthlyBranchName.xuEarthly,
      );
      expect(originalSurpalaces?.career.name.title, '福德');
      expect(
        originalSurpalaces?.career.heavenlySten,
        HeavenlyStemName.jiaHeavenly,
      );
      expect(
        originalSurpalaces?.career.earthlyBranch,
        EarthlyBranchName.shenEarthly,
      );
      expect(originalSurpalaces?.wealth.name.title, '迁移');
      expect(
        originalSurpalaces?.wealth.heavenlySten,
        HeavenlyStemName.wuHeavenly,
      );
      expect(
        originalSurpalaces?.wealth.earthlyBranch,
        EarthlyBranchName.ziEarthly,
      );

      // final yearlyPalace = horoscope.palace(
      //   PalaceName.soulPalace,
      //   Scope.yearly,
      // );
      // expect(yearlyPalace?.name.title, '子女');
      // expect(yearlyPalace?.heavenlySten, HeavenlyStemName.jiHeavenly);
      // expect(yearlyPalace?.earthlyBranch, EarthlyBranchName.maoEarthly);
      //
      // final monthlyPalace = horoscope.palace(
      //   PalaceName.soulPalace,
      //   Scope.monthly,
      // );
      // expect(monthlyPalace?.name.title, '兄弟');
      // expect(monthlyPalace?.heavenlySten, HeavenlyStemName.xinHeavenly);
      // expect(monthlyPalace?.earthlyBranch, EarthlyBranchName.siEarthly);
      //
      // final dailyPalace = horoscope.palace(PalaceName.soulPalace, Scope.daily);
      // expect(dailyPalace?.name.title, '福德');
      // expect(dailyPalace?.heavenlySten, HeavenlyStemName.jiaHeavenly);
      // expect(dailyPalace?.earthlyBranch, EarthlyBranchName.shenEarthly);
      //
      // final hourlyPalace = horoscope.palace(
      //   PalaceName.soulPalace,
      //   Scope.hourly,
      // );
      // expect(hourlyPalace?.name.title, '官禄');
      // expect(hourlyPalace?.heavenlySten, HeavenlyStemName.bingHeavenly);
      // expect(hourlyPalace?.earthlyBranch, EarthlyBranchName.xuEarthly);
      //
      // final horoscope2 = result.horoscope(date: '2023-10-19 03:12:00');
      // expect(horoscope2.age.index, 9);
      // expect(horoscope2.age.nominalAge, 24);
      //
      // final agePalace2 = horoscope2.agePalace();
      // expect(agePalace2?.name.title, '仆役');
      // expect(agePalace2?.heavenlySten, HeavenlyStemName.dingHeavenly);
      // expect(agePalace2?.earthlyBranch, EarthlyBranchName.haiEarthly);
    });

    testWidgets('byLunar()', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: IztroTranslationService(),
          locale: const Locale('zh', 'CN'),
          fallbackLocale: const Locale('zh', 'CN'),
          home: const Scaffold(body: Center(child: Text('测试'))),
        ),
      );
      final result = byLunar('2000-07-17', 2, GenderName.female, true, true);
      expect(result.solarDate, '2000-08-16');
      expect(result.lunarDate, '二〇〇〇年七月十七');
      expect(result.chineseDate, '庚辰 甲申 丙午 庚寅');
      expect(result.time, '寅时');
      expect(result.sign, '狮子座');
      expect(result.zodiac, '龙');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.wuEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.xuEarthly);
      expect(result.soul.title, '破军');
      expect(result.body.title, '文昌');
      expect(result.fiveElementClass.title, '木三局');
      expect(result.palaces.length, 12);
      expect(
        result.palaces[0].decadal,
        Decadal(
          range: [43, 52],
          heavenlyStem: HeavenlyStemName.wuHeavenly,
          earthlyBranch: EarthlyBranchName.yinEarthly,
        ),
      );
      expect(
        result.palaces[11].decadal,
        equals(
          Decadal(
            range: [53, 62],
            heavenlyStem: HeavenlyStemName.jiHeavenly,
            earthlyBranch: EarthlyBranchName.chouEarthly,
          ),
        ),
      );
    });

    test('ByLunar with exact year divider', () {
      config(
        Config(
          mutagens: null,
          brightness: null,
          yearDivide: DivideType.exact,
          horoscopeDivide: null,
          ageDivide: AgeDivide.normal,
          algorithm: null,
        ),
      );
      final result = byLunar('1999-12-29', 2, GenderName.female, true, true);
      expect(result.solarDate, '2000-02-04');
      expect(result.lunarDate, '一九九九年腊月廿九');
      expect(result.chineseDate, '庚辰 丁丑 壬辰 壬寅');
      expect(result.time, '寅时');
      expect(result.zodiac, '龙');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.maoEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.wenChangMin);
      expect(result.fiveElementClass, FiveElementsFormat.earth5th);
    });

    test('byLunar with normal year divider', () {
      config(
        Config(
          mutagens: null,
          brightness: null,
          yearDivide: DivideType.normal,
          horoscopeDivide: null,
          ageDivide: AgeDivide.normal,
          algorithm: null,
        ),
      );
      final result = byLunar('1999-12-29', 2, GenderName.female, true, true);

      expect(result.solarDate, '2000-02-04');
      expect(result.lunarDate, '一九九九年腊月廿九');
      expect(result.chineseDate, '己卯 丁丑 壬辰 壬寅');
      expect(result.time, '寅时');
      expect(result.zodiac, '兔');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.maoEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.fire6th);
    });

    test('bySolar() with normal year divider', () {
      config(
        Config(
          mutagens: null,
          brightness: null,
          yearDivide: DivideType.normal,
          horoscopeDivide: null,
          ageDivide: AgeDivide.normal,
          algorithm: null,
        ),
      );
      final result = bySolar('1980-02-14', 0, GenderName.male, true);
      expect(result.solarDate, '1980-02-14');
      expect(result.lunarDate, '一九七九年腊月廿八');
      expect(result.chineseDate, '己未 戊寅 丁巳 庚子');
      expect(result.time, '早子时');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.chouEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.chouEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianXiangMaj);
      expect(result.fiveElementClass, FiveElementsFormat.water2nd);
      expect(result.palaces[0].decadal.range, equals([112, 121]));

      final horoscope = result.horoscope(date: '1980-02-14');
      expect(horoscope.yearly.earthlyBranch, EarthlyBranchName.shenEarthly);
      expect(horoscope.yearly.heavenlyStem, HeavenlyStemName.gengHeavenly);
    });

    test('check specail date 1995-03-30', () {
      config(
        Config(
          mutagens: null,
          brightness: null,
          yearDivide: DivideType.normal,
          horoscopeDivide: null,
          ageDivide: AgeDivide.normal,
          algorithm: null,
        ),
      );
      final result = bySolar('1995-03-30', 0, GenderName.male, true);
      expect(result.solarDate, '1995-03-30');
      expect(result.lunarDate, '一九九五年二月三十');

      final result1 = byLunar('1995-02-30', 0, GenderName.male, true);
      expect(result1.solarDate, '1995-03-30');
      expect(result1.lunarDate, '一九九五年二月三十');
    });

    test('withOptions() normal', () {
      final result = withOptions(
        Option(
          type: OptionType.lunar,
          dateStr: '1999-12-29',
          timeIndex: 2,
          gender: GenderName.female,
          isLeapMonth: false,
          fixLeap: true,
        ),
      );

      expect(result.solarDate, '2000-02-04');
      expect(result.lunarDate, '一九九九年腊月廿九');
      expect(result.chineseDate, '己卯 丁丑 壬辰 壬寅');
      expect(result.time, '寅时');
      expect(result.zodiac, '兔');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.maoEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.fire6th);
    });

    test('withOptions() exact', () {
      final result = withOptions(
        Option(
          type: OptionType.lunar,
          dateStr: '1999-12-29',
          timeIndex: 2,
          gender: GenderName.female,
          isLeapMonth: false,
          fixLeap: true,
          config: Config(
            mutagens: null,
            brightness: null,
            yearDivide: DivideType.exact,
            horoscopeDivide: null,
            ageDivide: AgeDivide.normal,
            algorithm: null,
          ),
        ),
      );
      expect(result.solarDate, '2000-02-04');
      expect(result.lunarDate, '一九九九年腊月廿九');
      expect(result.chineseDate, '庚辰 丁丑 壬辰 壬寅');
      expect(result.time, '寅时');
      expect(result.zodiac, '龙');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.maoEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.wenChangMin);
      expect(result.fiveElementClass, FiveElementsFormat.earth5th);
    });

    test('withOptions() yearfivede normal, horoscope divide normal', () {
      final result = withOptions(
        Option(
          type: OptionType.lunar,
          dateStr: '1979-12-28',
          timeIndex: 0,
          gender: GenderName.female,
          isLeapMonth: false,
          fixLeap: true,
          config: Config(
            mutagens: null,
            brightness: null,
            yearDivide: DivideType.normal,
            horoscopeDivide: DivideType.normal,
            ageDivide: AgeDivide.normal,
            algorithm: null,
          ),
        ),
      );

      expect(result.solarDate, '1980-02-14');
      expect(result.lunarDate, '一九七九年腊月廿八');
      expect(result.chineseDate, '己未 戊寅 丁巳 庚子');
      expect(result.time, '早子时');
      expect(result.zodiac, '羊');
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.chouEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.chouEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianXiangMaj);
      expect(result.fiveElementClass, FiveElementsFormat.water2nd);

      final horoscpoe = result.horoscope(date: '1980-02-14');
      expect(horoscpoe.yearly.earthlyBranch, EarthlyBranchName.weiEarthly);

      final result2 = withOptions(
        Option(
          type: OptionType.lunar,
          dateStr: '1979-12-28',
          timeIndex: 0,
          gender: GenderName.female,
          isLeapMonth: false,
          fixLeap: true,
          config: Config(
            mutagens: null,
            brightness: null,
            yearDivide: DivideType.normal,
            horoscopeDivide: DivideType.exact,
            ageDivide: AgeDivide.normal,
            algorithm: null,
          ),
        ),
      );
      final horoscope2 = result2.horoscope(date: '1980-02-14');
      expect(horoscope2.yearly.earthlyBranch, EarthlyBranchName.shenEarthly);
    });

    test('with options with earth type', () {
      final result = withOptions(
        Option(
          type: OptionType.solar,
          dateStr: '1979-08-21',
          timeIndex: 7,
          gender: GenderName.male,
          isLeapMonth: true,
          fixLeap: true,
          astroType: AstroType.earth,
        ),
      );
      final soulPalace = result.palace(PalaceName.soulPalace);
      print(soulPalace.toString());
      expect(soulPalace?.index, 1);
      expect(soulPalace?.heavenlySten, HeavenlyStemName.dingHeavenly);
      expect(soulPalace?.earthlyBranch, EarthlyBranchName.maoEarthly);
      expect(soulPalace?.majorStars[0].name.title, '天相');
      expect(soulPalace?.minorStars[0].name.title, '文昌');
      expect(result.fiveElementClass, FiveElementsFormat.fire6th);
      expect(
        soulPalace?.decadal,
        equals(
          Decadal(
            range: [6, 15],
            heavenlyStem: HeavenlyStemName.dingHeavenly,
            earthlyBranch: EarthlyBranchName.maoEarthly,
          ),
        ),
      );
    });

    test('with options with human type', () {
      getConfig().algorithm = Algorithm.zhongZhou;
      final result = withOptions(
        Option(
          type: OptionType.solar,
          dateStr: '1979-08-21',
          timeIndex: 8,
          gender: GenderName.male,
          isLeapMonth: true,
          fixLeap: true,
          astroType: AstroType.human,
        ),
      );
      final soulPalace = result.palace(PalaceName.soulPalace);
      print(soulPalace.toString());
      expect(soulPalace?.index, 0);
      expect(soulPalace?.heavenlySten, HeavenlyStemName.bingHeavenly);
      expect(soulPalace?.earthlyBranch, EarthlyBranchName.yinEarthly);
      expect(soulPalace?.majorStars[0].name.title, '太阳');
      expect(soulPalace?.minorStars[0].name.title, '文昌');
      expect(result.fiveElementClass, FiveElementsFormat.fire6th);
      expect(
        soulPalace?.decadal,
        equals(
          Decadal(
            range: [6, 15],
            heavenlyStem: HeavenlyStemName.bingHeavenly,
            earthlyBranch: EarthlyBranchName.yinEarthly,
          ),
        ),
      );
    });

    test('bosolar fix leap month', () {
      final result = bySolar('2023-04-10', 4, GenderName.female, true);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.ziEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.shenEarthly);
      expect(result.soul, StarName.tanLangMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.metal4th);
      // expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '迁移');
    });

    test('bysolar use default fixleap', () {
      final result = bySolar('2023-04-10', 4, GenderName.female, true);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.ziEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.shenEarthly);
      expect(result.soul, StarName.tanLangMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.metal4th);
      // expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '迁移');
    });

    test('bySolar do not fix leap month', () {
      final result = bySolar('2023-04-10', 4, GenderName.female, false);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.weiEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.water2nd);
      expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '命宫');
    });

    test('byLunar fix leap month', () {
      final result = byLunar('2023-2-20', 4, GenderName.female, true, true);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.ziEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.shenEarthly);
      expect(result.soul, StarName.tanLangMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.metal4th);
      // expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '迁移');
    });

    test('byLunar use default isLeapMonth', () {
      final result = byLunar('2023-02-20', 4, GenderName.female);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.weiEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.water2nd);
      expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '命宫');
    });

    test('byLunar  do not fix leap month', () {
      final result = byLunar('2023-02-20', 4, GenderName.female, true, false);
      expect(result.earthlyBranchOfSoulPalace, EarthlyBranchName.haiEarthly);
      expect(result.earthlyBranchOfBodyPalace, EarthlyBranchName.weiEarthly);
      expect(result.soul, StarName.juMenMaj);
      expect(result.body, StarName.tianTongMaj);
      expect(result.fiveElementClass, FiveElementsFormat.water2nd);
      expect(result.star(StarName.ziWeiMaj)?.palace()?.name.title, '命宫');
    });

    test('getZodiacBySolarDate()', () {
      expect(getZodiacBySolarDate('2023-02-20').tr, '兔');
    });

    test('getSignBySolarDate()', () {
      expect(getSignBySolarDate('2023-09-05'), '处女座');
    });
    test('getSignByLunarDate()', () {
      expect(getSignByLunarDate('2023-07-21', false), '处女座');
      expect(getSignByLunarDate('2023-02-03', true), '白羊座');
    });
    test('getmajorStarBySolarDate()', () {
      expect(getMajorStarBySolarDate('2023-4-7', 0), '贪狼');
      expect(getMajorStarBySolarDate('2023-4-7', 0, false), '紫微,贪狼');
    });
    test('getMajorStarByLunarDate()', () {
      expect(getMajorStarByLunarDate('2023-02-17', 0), '紫微,贪狼');
      expect(getMajorStarByLunarDate('2023-02-17', 0, true), '贪狼');
    });
    test('childhood', () {
      final astrolable = bySolar('2023-10-18', 4, GenderName.female);
      final horoscope1 = astrolable.horoscope(date: '2023-12-19');
      expect(horoscope1.decadal.name.tr, '童限');
      expect(
        horoscope1.decadal.index,
        equals(astrolable.palace(PalaceName.soulPalace)?.index),
      );
      final horoscope2 = astrolable.horoscope(date: '2024-12-29');
      expect(horoscope2.decadal.name.tr, '童限');
      expect(
        horoscope2.decadal.index,
        equals(astrolable.palace(PalaceName.wealthPalace)?.index),
      );
      final horoscope3 = astrolable.horoscope(date: '2025-12-29');
      expect(horoscope3.decadal.name.tr, '童限');
      expect(
        horoscope3.decadal.index,
        equals(astrolable.palace(PalaceName.healthPalace)?.index),
      );
    });
  });
}
