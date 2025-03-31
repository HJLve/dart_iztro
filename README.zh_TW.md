# dart_iztro

[English](README.md) | [简体中文](README.zh_CN.md) | [繁體中文](README.zh_TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [ภาษาไทย](README.th.md) | [Tiếng Việt](README.vi.md)

一個支援多平台的紫微斗數和八字計算Flutter插件。提供紫微斗數星盤和八字計算功能，支援農曆陽曆轉換，可用於命理、占卜和星盤分析應用。

> **聲明**：本專案程式碼源自[@SylarLong/iztro](https://github.com/SylarLong/iztro)，感謝原作者的開源貢獻。

> **文件**：完整文件請訪問 [https://iztro.com](https://iztro.com)（基於 [@SylarLong/iztro](https://github.com/SylarLong/iztro)）。

## 功能特點

- 根據陽曆日期計算農曆日期
- 計算八字信息
- 計算紫微斗數星盤信息
- 提供星盤各宮位的詳細信息
- 精確計算真太陽時（基於天文學算法）
- 地理位置查詢與經緯度信息
- 支援多平台：Android、iOS、macOS、Windows、Linux和Web
- 多語言支援：簡體中文、繁體中文、英語、日語、韓語、泰語、越南語

## 已完成功能

- ✅ 基礎八字計算
- ✅ 紫微斗數星盤計算
- ✅ 農曆陽曆轉換
- ✅ 多語言支援
- ✅ 真太陽時計算
- ✅ 地理位置信息查詢
- ✅ 跨平台支援（Android、iOS、macOS、Windows、Linux、Web）
- ✅ 宮位詳細信息

## 未來規劃

- 🔲 支持虛歲計算
- 🔲 支持紫微斗數天盤、人盤、地盤數據獲取

## 安裝

```yaml
dependencies:
  dart_iztro: ^2.4.9
```

## 備選安裝方式

如果從pub.dev安裝遇到問題，可以使用Git依賴方式安裝:

```yaml
dependencies:
  dart_iztro:
    git:
      url: https://github.com/EdwinXiang/dart_iztro.git
      ref: v2.4.9
```

## 使用方法

```dart
import 'package:dart_iztro/dart_iztro.dart';

// 創建實例
final iztro = DartIztro();

// 獲取八字信息
final birthData = await iztro.calculateBaZi(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 是否農曆
  isLeap: true,   // 如果是農曆，是否調整閏月（默認為true）
  gender: Gender.male,
);

// 獲取紫微斗數星盤
final chart = await iztro.calculateChart(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 是否農曆
  isLeap: true,   // 如果是農曆，是否調整閏月（默認為true）
  gender: Gender.male,
);

// 設置語言
// 支持多種語言，默認為簡體中文（zh_CN）
await iztro.setLanguage('en_US'); // 英語
await iztro.setLanguage('zh_TW'); // 繁體中文
await iztro.setLanguage('ja_JP'); // 日語
await iztro.setLanguage('ko_KR'); // 韓語
await iztro.setLanguage('th_TH'); // 泰語
await iztro.setLanguage('vi_VN'); // 越南語

// 打印宮位信息
print(chart.palaces);
```

### 計算真太陽時

本庫提供精確的真太陽時計算功能，基於天文學算法，考慮地球公轉軌道橢圓形狀、地軸傾斜等因素：

```dart
import 'package:dart_iztro/utils/solar_time_util.dart';

// 創建一個日期時間對象
final solarTime = SolarTime(
  2023, // 年
  6,    // 月
  15,   // 日
  12,   // 時
  30,   // 分
  0     // 秒
);

// 創建太陽時計算工具，指定位置的經緯度（北京）
final solarTimeUtil = SolarTimeUtil(
  longitude: 116.4074, // 經度，東經為正，西經為負
  latitude: 39.9042    // 緯度，北緯為正，南緯為負
);

// 計算平太陽時
final meanSolarTime = solarTimeUtil.getMeanSolarTime(solarTime);

// 計算真太陽時
final realSolarTime = solarTimeUtil.getRealSolarTime(solarTime);

// 輸出結果
print('平太陽時: ${meanSolarTime.toString()}');
print('真太陽時: ${realSolarTime.toString()}');
```

### 地理位置查詢

本庫提供地理位置查詢功能，支持通過地址查詢經緯度信息：

```dart
import 'package:dart_iztro/services/geo_lookup_service.dart';

// 創建地理位置查詢服務
final geoService = GeoLookupService();

// 查詢地址
final location = await geoService.lookupAddress('北京市海淀區');

if (location != null) {
  print('地址: ${location.displayName}');
  print('經度: ${location.longitude}');
  print('緯度: ${location.latitude}');
}
```

### 參數說明

- `year`、`month`、`day`、`hour`、`minute`: 出生的年、月、日、時、分
- `isLunar`: 是否為農曆日期，默認為陽曆（`false`）
- `isLeap`: 當`isLunar`為`true`時有效，用於處理閏月情況
  - 當設置為`true`時（默認值），閏月的前半個月算上個月，後半個月算下個月
  - 當設置為`false`時，不調整閏月
- `gender`: 性別，使用枚舉類型，可選值為`Gender.male`（男）或`Gender.female`（女）

## 更多示例

更多使用示例請查看 example 文件夾中的示例應用。

## 許可證

本專案採用 MIT 許可證 - 詳見 [LICENSE](LICENSE) 文件

本專案遵循與原專案 [@SylarLong/iztro](https://github.com/SylarLong/iztro) 相同的開源許可證。如有任何版權問題，請聯繫我們立即處理。

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 多語言支持

本庫使用GetX框架管理多語言翻譯。以下是使用多語言功能的步驟：

### 1. 初始化翻譯服務

在應用啟動時初始化翻譯服務：

```dart
void main() {
  // 初始化翻譯服務，設置初始語言為中文
  IztroTranslationService.init(initialLocale: 'zh_CN');
  
  runApp(MyApp());
}
```

### 2. 使用GetMaterialApp

確保在應用中使用GetMaterialApp而不是MaterialApp：

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 應用配置
    );
  }
}
```

### 3. 切換語言

可以隨時切換應用的語言：

```dart
// 切換到英文
IztroTranslationService.changeLocale('en_US');

// 切換到中文
IztroTranslationService.changeLocale('zh_CN');
```

### 4. 獲取當前語言信息

```dart
// 獲取當前語言的Locale對象
Locale? locale = IztroTranslationService.currentLocale;

// 獲取當前語言代碼
String languageCode = IztroTranslationService.currentLanguageCode;

// 獲取當前國家代碼
String countryCode = IztroTranslationService.currentCountryCode;
```

### 5. 支持的語言

目前支持的語言列表：

```dart
List<Map<String, dynamic>> supportedLocales = IztroTranslationService.supportedLocales;
```

### 6. 集成應用層的多語言支持

如果您的應用也需要多語言支持，可以將應用的翻譯與庫的翻譯集成在一起：

```dart
void main() {
  // 初始化翻譯服務
  IztroTranslationService.init(initialLocale: 'zh_CN');
  
  // 添加應用層的翻譯
  IztroTranslationService.addAppTranslations({
    'zh_CN': {
      'app_name': '我的紫微應用',
      'welcome': '歡迎使用',
      // 其他應用翻譯...
    },
    'en_US': {
      'app_name': 'My Zi Wei App',
      'welcome': 'Welcome',
      // 其他應用翻譯...
    },
  });
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 使用合併了應用翻譯的翻譯服務
      translations: IztroTranslationService.withAppTranslations(),
      locale: IztroTranslationService.currentLocale,
      fallbackLocale: const Locale('zh', 'CN'),
      title: 'app_name'.tr, // 應用層翻譯
      home: HomePage(),
    );
  }
}
```

這樣您就可以在應用中同時使用庫的翻譯和自己的翻譯。 

## 貢獻指南

如果你對`dart_iztro`有興趣，也想加入貢獻隊伍，我們非常歡迎，你可以用以下方式進行：

* 如果你對程序功能有什麼建議，請在GitHub創建一個`功能需求`。
* 如果你發現程序有BUG，請在GitHub創建一個`BUG報告`。
* 你也可以將本倉庫`fork`到你自己的倉庫進行編輯，然後提交PR到本倉庫。
* 假如你擅長外語，我們也歡迎你對國際化文件的翻譯做出你的貢獻。

> **重要提示**: 如果你覺得代碼對你有用，請點⭐支持，你的⭐是我持續更新的動力！

> **注意**: 請合理使用本開源代碼，禁止用於非法目的。

## 贊助支持

如果你覺得本項目對你有所幫助，可以考慮贊助我一杯咖啡 ☕️

<div style="display: flex; justify-content: space-around; margin: 20px 0;">
  <div style="text-align: center;">
    <img src="./alipay.jpg" width="300" alt="支付寶收款碼" />
    <p>支付寶</p>
  </div>
  <div style="text-align: center;">
    <img src="./wechat_pay.jpg" width="300" alt="微信收款碼" />
    <p>微信支付</p>
  </div>
</div> 