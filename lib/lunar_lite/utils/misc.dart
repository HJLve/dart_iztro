import 'package:lunar/calendar/LunarMonth.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/earthly_branch.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';

/// 获取星座
/// @solarDateStr 阳历日期
String getSign(DateTime date) {
  return "${Solar.fromYmd(date.year, date.month, date.day).getXingZuo()}座";
}

/// 通过年支获取生肖
String getZodiac(EarthlyBranchName earthlyBranchOfYear) {
  return zodic.elementAt(earthlyBranches.indexOf(earthlyBranchOfYear.key));
}

/// 根据传入阳历日期获取该月农历月份天数
int getTotalDaysOfLunarMonth(String dateStr) {
  var lunarDate = solar2Lunar(dateStr);
  var month = LunarMonth.fromYm(lunarDate.lunarYear,
      lunarDate.isLeap ? 0 - lunarDate.lunarMonth : lunarDate.lunarMonth);
  return month?.getDayCount() ?? 0;
}
