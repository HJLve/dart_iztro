import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/lunar.dart';

/// 农历日期对象
///
/// @property
/// - lunarYear 年
/// - lunarMonth 月
/// - lunarDay 日
/// - isLeap 月份是否闰月
///
/// @function toString() 输出 YYYY-M-D 或 农历中文 字符串
class LunarDate {
  Lunar lunarDate;
  int lunarYear; // 农历年
  int lunarMonth; // 农历月
  int lunarDay; // 农历日
  bool isLeap; // 是否闰月

  LunarDate({
    required this.lunarDate,
    required this.lunarYear,
    required this.lunarMonth,
    required this.lunarDay,
    required this.isLeap,
  });

  /// 转化为字符串
  ///
  /// @param toCnStr 是否使用中文字符串, 若该参数为false则字符串中不会携带闰月信息
  /// @returns string
  /// @example
  /// lunarYear = 2023;
  /// lunarMonth = 6;
  /// lunarDay = 12;
  /// isLeap = true;
  ///
  /// toString(); // 2023-6-12
  /// toString(true); // 二〇二三年闰二月十一
  String toChString(bool toChStr) {
    // TODO: implement toString
    if (toChStr) {
      return lunarDate.toString();
    }
    return "$lunarYear-$lunarMonth-$lunarDay";
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$lunarYear-$lunarMonth-$lunarDay";
  }
}

/// 阳历日期对象
///
/// @property
/// - solarYear 年
/// - solarMonth 月
/// - solarDay 日
///
/// @function toString() 将对象以 YYYY-M-D 格式字符串输出
class SolarDate {
  int solarYear; // 公历年
  int solarMonth; // 公历月
  int solarDay; // 公历日

  SolarDate({
    required this.solarYear,
    required this.solarMonth,
    required this.solarDay,
  });

  /// 转化为字符串
  ///
  /// @returns string
  /// @example
  /// solarYear = 2023;
  /// solarMonth = 6;
  /// solarDay = 12;
  ///
  /// toString(); // 2023-6-12
  @override
  String toString() {
    final result = "$solarYear-$solarMonth-$solarDay";
    final list = result.split('-');
    return "${list[0]}-${list[1].padLeft(2, '0')}-${list[2].padLeft(2, '0')}";
  }
}

class HeavenlyStemAndEarthlyBranchDate {
  List<String> yearly;
  List<String> monthly;
  List<String> daily;
  List<String> hourly;

  HeavenlyStemAndEarthlyBranchDate({
    required this.yearly,
    required this.monthly,
    required this.daily,
    required this.hourly,
  });

  @override
  String toString() {
    var years = yearly.join();
    var months = monthly.join();
    var days = daily.join();
    var hours = hourly.join();
    return "$years $months $days $hours";
  }

  /// 将对象转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'yearly': yearly,
      'monthly': monthly,
      'daily': daily,
      'hourly': hourly,
    };
  }
}
