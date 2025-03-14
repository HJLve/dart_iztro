import 'package:flutter_test/flutter_test.dart';
import 'package:dart_iztro/lunar_lite/utils/convertor.dart';
import 'package:dart_iztro/lunar_lite/utils/ganzhi.dart';
import 'package:dart_iztro/crape_myrtle/data/types/astro.dart';

void main() {
  group("Test lunar-lite test", () {
    test("test solar2lunar functions", () {
      const Map<String, dynamic> dates = {
        "2023-7-29": {
          "date": "二〇二三年六月十二",
          "date2": "2023-6-12",
          "isLeap": false,
        },
        "2023-4-1": {
          "date": "二〇二三年闰二月十一",
          "date2": "2023-2-11",
          "isLeap": true,
        },
        "2023-4-20": {
          "date": "二〇二三年三月初一",
          "date2": "2023-3-1",
          "isLeap": false,
        },
        "2023-3-21": {
          "date": "二〇二三年二月三十",
          "date2": "2023-2-30",
          "isLeap": false,
        },
        "2023-1-22": {
          "date": "二〇二三年正月初一",
          "date2": "2023-1-1",
          "isLeap": false,
        },
        "2023-1-21": {
          "date": "二〇二二年腊月三十",
          "date2": "2022-12-30",
          "isLeap": false,
        },
        "1900-03-01": {
          "date": "一九〇〇年二月初一",
          "date2": "1900-2-1",
          "isLeap": false,
        },
        "1921-08-01": {
          "date": "一九二一年六月廿八",
          "date2": "1921-6-28",
          "isLeap": false,
        },
        "2020-01-24": {
          "date": "二〇一九年腊月三十",
          "date2": "2019-12-30",
          "isLeap": false,
        },
        "2020-01-25": {
          "date": "二〇二〇年正月初一",
          "date2": "2020-1-1",
          "isLeap": false,
        },
        "1996-07-15": {
          "date": "一九九六年五月三十",
          "date2": "1996-5-30",
          "isLeap": false,
        },
        "1996-07-16": {
          "date": "一九九六年六月初一",
          "date2": "1996-6-1",
          "isLeap": false,
        },
        "1995-03-30": {
          "date": "一九九五年二月三十",
          "date2": "1995-2-30",
          "isLeap": false,
        },
      };

      for (final entry in dates.entries) {
        final date = entry.key;
        final expected = entry.value;

        final result = solar2Lunar(date);
        expect(result.toChString(true), equals(expected["date"]));
        expect(result.toString(), equals(expected["date2"]));
        expect(result.isLeap, equals(expected["isLeap"]));
      }
    });

    test("test convert invalid years", () {
      try {
        solar2Lunar("2102-1-22");
      } catch (error) {
        expect(
          (error as Exception).toString(),
          contains("year should be between 1900 and 2100"),
        );
      }

      try {
        solar2Lunar("1900-1-22");
      } catch (error) {
        expect(
          (error as Exception).toString(),
          contains("year should be between 1900 and 2100"),
        );
      }
    });

    test("test lunar2solar", () {
      const Map<String, Map<String, dynamic>> dates = {
        "2023-07-29": {"date": "2023-6-12", "isLeap": false},
        "2023-04-01": {"date": "2023-2-11", "isLeap": true},
        "2023-04-20": {"date": "2023-3-1", "isLeap": false},
        "2023-03-21": {"date": "2023-2-30", "isLeap": false},
        "2023-01-22": {"date": "2023-1-1", "isLeap": false},
        "2023-01-21": {"date": "2022-12-30", "isLeap": false},
        "1900-03-01": {"date": "1900-2-1", "isLeap": false},
        "1921-08-01": {"date": "1921-6-28", "isLeap": false},
        "2020-01-24": {"date": "2019-12-30", "isLeap": false},
        "2020-01-25": {"date": "2020-1-1", "isLeap": false},
        "2023-07-30": {"date": "2023-6-13", "isLeap": false},
        "1995-03-30": {"date": "1995-2-30", "isLeap": true},
      };

      for (final obj in dates.entries) {
        final key = obj.key;
        final Map<String, dynamic> value = obj.value;
        final result = lunar2Solar(value["date"], value["isLeap"]).toString();
        expect(result, key);
      }
    });

    test("test normalizeDateStr", () {
      const data = {
        "2023-12-1": [2023, 12, 1],
        "1998-01-02": [1998, 1, 2],
        "1987-1-08": [1987, 1, 8],
        "2016-08-18": [2016, 8, 18],
        "1986-7-15 12:23:59": [1986, 7, 15, 12, 23, 59],
        "1986.7/15 12:23:59": [1986, 7, 15, 12, 23, 59],
        "1986.07-15 12:23": [1986, 7, 15, 12, 23],
      };

      for (final entry in data.entries) {
        final dateStr = entry.key;
        final expected = entry.value;
        final result = normalDateFromStr(dateStr);
        expect(result, equals(expected));
      }
    });

    test("test ganzhi getHeavenlyStemAndEarthlyBranchLunarDate functions", () {
      const data = [
        {
          "date": "111-6-13",
          "timeIndex": 1,
          "isLeap": false,
          "result": "辛亥 乙未 庚寅 丁丑",
        },
        {
          "date": "1111-6-13",
          "timeIndex": 1,
          "isLeap": false,
          "result": "辛卯 乙未 甲辰 乙丑",
        },
        {
          "date": "2023-6-13",
          "timeIndex": 1,
          "isLeap": false,
          "result": "癸卯 己未 己丑 乙丑",
        },
        {
          "date": "2023-6-13",
          "timeIndex": 12,
          "isLeap": false,
          "result": "癸卯 己未 庚寅 丙子",
        },
        {
          "date": "2023-2-11",
          "timeIndex": 1,
          "isLeap": true,
          "result": "癸卯 乙卯 己丑 乙丑",
        },
        {
          "date": "2023-2-11",
          "timeIndex": 1,
          "isLeap": false,
          "result": "癸卯 甲寅 己未 乙丑",
        },
        {
          "date": "2023-1-1",
          "timeIndex": 1,
          "isLeap": false,
          "result": "壬寅 癸丑 庚辰 丁丑",
          "result2": "癸卯 癸丑 庚辰 丁丑",
        },
        {
          "date": "2022-12-30",
          "timeIndex": 1,
          "isLeap": false,
          "result": "壬寅 癸丑 己卯 乙丑",
        },
        {
          "date": "2023-1-29",
          "timeIndex": 12,
          "isLeap": false,
          "result": "癸卯 甲寅 己酉 甲子",
        },
      ];

      for (final item in data) {
        final date = item["date"] as String;
        final timeIndex = item["timeIndex"] as int;
        final isLeap = item["isLeap"] as bool;
        final expectedResult = item["result"] as String;
        final expectedResult2 = item["result2"] as String?;

        final result =
            getHeavenlyStemAndEarthlyBranchLunarDate(
              date,
              timeIndex,
              isLeap,
              DivideType.exact,
            ).toString();
        expect(result, equals(expectedResult));

        final result2 =
            getHeavenlyStemAndEarthlyBranchLunarDate(
              date,
              timeIndex,
              isLeap,
              DivideType.normal,
            ).toString();
        expect(result2, equals(expectedResult2 ?? expectedResult));
      }
    });

    test("test ganzhi getHeavenlyStemAndEarthlyBranchBySolarDate function", () {
      final data = [
        {'date': '2023-1-21', 'timeIndex': 1, 'result': '壬寅 癸丑 己卯 乙丑'},
        {'date': '2023-1-21', 'timeIndex': 12, 'result': '壬寅 癸丑 庚辰 丙子'},
        {'date': '2023-03-09', 'timeIndex': 5, 'result': '癸卯 乙卯 丙寅 癸巳'},
        {'date': '2023-4-8', 'timeIndex': 5, 'result': '癸卯 丙辰 丙申 癸巳'},
        {'date': '2023-1-22', 'timeIndex': 5, 'result': '壬寅 癸丑 庚辰 辛巳'},
        {'date': '2023-2-19', 'timeIndex': 12, 'result': '癸卯 甲寅 己酉 甲子'},
        {'date': '1987-12-6', 'timeIndex': 11, 'result': '丁卯 辛亥 己丑 乙亥'},
        {'date': '1987-12-6', 'timeIndex': 12, 'result': '丁卯 辛亥 庚寅 丙子'},
        {'date': '1983-4-22', 'timeIndex': 0, 'result': '癸亥 丙辰 庚辰 丙子'},
      ];

      for (final item in data) {
        final date = item['date'] as String;
        final timeIndex = item['timeIndex'] as int;
        final expectedResult = item['result'] as String;
        final result =
            getHeavenlyStemAndEarthlyBranchSolarDate(
              date,
              timeIndex,
              DivideType.exact,
            ).toString();
        expect(result, equals(expectedResult));
      }
    });
  });
}
