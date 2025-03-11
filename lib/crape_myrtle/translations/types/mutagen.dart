import 'package:get/get.dart';

enum Mutagen {
  siHuaLu,
  siHuaQuan,
  siHuaKe,
  siHuaJi,
}

extension MutagenEx on Mutagen {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

/// 将字符串转为宫位四化
Mutagen getMyMutagenFrom(String str) {
  return Mutagen.values.firstWhere((e) => e.key == str,
      orElse: () => throw ArgumentError("Invalid mutagen string"));
}
