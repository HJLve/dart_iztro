import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 中文简体
import 'zh_CN/brightness_cn.dart';
import 'zh_CN/common_cn.dart';
import 'zh_CN/earthly_branch_cn.dart';
import 'zh_CN/five_element_class_cn.dart';
import 'zh_CN/gender_cn.dart';
import 'zh_CN/heavenly_stem_cn.dart';
import 'zh_CN/mutagen_cn.dart';
import 'zh_CN/palace_cn.dart';
import 'zh_CN/stars_cn.dart';

// 英文
import 'en_US/brightness_en.dart';
import 'en_US/common_en.dart';
import 'en_US/earthly_branch_en.dart';
import 'en_US/five_element_class_en.dart';
import 'en_US/gender_en.dart';
import 'en_US/heavenly_stem_en.dart';
import 'en_US/mutagen_en.dart';
import 'en_US/palace_en.dart';
import 'en_US/stars_en.dart';

// 日文
import 'ja_JP/brightness_ja.dart';
import 'ja_JP/common_ja.dart';
import 'ja_JP/earthly_branch_ja.dart';
import 'ja_JP/five_element_class_ja.dart';
import 'ja_JP/gender_ja.dart';
import 'ja_JP/heavenly_stem_ja.dart';
import 'ja_JP/mutagen_ja.dart';
import 'ja_JP/palace_ja.dart';
import 'ja_JP/stars_ja.dart';

// 韩文
import 'ko_KR/brightness_ko.dart';
import 'ko_KR/common_ko.dart';
import 'ko_KR/earthly_branch_ko.dart';
import 'ko_KR/five_element_class_ko.dart';
import 'ko_KR/gender_ko.dart';
import 'ko_KR/heavenly_stem_ko.dart';
import 'ko_KR/mutagen_ko.dart';
import 'ko_KR/palace_ko.dart';
import 'ko_KR/stars_ko.dart';

// 繁体中文
import 'zh_TW/brightness_tw.dart';
import 'zh_TW/common_tw.dart';
import 'zh_TW/earthly_branch_tw.dart';
import 'zh_TW/five_element_class_tw.dart';
import 'zh_TW/gender_tw.dart';
import 'zh_TW/heavenly_stem_tw.dart';
import 'zh_TW/mutagen_tw.dart';
import 'zh_TW/palace_tw.dart';
import 'zh_TW/stars_tw.dart';

// 泰语
import 'th_TH/brightness_th.dart';
import 'th_TH/common_th.dart';
import 'th_TH/earthly_branch_th.dart';
import 'th_TH/five_element_class_th.dart';
import 'th_TH/gender_th.dart';
import 'th_TH/heavenly_stem_th.dart';
import 'th_TH/mutagen_th.dart';
import 'th_TH/palace_th.dart';
import 'th_TH/stars_th.dart';

// 越南语
import 'vi_VN/brightness_vi.dart';
import 'vi_VN/common_vi.dart';
import 'vi_VN/earthly_branch_vi.dart';
import 'vi_VN/five_element_class_vi.dart';
import 'vi_VN/gender_vi.dart';
import 'vi_VN/heavenly_stem_vi.dart';
import 'vi_VN/mutagen_vi.dart';
import 'vi_VN/palace_vi.dart';
import 'vi_VN/stars_vi.dart';

// 可以在这里添加其他语言的导入

/// 紫微斗数库的翻译服务
class IztroTranslationService extends Translations {
  // 存储应用层的翻译
  static final Map<String, Map<String, String>> _appTranslations = {};

  // 用于合并应用层翻译和库的翻译
  final bool _mergeWithApp;

  // 默认构造函数，用于库内部使用
  IztroTranslationService() : _mergeWithApp = false;

  // 用于应用层的构造函数，合并应用层翻译
  IztroTranslationService.withAppTranslations() : _mergeWithApp = true;

