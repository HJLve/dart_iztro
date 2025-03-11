import 'dart:math';

import 'package:lunar/calendar/Solar.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';
import 'package:dart_iztro/lunar_lite/utils/types.dart';

/// 通过农历获取生辰干支
///
/// @param dateStr 农历日期 YYYY-MM-DD
/// @param timeIndex 时辰索引【0～12】
/// @param isLeap 是否为闰月
/// @returns HeavenlyStemAndEarthlyBranchResult
HeavenlyStemAndEarthlyBranchDate getHeavenlyStemAndEarthlyBranchLunarDate(
  String dateStr,
  int timeIndex,
  bool isLeap,
  DivideType? option,
) {
  option ??= DivideType.normal;
  var solarDate = lunar2Solar(dateStr, isLeap);

  return getHeavenlyStemAndEarthlyBranchSolarDate(
    solarDate.toString(),
    timeIndex,
    option,
  );
}

/// 将阳历转化为干支纪年
///
/// @param dateStr 公历日期 YYYY-MM-DD
/// @param timeIndex 时辰索引【0～12】
/// @returns HeavenlyStemAndEarthlyBranchResult
HeavenlyStemAndEarthlyBranchDate getHeavenlyStemAndEarthlyBranchSolarDate(
  String dateStr,
  int timeIndex,
  DivideType? option,
) {
  option ??= DivideType.exact;
  final dates = parseDate(dateStr);
  final year = dates[0];
  final month = dates[1];
  final day = dates[2];
  var solar = Solar.fromYmdHms(
    year,
    month,
    day,
    max(timeIndex * 2 - 1, 0),
    30,
    0,
  );
  var lunar = solar.getLunar();
  var yearlyGan =
      option == DivideType.normal
          ? lunar.getYearGan()
          : lunar.getYearGanByLiChun();
  var yearlyZhi =
      option == DivideType.normal
          ? lunar.getYearZhi()
          : lunar.getYearZhiByLiChun();

  var yearly = [yearlyGan, yearlyZhi];
  var monthly = [lunar.getMonthGanExact(), lunar.getMonthZhiExact()];
  var daily = [lunar.getDayGanExact(), lunar.getDayZhiExact()];
  var hourly = [lunar.getTimeGan(), lunar.getTimeZhi()];
  return HeavenlyStemAndEarthlyBranchDate(
    yearly: yearly,
    monthly: monthly,
    daily: daily,
    hourly: hourly,
  );
}
