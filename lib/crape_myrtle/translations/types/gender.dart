import 'package:get/get.dart';

enum GenderName {
  male,
  female,
}

extension GenderEx on GenderName {
  String get title {
    return toString().split('.').last.tr;
  }

  String get key {
    return toString().split('.').last;
  }
}

GenderName getMyGenderFrom(String str) {
  var isContainStr = false;
  for (int i = 0; i < GenderName.values.length; i++) {
    final value = GenderName.values[i];
    if (value.key == str) {
      isContainStr = true;
      break;
    }
  }
  if (isContainStr) {
    return GenderName.values.firstWhere((e) => e.key == str,
        orElse: () => throw ArgumentError('invalid GenderName str'));
  } else {
    return GenderName.values.firstWhere((e) => e.title == str,
        orElse: () => throw ArgumentError('invalid GenderName name string'));
  }
}
