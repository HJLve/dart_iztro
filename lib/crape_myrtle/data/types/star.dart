import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/brightness.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';

class Star {
  /// 星耀名字
  StarName name;

  /// 星耀类型（主星 | 吉星 | 煞星 | 杂耀 | 桃花星 | 解神 | 禄存 | 天马）
  StarType type;

  /// 作用范围（本命盘 | 大限盘 | 流年盘）
  Scope scope;

  /// 星耀亮度，若没有亮度数据则此字段为`空字符串`或者 `undefined`
  BrightnessEnum? brightness;

  /// 四化，若未产生四化则此字段为 `undefined`
  Mutagen? mutagen;

  Star(
      {required this.name,
      required this.type,
      required this.scope,
      this.brightness,
      this.mutagen});
}
