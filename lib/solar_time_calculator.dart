import 'dart:math' as math;

/// 真太阳时计算工具类
///
/// 真太阳时是基于太阳在特定地点的实际位置来测量的时间。
/// 当太阳恰好经过观测点的子午线(正南或正北方向)时，真太阳时是12:00(正午)。
class SolarTimeCalculator {
  /// 计算真太阳时
  /// [dateTime] - 需要计算的日期时间(本地时间)
  /// [longitude] - 观测点经度，单位为度(东经为正，西经为负)
  /// [timeZoneOffset] - 时区偏移(小时)
  static DateTime calculateTrueSolarTime(
    DateTime dateTime,
    double longitude,
    double timeZoneOffset,
  ) {
    // 计算年中的天数(从0开始)
    int dayOfYear = _calculateDayOfYear(dateTime);

    // 计算时差方程(分钟)
    double eot = _calculateEquationOfTime(dayOfYear);

    // 经度修正(分钟) - 每经度4分钟
    double longitudeCorrection = 4 * (longitude - (timeZoneOffset * 15));

    // 总时间修正(分钟)
    double totalCorrection = eot + longitudeCorrection;

    // 将分钟转换为毫秒
    int correctionMs = (totalCorrection * 60 * 1000).round();

    // 应用修正得到真太阳时
    return dateTime.add(Duration(milliseconds: correctionMs));
  }

  /// 计算年中的天数(从0开始)
  static int _calculateDayOfYear(DateTime date) {
    DateTime startOfYear = DateTime(date.year, 1, 1);
    int dayOfYear = date.difference(startOfYear).inDays;
    return dayOfYear;
  }

  /// 计算时差方程(单位:分钟)
  /// 使用Spencer公式计算
  static double _calculateEquationOfTime(int dayOfYear) {
    // 将天数转换为弧度
    double b = 2 * math.pi * dayOfYear / 365;

    // Spencer公式计算时差(分钟)
    return 229.18 *
        (0.000075 +
            0.001868 * math.cos(b) -
            0.032077 * math.sin(b) -
            0.014615 * math.cos(2 * b) -
            0.040849 * math.sin(2 * b));
  }

  /// 计算太阳时角(单位:度)
  /// 时角是指太阳与观测点子午线的夹角，正午为0度
  static double calculateHourAngle(DateTime trueSolarTime) {
    // 计算小时部分(包括分和秒的小数部分)
    double hour =
        trueSolarTime.hour +
        trueSolarTime.minute / 60.0 +
        trueSolarTime.second / 3600.0;

    // 时角 = (小时 - 12) * 15
    // 每小时15度，正午(12点)为0度
    return (hour - 12) * 15;
  }

  /// 格式化真太阳时为字符串
  static String formatTrueSolarTime(DateTime trueSolarTime) {
    return "${trueSolarTime.hour.toString().padLeft(2, '0')}:"
        "${trueSolarTime.minute.toString().padLeft(2, '0')}:"
        "${trueSolarTime.second.toString().padLeft(2, '0')}";
  }
}
