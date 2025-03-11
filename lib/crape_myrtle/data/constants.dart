/// 10 天干 甲乙丙丁，甲 | 乙 | 丙 | 丁 | 戊 | 己 | 庚 | 辛 | 壬 | 癸
const List<String> heavenlyStems = [
  'jiaHeavenly',
  'yiHeavenly',
  'bingHeavenly',
  'dingHeavenly',
  'wuHeavenly',
  'jiHeavenly',
  'gengHeavenly',
  'xinHeavenly',
  'renHeavenly',
  'guiHeavenly',
];

/// 十二地支 子 | 丑 | 寅 | 卯 | 辰 | 巳 | 午 | 未 | 申 | 酉 | 戌 | 亥
const List<String> earthlyBranches = [
  'ziEarthly',
  'chouEarthly',
  'yinEarthly',
  'maoEarthly',
  'chenEarthly',
  'siEarthly',
  'wuEarthly',
  'weiEarthly',
  'shenEarthly',
  'youEarthly',
  'xuEarthly',
  'haiEarthly',
];

/// 十二生肖
/// 鼠、牛、虎、兔、龙、蛇、马、羊、猴、鸡、狗、猪 与十二地支配对
/// 即子（鼠）、丑（牛）、寅（虎）、卯（兔）、辰（龙）、巳（蛇）、午（马）、未（羊）、申（猴）、酉（鸡）、戌（狗）、亥（猪）
const List<String> zodic = [
  'rat',
  'ox',
  'tiger',
  'rabbit',
  'dragon',
  'snake',
  'horse',
  'sheep',
  'monkey',
  'rooster',
  'dog',
  'pig',
];

/// 紫薇斗数十二宫
/// 是由命宫、兄弟宫、夫妻宫、子女宫、财帛宫、疾厄宫、迁移宫、奴仆宫、官禄宫、田宅宫、福德宫、父母宫这十二宫组成
const List<String> palaces = [
  'soulPalace',
  'parentsPalace',
  'spiritPalace',
  'propertyPalace',
  'careerPalace',
  'friendsPalace',
  'surfacePalace',
  'healthPalace',
  'wealthPalace',
  'childrenPalace',
  'spousePalace',
  'siblingsPalace',
];

/// 性别，对应阴阳，男为阳，女为阴
const Map<String, String> genderMap = {'male': "阳", 'female': '阴'};

/// 中国农历时间,时辰;其中 00:00-01:00 为早子时，23:00-00:00 为晚子时
const List<String> chineseTimes = [
  'earlyRatHour', // : '00:00~01:00',
  'oxHour', // : '01:00~03:00',
  'tigerHour', // : '03:00~05:00',
  'rabbitHour', // : '05:00~07:00',
  'dragonHour', // : '07:00~09:00',
  'snakeHour', // : '09:00~11:00',
  'horseHour', // : '11:00~13:00',
  'goatHour', // : '13:00~15:00',
  'monkeyHour', // : '15:00~17:00',
  'roosterHour', // : '17:00~19:00',
  'dogHour', // : '19:00~21:00',
  'pigHour', // : '21:00~23:00',
  'lateRatHour', // : '23:00~00:00',
];

/// 时辰序号所对应的时间段，与chineseTimes 一一对应
const List<String> timeRanges = [
  '00:00~01:00',
  '01:00~03:00',
  '03:00~05:00',
  '05:00~07:00',
  '07:00~09:00',
  '09:00~11:00',
  '11:00~13:00',
  '13:00~15:00',
  '15:00~17:00',
  '17:00~19:00',
  '19:00~21:00',
  '21:00~23:00',
  '23:00~00:00',
];

/// 五虎遁 从年干算月干。
///
/// “五虎遁元”年上起月法，简称 `五虎遁`。
/// 因为正月建寅，所以正月的地支为寅，寅属虎，所以叫五虎盾。
///
/// - 甲己之年丙作首
/// - 乙庚之岁戊为头
/// - 丙辛必定寻庚起
/// - 丁壬壬位顺行流
/// - 若问戊癸何方发
/// - 甲寅之上好追求
const Map<String, String> tigerRules = {
  'jiaHeavenly': 'bingHeavenly',
  'yiHeavenly': 'wuHeavenly',
  'bingHeavenly': 'gengHeavenly',
  'dingHeavenly': 'renHeavenly',
  'wuHeavenly': 'jiaHeavenly',
  'jiHeavenly': 'bingHeavenly',
  'gengHeavenly': 'wuHeavenly',
  'xinHeavenly': 'gengHeavenly',
  'renHeavenly': 'renHeavenly',
  'guiHeavenly': 'jiaHeavenly',
};

/// 五鼠遁 以日干算时干。
///
/// “五鼠遁元”日上起时法，简称 `五鼠遁`。
/// 因为日支全部以“子”时打头来排列的，子为鼠，所以叫五鼠遁。
///
/// - 甲己还加甲，乙庚丙作初。
/// - 丙辛从戊起，丁壬庚子居。
/// - 戊癸起壬子，周而复始求。
const Map<String, String> ratRules = {
  'jiaHeavenly': 'jiaHeavenly',
  'yiHeavenly': 'bingHeavenly',
  'bingHeavenly': 'wuHeavenly',
  'dingHeavenly': 'gengHeavenly',
  'wuHeavenly': 'renHeavenly',
  'jiHeavenly': 'jiaHeavenly',
  'gengHeavenly': 'bingHeavenly',
  'xinHeavenly': 'wuHeavenly',
  'renHeavenly': 'gengHeavenly',
  'guiHeavenly': 'renHeavenly',
};