  @override
  Map<String, Map<String, String>> get keys {
    // 紫微斗数库的翻译
    final Map<String, Map<String, String>> libraryTranslations = {
      // 中文简体
      'zh_CN': {
        ...commonCN,
        ...genderCN,
        ...palaceLocalsCN,
        ...starsLocalsCN,
        ...mutagenCNs,
        ...brightnessCN,
        ...earthlyBranchCN,
        ...heavenlyStemCNs,
        ...fileElementClassCN,
      },
      // 英文
      'en_US': {
        ...commonEN,
        ...genderEN,
        ...palaceLocalsEN,
        ...starsLocalsEN,
        ...mutagenENs,
        ...brightnessEN,
        ...earthlyBranchEN,
        ...heavenlyStemENs,
        ...fileElementClassEN,
      },
      // 日文
      'ja_JP': {
        ...commonJA,
        ...genderJA,
        ...palaceLocalsJA,
        ...starsLocalsJA,
        ...mutagenJAs,
        ...brightnessJA,
        ...earthlyBranchJA,
        ...heavenlyStemJAs,
        ...fileElementClassJA,
      },
      // 韩文
      'ko_KR': {
        ...commonKO,
        ...genderKO,
        ...palaceLocalsKO,
        ...starsLocalsKO,
        ...mutagenKOs,
        ...brightnessKO,
        ...earthlyBranchKO,
        ...heavenlyStemKOs,
        ...fileElementClassKO,
      },
      // 繁体中文
      'zh_TW': {
        ...commonTW,
        ...genderTW,
        ...palaceLocalsTW,
        ...starsTW,
        ...mutagenTWs,
        ...brightnessTW,
        ...earthlyBranchTW,
        ...heavenlyStemTWs,
        ...fileElementClassTW,
      },
      // 泰语
      'th_TH': {
        ...commonTH,
        ...genderTH,
        ...palaceLocalsTH,
        ...starsLocalsTH,
        ...mutagenTH,
        ...brightnessTH,
        ...earthlyBranchTH,
        ...heavenlyStemTH,
        ...fileElementClassTH,
      },
      // 越南语
      'vi_VN': {
        ...commonVI,
        ...genderVI,
        ...palaceLocalsVI,
        ...starsLocalsVI,
        ...mutagenVIs,
        ...brightnessVI,
        ...earthlyBranchVI,
        ...heavenlyStemVIs,
        ...fileElementClassVI,
      },
    };

    // 如果需要合并应用层翻译
    if (_mergeWithApp) {
      final result = <String, Map<String, String>>{};

      // 复制库翻译
      libraryTranslations.forEach((locale, translations) {
        result[locale] = Map<String, String>.from(translations);
      });

      // 合并应用层翻译
      _appTranslations.forEach((locale, translations) {
        if (result.containsKey(locale)) {
          // 如果库中已有该语言，合并翻译
          result[locale]!.addAll(translations);
        } else {
          // 如果库中没有该语言，直接添加
          result[locale] = Map<String, String>.from(translations);
        }
      });

      return result;
    }

    return libraryTranslations;
  }

  /// 添加应用层的翻译
  ///
  /// [translations] 应用层的翻译键值对，格式与GetX的translations相同
  static void addAppTranslations(
    Map<String, Map<String, String>> translations,
  ) {
    translations.forEach((locale, trans) {
      if (_appTranslations.containsKey(locale)) {
        _appTranslations[locale]!.addAll(trans);
      } else {
        _appTranslations[locale] = Map<String, String>.from(trans);
      }
    });

    // 如果已经初始化了GetX，则更新翻译
    if (Get.locale != null) {
      Get.clearTranslations();

      // 重新初始化翻译
      Get.addTranslations(IztroTranslationService.withAppTranslations().keys);

      // 更新当前语言
      final currentLocale = Get.locale;
      Get.updateLocale(currentLocale!);
    }
  }

  /// 初始化翻译服务
  ///
  /// 通常在app的main方法中调用，或者在GetMaterialApp前调用
  /// ```dart
  /// void main() {
  ///   IztroTranslationService.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  static void init({String? initialLocale}) {
    Get.config(enableLog: false);

    if (initialLocale != null) {
      Get.locale = _getLocaleFromString(initialLocale);
    }
  }

  /// 设置当前语言
  ///
  /// 使用ISO代码，例如：'zh_CN', 'en_US'
  static void changeLocale(String locale) {
    Get.updateLocale(_getLocaleFromString(locale));
  }

  /// 获取当前语言
  static Locale? get currentLocale => Get.locale;

  /// 获取当前语言的代码
  static String get currentLanguageCode => Get.locale?.languageCode ?? 'zh';

  /// 获取当前国家代码
  static String get currentCountryCode => Get.locale?.countryCode ?? 'CN';

  /// 从字符串解析Locale对象
  static Locale _getLocaleFromString(String localeString) {
    final List<String> parts = localeString.split('_');
    print('getlocal from str $localeString');
    if (parts.length > 1) {
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(parts[0]);
    }
  }

  /// 支持的语言列表
  static final List<Map<String, dynamic>> supportedLocales = [
    {'name': '简体中文', 'locale': 'zh_CN'},
    {'name': '繁體中文', 'locale': 'zh_TW'},
    {'name': 'English', 'locale': 'en_US'},
    {'name': '日本語', 'locale': 'ja_JP'},
    {'name': '한국어', 'locale': 'ko_KR'},
    {'name': 'ภาษาไทย', 'locale': 'th_TH'},
    {'name': 'Tiếng Việt', 'locale': 'vi_VN'},
  ];
}
