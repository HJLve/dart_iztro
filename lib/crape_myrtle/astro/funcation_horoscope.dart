import 'package:dart_iztro/crape_myrtle/astro/funcation_astrolabe.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_palace.dart';
import 'package:dart_iztro/crape_myrtle/astro/funcation_surpalaces.dart';
import 'package:dart_iztro/crape_myrtle/data/stars.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';
import 'package:dart_iztro/crape_myrtle/data/types/general.dart';
import 'package:dart_iztro/crape_myrtle/tools/crape_util.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/mutagen.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/palace.dart';
import 'package:dart_iztro/crape_myrtle/translations/types/star_name.dart';

abstract class IFunctionalHoroscpoe implements Horoscope {
  late IFunctionalAstrolabe astrolabe;

  /// 获取小限宫位
  IFunctionalPalace? agePalace();

  /// 获取运限宫位
  /// palaceName 宫位名称
  /// scope 指定获取那个运限的宫位
  IFunctionalPalace? palace(PalaceName palaceName, Scope scope);

  /// 获取运限指定宫位的三方四正宫位
  /// palaceName 宫位名称
  /// scope 指定获取那个运限的宫位
  IFunctionlSurpalaces? surroundPalace(PalaceName palaceName, Scope scope);

  /// 判断在指定运限的宫位内是否包含流耀，需要全部包含才返回true
  /// palaceName 宫位名称
  /// scope 指定获取那个运限的宫位
  /// horoscopeStar 流耀
  bool hasHotoscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscopeStar);

  /// 判断指定运限宫位内是否不含流耀，需要全部不包含才返回true
  /// palaceName 宫位名称
  /// scope 指定获取那个运限的宫位
  /// horoscopeStar 流耀
  bool nothaveHoroscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscope);

  /// 判断指定运限宫位内是否含有指定流耀，只要包含其中一颗酒返回true
  /// palaceName 宫位名称
  /// scope 指定获取那个运限的宫位
  /// horoscopeStar 流耀
  bool hasOneOfHoroscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscopeStar);

  /// 判断指定运限宫位内是否存在运限四化
  /// palaceName 宫位名称
  /// scope 指定获取哪个运限的宫位
  /// horoscopeMutagen 运限四化
  bool hasHoroscopeMutagen(
      PalaceName palaceName, Scope scope, Mutagen horoscopeMutagen);
}

class FunctionalHoroscope implements IFunctionalHoroscpoe {
  @override
  late AgeHoroscope age;

  @override
  late IFunctionalAstrolabe astrolabe;

  @override
  late HoroscopeItem daily;

  @override
  late HoroscopeItem decadal;

  @override
  late HoroscopeItem hourly;

  @override
  late String lunarDate;

  @override
  late HoroscopeItem monthly;

  @override
  late String solarDate;

  @override
  late YearlyHoroscope yearly;

  FunctionalHoroscope(Horoscope data, IFunctionalAstrolabe astrolabe) {
    lunarDate = data.lunarDate;
    solarDate = data.solarDate;
    decadal = data.decadal;
    age = data.age;
    yearly = data.yearly;
    monthly = data.monthly;
    daily = data.daily;
    hourly = data.hourly;
    astrolabe = astrolabe;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'age: $age, yearly: $yearly, monthly: $monthly, daily: $daily, hourly: $hourly, lunarDate: $lunarDate, solarDate: $solarDate';
  }

  @override
  IFunctionalPalace? agePalace() {
    // TODO: implement agePalace
    return astrolabe.palace(age.index);
  }

  @override
  bool hasHoroscopeMutagen(
      PalaceName palaceName, Scope scope, Mutagen horoscopeMutagen) {
    // TODO: implement hasHoroscopeMutagen
    if (scope == Scope.origin) {
      return false;
    }
    final palaceIndex = _getHoroscopePalaceIndex(this, scope, palaceName);
    final majorStars = astrolabe.palace(palaceIndex)?.majorStars ?? [];
    final minorStars = astrolabe.palace(palaceIndex)?.minorStars ?? [];
    final result = [
      [majorStars],
      [minorStars]
    ];
    final stars = mergeStars(result)[0].map((star) => star.name);
    final mutagenIndex = mutagenArray.indexOf(horoscopeMutagen.key);
    switch (scope) {
      case Scope.decadal:
        return stars.contains(decadal.mutagen[mutagenIndex]);
      case Scope.hourly:
        return stars.contains(hourly.mutagen[mutagenIndex]);
      case Scope.daily:
        return stars.contains(daily.mutagen[mutagenIndex]);
      case Scope.yearly:
        return stars.contains(yearly.mutagen[mutagenIndex]);
      case Scope.monthly:
        return stars.contains(monthly.mutagen[mutagenIndex]);
      case Scope.origin:
        return stars.contains(age.mutagen[mutagenIndex]);
    }
  }

