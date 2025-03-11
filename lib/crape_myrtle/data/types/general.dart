import 'package:get/get.dart';
import 'package:dart_iztro/crape_myrtle/data/constants.dart';

/// 阴阳
enum YinYang { yin, yang }

extension YinYangEx on YinYang {
  String get title {
    switch (this) {
      case YinYang.yin:
        return "阴";
      case YinYang.yang:
        return "阳";
    }
  }
}

/// 定义五行
enum FiveElements { gold, wood, water, fire, earth }

extension FiveElementsEx on FiveElements {
  String get title {
    switch (this) {
      case FiveElements.gold:
        return "金";
      case FiveElements.wood:
        return "木";
      case FiveElements.water:
        return "水";
      case FiveElements.fire:
        return "火";
      case FiveElements.earth:
        return "土";
    }
  }
}

/// 时辰，子时分早晚
enum ChineseTime {
  earlyRatHour, // : '00:00~01:00',
  oxHour, // : '01:00~03:00',
  tigerHour, // : '03:00~05:00',
  rabbitHour, // : '05:00~07:00',
  dragonHour, // : '07:00~09:00',
  snakeHour, // : '09:00~11:00',
  horseHour, // : '11:00~13:00',
  goatHour, // : '13:00~15:00',
  monkeyHour, // : '15:00~17:00',
  roosterHour, // : '17:00~19:00',
  dogHour, // : '19:00~21:00',
  pigHour, // : '21:00~23:00',
  lateRatHour
}

extension ChineseTimeEx on ChineseTime {
  String? get timeRange {
    timeRanges[index];
  }
}

/// 范围：本命｜大限｜流年|流月|流日|流时
enum Scope { origin, decadal, yearly, monthly, daily, hourly }

extension ScopeEx on Scope {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

/// 星耀类型
enum StarType { major, soft, tough, adjective, flower, helper, luCun, tianMa }

extension StarTypeEx on StarType {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}
