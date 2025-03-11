import 'package:get/get.dart';

/// 五行局，用于定紫微星和算起运年龄
/// 几局就从几岁（虚岁）开始起运
/// 比如 木三局 就从3岁开始起运
///
/// @enum
///  - 2 水二局
///  - 3 木三局
///  - 4 金四局
///  - 5 土五局
///  - 6 火六局
enum FiveElementsFormat {
  water2nd(2),
  wood3rd(3),
  metal4th(4),
  earth5th(5),
  fire6th(6);

  final int value;
  const FiveElementsFormat(this.value);

  static FiveElementsFormat fiveElementFrom(String str) {
    switch (str) {
      case 'water2nd':
        return FiveElementsFormat.water2nd;
      case 'wood3rd':
        return FiveElementsFormat.wood3rd;
      case 'metal4th':
        return FiveElementsFormat.metal4th;
      case 'earth5th':
        return FiveElementsFormat.earth5th;
      case 'fire6th':
        return FiveElementsFormat.fire6th;
      default:
        throw ArgumentError('传入的参数错误');
    }
  }
}

extension FiveElementFormatEx on FiveElementsFormat {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}
