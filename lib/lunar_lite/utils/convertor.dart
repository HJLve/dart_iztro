import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/LunarYear.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:dart_iztro/lunar_lite/utils/types.dart';

/// 将时间字符串转为时间
List<int> normalDateFromStr(dynamic dateStr) {
  if (dateStr is DateTime) {
    return [dateStr.year, dateStr.month + 1, dateStr.day];
  }
  return parseDate(dateStr);
}

List<int> parseDate(String date) {
  return date
      .split(RegExp(r'[ ]+'))
      .expand((item) => item.split(RegExp(r'[-:/.]')))
      .map((item) => (int.tryParse(item) ?? 0).abs())
      .toList();
}

/// 将阳历日期转为阴厉日期
LunarDate solar2Lunar(String date) {
  final dates = normalDateFromStr(date);
  var solar = Solar.fromYmd(dates[0], dates[1], dates[2]);
  var lunar = solar.getLunar();
  var lunarMonth = lunar.getMonth().abs();
  return LunarDate(
    lunarDate: lunar,
    lunarYear: lunar.getYear(),
    lunarMonth: lunarMonth,
    lunarDay: lunar.getDay(),
    isLeap: lunar.getMonth() < 0,
  );
}

SolarDate lunar2Solar(String dateStr, bool isLeapMonth) {
  var dates = normalDateFromStr(dateStr);
  final year = dates[0];
  final month = dates[1];
  final day = dates[2];
  var lunar = Lunar.fromYmd(year, month, day);
  var lunarYear = LunarYear.fromYear(lunar.getYear());
  var leapMonth = lunarYear.getLeapMonth();
  if (leapMonth > 0 && leapMonth == month && isLeapMonth) {
    lunar = Lunar.fromYmd(year, 0 - month, day);
  }

  var solar = lunar.getSolar();
  var solarYear = solar.getYear();
  var solarMonth = solar.getMonth();
  var solarDay = solar.getDay();
  return SolarDate(
    solarYear: solarYear,
    solarMonth: solarMonth,
    solarDay: solarDay,
  );
}
