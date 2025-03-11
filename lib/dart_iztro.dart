import 'dart:async';

import 'package:flutter/material.dart';

import 'dart_iztro_platform_interface.dart';
export 'crape_myrtle/astro/astro.dart' hide config;
export 'crape_myrtle/astro/funcation_astrolabe.dart';
export 'crape_myrtle/astro/funcation_palace.dart';
export 'crape_myrtle/astro/palace.dart';
export 'crape_myrtle/astro/yearly_stems_branches.dart';
export 'crape_myrtle/astro/analyzer.dart';
export 'crape_myrtle/astro/funcation_horoscope.dart';
export 'crape_myrtle/astro/funcation_surpalaces.dart';

export 'crape_myrtle/star/location.dart';
export 'crape_myrtle/star/decorative_star.dart';
export 'crape_myrtle/star/horoscope_star.dart';
export 'crape_myrtle/star/funcational_star.dart';
export 'crape_myrtle/star/adjective_star.dart';
export 'crape_myrtle/star/minor_star.dart';
export 'crape_myrtle/star/major_star.dart';

export 'crape_myrtle/data/constants.dart';
export 'crape_myrtle/data/earth_branches.dart';
export 'crape_myrtle/data/heavenly_stems.dart';
export 'crape_myrtle/data/stars.dart';
export 'crape_myrtle/data/types/astro.dart';
export 'crape_myrtle/data/types/general.dart';
export 'crape_myrtle/data/types/palace.dart';
export 'crape_myrtle/data/types/star.dart';

export 'crape_myrtle/tools/crape_util.dart';
export 'crape_myrtle/tools/strings.dart';

export 'crape_myrtle/translations/types/brightness.dart';
export 'crape_myrtle/translations/types/earthly_branch.dart';
export 'crape_myrtle/translations/types/gender.dart';
export 'crape_myrtle/translations/types/heavenly_stem.dart';
export 'crape_myrtle/translations/types/star_name.dart';
export 'crape_myrtle/translations/types/five_element_class.dart';
export 'crape_myrtle/translations/types/palace.dart';
export 'crape_myrtle/translations/translation_service.dart';

export 'lunar_lite/utils/convertor.dart';
export 'lunar_lite/utils/ganzhi.dart';
export 'lunar_lite/utils/misc.dart';
export 'lunar_lite/utils/types.dart';
export 'lunar_lite/utils/utils.dart';

import 'crape_myrtle/astro/astro.dart';
import 'crape_myrtle/astro/funcation_astrolabe.dart';
import 'crape_myrtle/astro/funcation_palace.dart';
import 'crape_myrtle/astro/funcation_horoscope.dart';
import 'crape_myrtle/data/types/astro.dart';
import 'crape_myrtle/translations/types/gender.dart';
import 'lunar_lite/utils/ganzhi.dart';
import 'lunar_lite/utils/convertor.dart';

/// 紫微斗数计算插件
class DartIztro {
  /// 获取平台版本
  Future<String?> getPlatformVersion() {
    return DartIztroPlatform.instance.getPlatformVersion();
  }

  /// 计算八字信息
  ///
  /// [year] 年份
  /// [month] 月份
  /// [day] 日期
  /// [hour] 小时
  /// [minute] 分钟
  /// [isLunar] 是否农历日期
  /// [gender] 性别
  Future<Map<String, dynamic>> calculateBaZi({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    bool isLunar = false,
    required String gender,
  }) async {
    // 计算时辰索引
    final timeIndex = (hour / 2).floor();

    // 构建日期字符串
    final dateStr =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

    Map<String, dynamic> result = {};

    if (isLunar) {
      // 如果是农历，转换为阳历
      result =
          getHeavenlyStemAndEarthlyBranchLunarDate(
            dateStr,
            timeIndex,
            false,
            DivideType.exact,
          ).toJson();
    } else {
      // 阳历直接计算
      result =
          getHeavenlyStemAndEarthlyBranchSolarDate(
            dateStr,
            timeIndex,
            DivideType.exact,
          ).toJson();
    }

    // 添加性别信息
    result['gender'] = gender;

    return result;
  }

  /// 计算紫微斗数星盘
  ///
  /// [year] 年份
  /// [month] 月份
  /// [day] 日期
  /// [hour] 小时
  /// [minute] 分钟
  /// [isLunar] 是否农历日期
  /// [gender] 性别
  Future<Map<String, dynamic>> calculateChart({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    bool isLunar = false,
    required String gender,
  }) async {
    // 计算时辰索引
    final timeIndex = (hour / 2).floor();

    // 构建日期字符串
    final dateStr =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

    // 获取GenderName
    final genderName =
        gender.toLowerCase() == 'male' ? GenderName.male : GenderName.female;

    // 判断是阳历还是农历
    if (isLunar) {
      // 如果是农历，先转换为阳历
      final solarDate = lunar2Solar(dateStr, false);
      final solarDateStr = solarDate.toString();

      // 使用阳历创建星盘
      final astrolabe = bySolar(solarDateStr, timeIndex, genderName, true);
      final horoscope = astrolabe.horoscope(
        date: solarDateStr,
        timeIndex: timeIndex,
      );

      // 手动构造可序列化的Map，不调用toJson
      return {
        'palaces': astrolabe.palaces.map((p) => _palaceToJson(p)).toList(),
        'horoscope': _horoscopeToJson(horoscope),
        'info': {
          'gender': gender,
          'date': dateStr,
          'time': timeIndex,
          'isLunar': true,
        },
      };
    } else {
      // 直接使用阳历创建星盘
      final astrolabe = bySolar(dateStr, timeIndex, genderName, false);
      final horoscope = astrolabe.horoscope(
        date: dateStr,
        timeIndex: timeIndex,
      );

      // 手动构造可序列化的Map，不调用toJson
      return {
        'palaces': astrolabe.palaces.map((p) => _palaceToJson(p)).toList(),
        'horoscope': _horoscopeToJson(horoscope),
        'info': {
          'gender': gender,
          'date': dateStr,
          'time': timeIndex,
          'isLunar': false,
        },
      };
    }
  }

  // 帮助函数，用于将宫位对象转换为JSON格式
  Map<String, dynamic> _palaceToJson(IFunctionalPalace palace) {
    return {
      'name': palace.name.toString(),
      'index': palace.index,
      'earthlyBranch': palace.earthlyBranch.toString(),
      'majorStars':
          palace.majorStars.map((star) => star.name.toString()).toList(),
      'minorStars':
          palace.minorStars.map((star) => star.name.toString()).toList(),
      'adjectiveStars':
          palace.adjectiveStars.map((star) => star.name.toString()).toList(),
    };
  }

  // 帮助函数，用于将运势对象转换为JSON格式
  Map<String, dynamic> _horoscopeToJson(IFunctionalHoroscpoe horoscope) {
    return {
      'decadal': horoscope.decadal.toString(),
      'yearly': horoscope.yearly.toString(),
    };
  }
}