  @override
  bool hasHotoscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscopeStar) {
    // TODO: implement hasHotoscopeStars
    if (decadal.stars == null || yearly.stars == null) {
      return false;
    }
    int palaceIndex = _getHoroscopePalaceIndex(this, scope, palaceName);
    final stars =
        mergeStars([decadal.stars ?? [], yearly.stars ?? []])[palaceIndex];
    final starKeys = stars.map((item) => item.name);
    return horoscopeStar.every((item) => starKeys.contains(item));
  }

  @override
  bool hasOneOfHoroscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscopeStar) {
    // TODO: implement hasOneOfHoroscopeStars
    if (decadal.stars == null || yearly.stars == null) {
      return false;
    }
    int palaceIndex = _getHoroscopePalaceIndex(this, scope, palaceName);
    final stars =
        mergeStars([decadal.stars ?? [], yearly.stars ?? []])[palaceIndex];
    final starKeys = stars.map((item) => item.name);
    return horoscopeStar.any((item) => starKeys.contains(item));
  }

  @override
  bool nothaveHoroscopeStars(
      PalaceName palaceName, Scope scope, List<StarName> horoscope) {
    // TODO: implement nothaveHoroscopeStars
    if (decadal.stars == null || yearly.stars == null) {
      return false;
    }
    int palaceIndex = _getHoroscopePalaceIndex(this, scope, palaceName);
    final stars =
        mergeStars([decadal.stars ?? [], yearly.stars ?? []])[palaceIndex];
    final starKeys = stars.map((item) => item.name);
    return horoscope.every((item) => !starKeys.contains(item));
  }

  @override
  IFunctionalPalace? palace(PalaceName palaceName, Scope scope) {
    // TODO: implement palace
    if (scope == Scope.origin) {
      return astrolabe.palace(palaceName);
    }
    var targetPalaceIndex = 0;
    switch (scope) {
      case Scope.origin:
        targetPalaceIndex = 0;
      case Scope.daily:
        targetPalaceIndex = daily.palaceNames.indexOf(palaceName);
      case Scope.decadal:
        targetPalaceIndex = decadal.palaceNames.indexOf(palaceName);
      case Scope.hourly:
        targetPalaceIndex = hourly.palaceNames.indexOf(palaceName);
      case Scope.monthly:
        targetPalaceIndex = monthly.palaceNames.indexOf(palaceName);
      case Scope.yearly:
        targetPalaceIndex = yearly.palaceNames.indexOf(palaceName);
    }
    return astrolabe.palace(targetPalaceIndex);
  }

  @override
  IFunctionlSurpalaces? surroundPalace(PalaceName palaceName, Scope scope) {
    // TODO: implement surroundPalace
    if (scope == Scope.origin) {
      return astrolabe.surroundedPalaces(palaceName);
    }
    var targetPalaceIndex = 0;
    switch (scope) {
      case Scope.origin:
        targetPalaceIndex = 0;
      case Scope.daily:
        targetPalaceIndex = daily.palaceNames.indexOf(palaceName);
      case Scope.decadal:
        targetPalaceIndex = decadal.palaceNames.indexOf(palaceName);
      case Scope.hourly:
        targetPalaceIndex = hourly.palaceNames.indexOf(palaceName);
      case Scope.monthly:
        targetPalaceIndex = monthly.palaceNames.indexOf(palaceName);
      case Scope.yearly:
        targetPalaceIndex = yearly.palaceNames.indexOf(palaceName);
    }
    return astrolabe.surroundedPalaces(targetPalaceIndex);
  }

  int _getHoroscopePalaceIndex(
      IFunctionalHoroscpoe horoscope, Scope scope, PalaceName palaceName) {
    var palaceIndex = -1;
    if (scope == Scope.origin) {
      astrolabe.palaces.where((palace) {
        final idx = astrolabe.palaces.indexOf(palace);
        if (palace.name == palaceName) {
          palaceIndex = idx;
          return true;
        }
        return false;
      });
    } else {
      if (scope == Scope.daily) {
        palaceIndex = daily.palaceNames.indexOf(palaceName);
      } else if (scope == Scope.monthly) {
        palaceIndex = monthly.palaceNames.indexOf(palaceName);
      } else if (scope == Scope.yearly) {
        palaceIndex = yearly.palaceNames.indexOf(
            palaceName); // origin, decadal, yearly, monthly, daily, hourly
      } else if (scope == Scope.decadal) {
        palaceIndex = decadal.palaceNames.indexOf(palaceName);
      } else if (scope == Scope.hourly) {
        palaceIndex = hourly.palaceNames.indexOf(palaceName);
      }
    }
    return palaceIndex;
  }
}
