import 'package:dart_iztro/crape_myrtle/tools/strings.dart';

/// 紫薇斗数四化
const mutagenArray = ['siHuaLu', 'siHuaQuan', 'siHuaKe', 'siHuaJi'];

/**
 * 星耀信息 在 紫微星 的队伍里，有6名队员，他们分别是：
    紫微星
    天机星
    太阳星
    武曲星
    天同星
    廉贞星
    在 天府星 的队伍里，有8名队员，他们分别是：
    天府星
    太阴星
    贪狼星
    巨门星
    天相星
    天梁星
    七杀星
    破军星
 * 其中包含：
 * 1. 亮度（bright）, 按照宫位地支排序（从寅开始）
 * 2. 五行（fiveElements）
 * 3. 阴阳（yinYang）
 */
const Map<String, Map<String, dynamic>> starsInfo = {
  ziWeiMaj: {
    'brightness': [
      'wang',
      'wang',
      'de',
      'wang',
      'miao',
      'miao',
      'wang',
      'wang',
      'de',
      'wang',
      'ping',
      'miao'
    ],
    'fiveElements': '土',
    'yinYang': '阴',
  },
  tianJiMaj: {
    'brightness': [
      'de',
      'wang',
      'li',
      'ping',
      'miao',
      'xian',
      'de',
      'wang',
      'li',
      'ping',
      'miao',
      'xian'
    ],
    'fiveElements': '木',
    'yinYang': '阴',
  },
  taiYangMaj: {
    'brightness': [
      'wang',
      'miao',
      'wang',
      'wang',
      'wang',
      'de',
      'de',
      'xian',
      'bu',
      'xian',
      'xian',
      'bu'
    ],
    'fiveElements': '',
    'yinYang': '',
  },
  wuQuMaj: {
    'brightness': [
      'de',
      'li',
      'miao',
      'ping',
      'wang',
      'miao',
      'de',
      'li',
      'miao',
      'ping',
      'wang',
      'miao'
    ],
    'fiveElements': '金',
    'yinYang': '阴',
  },
  tianTongMaj: {
    'brightness': [
      'li',
      'ping',
      'ping',
      'miao',
      'xian',
      'bu',
      'wang',
      'ping',
      'ping',
      'miao',
      'wang',
      'bu'
    ],
    'fiveElements': '水',
    'yinYang': '阳',
  },
  lianZhenMaj: {
    'brightness': [
      'miao',
      'ping',
      'li',
      'xian',
      'ping',
      'li',
      'miao',
      'ping',
      'li',
      'xian',
      'ping',
      'li'
    ],
    'fiveElements': '火',
    'yinYang': '阴',
  },
  tianFuMaj: {
    'brightness': [
      'miao',
      'de',
      'miao',
      'de',
      'wang',
      'miao',
      'de',
      'wang',
      'miao',
      'de',
      'miao',
      'miao'
    ],
    'fiveElements': '土',
    'yinYang': '阳',
  },
  taiYinMaj: {
    'brightness': [
      'wang',
      'xian',
      'xian',
      'xian',
      'bu',
      'bu',
      'li',
      'bu',
      'wang',
      'miao',
      'miao',
      'miao'
    ],
    'fiveElements': '水',
    'yinYang': '阴',
  },
  tanLangMaj: {
    'brightness': [
      'ping',
      'li',
      'miao',
      'xian',
      'wang',
      'miao',
      'ping',
      'li',
      'miao',
      'xian',
      'wang',
      'miao'
    ],
    'fiveElements': '水',
    'yinYang': '',
  },
  juMenMaj: {
    'brightness': [
      'miao',
      'miao',
      'xian',
      'wang',
      'wang',
      'bu',
      'miao',
      'miao',
      'xian',
      'wang',
      'wang',
      'bu'
    ],
    'fiveElements': '土',
    'yinYang': '阴',
  },
  tianXiangMaj: {
    'brightness': [
      'miao',
      'xian',
      'de',
      'de',
      'miao',
      'de',
      'miao',
      'xian',
      'de',
      'de',
      'miao',
      'miao'
    ],
    'fiveElements': '水',
    'yinYang': '',
  },
  tianLiangMaj: {
    'brightness': [
      'miao',
      'miao',
      'miao',
      'xian',
      'miao',
      'wang',
      'xian',
      'de',
      'miao',
      'xian',
      'miao',
      'wang'
    ],
    'fiveElements': '土',
    'yinYang': '',
  },
  qiShaMaj: {
    'brightness': [
      'miao',
      'wang',
      'miao',
      'ping',
      'wang',
      'miao',
      'miao',
      'miao',
      'miao',
      'ping',
      'wang',
      'miao'
    ],
    'fiveElements': '',
    'yinYang': '',
  },
  poJunMaj: {
    'brightness': [
      'de',
      'xian',
      'wang',
      'ping',
      'miao',
      'wang',
      'de',
      'xian',
      'wang',
      'ping',
      'miao',
      'wang'
    ],
    'fiveElements': '水',
    'yinYang': '',
  },
  wenChangMin: {
    'brightness': [
      'xian',
      'li',
      'de',
      'miao',
      'xian',
      'li',
      'de',
      'miao',
      'xian',
      'li',
      'de',
      'miao'
    ],
  },
  wenQuMin: {
    'brightness': [
      'ping',
      'wang',
      'de',
      'miao',
      'xian',
      'wang',
      'de',
      'miao',
      'xian',
      'wang',
      'de',
      'miao'
    ],
  },
  huoXingMin: {
    'brightness': [
      'miao',
      'li',
      'xian',
      'de',
      'miao',
      'li',
      'xian',
      'de',
      'miao',
      'li',
      'xian',
      'de'
    ],
  },
  lingXingMin: {
    'brightness': [
      'miao',
      'li',
      'xian',
      'de',
      'miao',
      'li',
      'xian',
      'de',
      'miao',
      'li',
      'xian',
      'de'
    ],
  },
  qingYangMin: {
    'brightness': [
      '',
      'xian',
      'miao',
      '',
      'xian',
      'miao',
      '',
      'xian',
      'miao',
      '',
      'xian',
      'miao'
    ],
  },
  tuoLuoMin: {
    'brightness': [
      'xian',
      '',
      'miao',
      'xian',
      '',
      'miao',
      'xian',
      '',
      'miao',
      'xian',
      '',
      'miao'
    ],
  },
};
