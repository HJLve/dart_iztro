import 'package:dart_iztro/crape_myrtle/tools/strings.dart';

/// 十天干信息
/// 其中包含：
/// 1. 阴阳（yinYang）
/// 2. 五行（fiveElements）
/// 3. 天干相冲（crash）
///    - 甲庚相冲
///    - 乙辛相冲
///    - 壬丙相冲
///    - 癸丁相冲
///    - 戊己土居中央，故无冲。
/// 4. 紫微斗数十天干四化(mutagen)
///
///    顺序为【禄，权，科，忌】
///    - 甲:【廉，破，武，阳】
///    - 乙:【机，梁，紫，月】
///    - 丙:【同，机，昌，廉】
///    - 丁:【阴，同，机，巨】
///    - 戊:【贪，月，弼，机】
///    - 己:【武，贪，梁，曲】
///    - 庚:【阳，武，阴，同】
///    - 辛:【巨，日，曲，昌】
///    - 壬:【梁，紫，左，武】
///    - 癸:【破，巨，阴，贪】
const Map<String, Map<String, dynamic>> heavenlyStemsMap = {
  jiaHeavenly: {
    'yinYang': '阳',
    'fiveElements': '木',
    'crash': gengHeavenly,
    'mutagen': [lianZhenMaj, poJunMaj, wuQuMaj, taiYangMaj],
  },
  yiHeavenly: {
    'yinYang': '阴',
    'fiveElements': '木',
    'crash': xinHeavenly,
    'mutagen': [tianJiMaj, tianLiangMaj, ziWeiMaj, taiYinMaj],
  },
  'bingHeavenly': {
    'yinYang': '阳',
    'fiveElements': '火',
    'crash': renHeavenly,
    'mutagen': [tianTongMaj, tianJiMaj, wenChangMin, lianZhenMaj],
  },
  'dingHeavenly': {
    'yinYang': '阴',
    'fiveElements': '火',
    'crash': guiHeavenly,
    'mutagen': [taiYinMaj, tianTongMaj, tianJiMaj, juMenMaj],
  },
  'wuHeavenly': {
    'yinYang': '阳',
    'fiveElements': '土',
    'mutagen': [tanLangMaj, taiYinMaj, youBiMin, tianJiMaj],
  },
  'jiHeavenly': {
    'yinYang': '阴',
    'fiveElements': '土',
    'mutagen': [wuQuMaj, tanLangMaj, tianLiangMaj, wenQuMin],
  },
  'gengHeavenly': {
    'yinYang': '阳',
    'fiveElements': '金',
    'crash': jiaHeavenly,
    'mutagen': [taiYangMaj, wuQuMaj, taiYinMaj, tianTongMaj],
  },
  'xinHeavenly': {
    'yinYang': '阴',
    'fiveElements': '金',
    'crash': yiHeavenly,
    'mutagen': [juMenMaj, taiYangMaj, wenQuMin, wenChangMin],
  },
  'renHeavenly': {
    'yinYang': '阳',
    'fiveElements': '水',
    'crash': bingHeavenly,
    'mutagen': [tianLiangMaj, ziWeiMaj, zuoFuMin, wuQuMaj],
  },
  'guiHeavenly': {
    'yinYang': '阴',
    'fiveElements': '水',
    'crash': dingHeavenly,
    'mutagen': [poJunMaj, juMenMaj, taiYinMaj, tanLangMaj],
  },
};
