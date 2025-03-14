# dart_iztro

[English](README.md) | [简体中文](README.zh_CN.md) | [繁體中文](README.zh_TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [ภาษาไทย](README.th.md) | [Tiếng Việt](README.vi.md)

다중 플랫폼을 지원하는 자미두수(紫微斗數)와 팔자(八字) 계산 Flutter 플러그인. 자미두수 별자리와 팔자 계산 기능을 제공하며, 음력과 양력 전환을 지원하고, 운명 분석, 점술 및 별자리 분석 응용 프로그램에 사용할 수 있습니다.

> **면책 조항**: 이 프로젝트 코드는 [@SylarLong/iztro](https://github.com/SylarLong/iztro)에서 파생되었습니다. 원작자의 오픈 소스 기여에 감사드립니다.

> **문서**: 전체 문서는 [https://iztro.com](https://iztro.com)에서 확인할 수 있습니다([@SylarLong/iztro](https://github.com/SylarLong/iztro)를 기반으로 함).

## 주요 기능

- 양력 날짜에서 음력 날짜 계산
- 팔자 정보 계산
- 자미두수 별자리 차트 정보 계산
- 별자리 각 궁위의 상세 정보 제공
- 정확한 진태양시 계산(천문학적 알고리즘 기반)
- 지리적 위치 조회 및 위도 경도 정보
- 다중 플랫폼 지원: Android, iOS, macOS, Windows, Linux 및 웹
- 다국어 지원: 간체 중국어, 번체 중국어, 영어, 일본어, 한국어, 태국어, 베트남어

## 완료된 기능

- ✅ 기본 팔자 계산
- ✅ 자미두수 별자리 차트 계산
- ✅ 음력 및 양력 변환
- ✅ 다국어 지원
- ✅ 진태양시 계산
- ✅ 지리적 위치 정보 조회
- ✅ 크로스 플랫폼 지원(Android, iOS, macOS, Windows, Linux, 웹)
- ✅ 자세한 궁위 정보

## 로드맵

- 🔲 전통적인 중국 나이 계산(허세) 지원
- 🔲 자미두수의 천반, 인반, 지반 데이터 검색 지원

## 설치

```yaml
dependencies:
  dart_iztro: ^0.1.0
```

## 대체 설치 방법

pub.dev에서 설치하는 데 문제가 있는 경우 Git 종속성을 통해 설치할 수 있습니다:

```yaml
dependencies:
  dart_iztro:
    git:
      url: https://github.com/EdwinXiang/dart_iztro.git
      ref: v0.1.0
```

## 사용 방법

```dart
import 'package:dart_iztro/dart_iztro.dart';

// 인스턴스 생성
final iztro = DartIztro();

// 팔자 정보 얻기
final birthData = await iztro.calculateBaZi(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 음력 여부
  isLeap: true,   // 음력인 경우 윤달 조정 여부(기본값은 true)
  gender: Gender.male,
);

// 자미두수 점성술 차트 얻기
final chart = await iztro.calculateChart(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 음력 여부
  isLeap: true,   // 음력인 경우 윤달 조정 여부(기본값은 true)
  gender: Gender.male,
);

// 언어 설정
// 다양한 언어 지원, 기본값은 중국어 간체(zh_CN)
await iztro.setLanguage('en_US'); // 영어
await iztro.setLanguage('zh_TW'); // 중국어 번체
await iztro.setLanguage('ja_JP'); // 일본어
await iztro.setLanguage('ko_KR'); // 한국어
await iztro.setLanguage('th_TH'); // 태국어
await iztro.setLanguage('vi_VN'); // 베트남어

// 궁위 정보 출력
print(chart.palaces);
```

### 실태양시간 계산

이 라이브러리는 지구의 타원형 궤도와 지축 기울기 같은 요소를 고려한 천문학적 알고리즘에 기반하여 정확한 실태양시간 계산 기능을 제공합니다:

```dart
import 'package:dart_iztro/utils/solar_time_util.dart';

// 날짜 시간 객체 생성
final solarTime = SolarTime(
  2023, // 년
  6,    // 월
  15,   // 일
  12,   // 시
  30,   // 분
  0     // 초
);

// 위치의 경도와 위도를 지정하여 태양시간 계산 유틸리티 생성(베이징)
final solarTimeUtil = SolarTimeUtil(
  longitude: 116.4074, // 경도, 동경은 양수, 서경은 음수
  latitude: 39.9042    // 위도, 북위는 양수, 남위는 음수
);

// 평균 태양시간 계산
final meanSolarTime = solarTimeUtil.getMeanSolarTime(solarTime);

// 실태양시간 계산
final realSolarTime = solarTimeUtil.getRealSolarTime(solarTime);

// 결과 출력
print('평균 태양시간: ${meanSolarTime.toString()}');
print('실태양시간: ${realSolarTime.toString()}');
```

### 지리적 위치 조회

이 라이브러리는 주소를 통해 위도와 경도를 조회하는 지리적 위치 조회 기능을 제공합니다:

```dart
import 'package:dart_iztro/services/geo_lookup_service.dart';

// 지리적 위치 조회 서비스 생성
final geoService = GeoLookupService();

// 주소 조회
final location = await geoService.lookupAddress('베이징시 하이뎬구');

if (location != null) {
  print('주소: ${location.displayName}');
  print('경도: ${location.longitude}');
  print('위도: ${location.latitude}');
}
```

### 매개변수 설명

- `year`, `month`, `day`, `hour`, `minute`: 출생 연, 월, 일, 시, 분
- `isLunar`: 음력 날짜 여부, 기본값은 양력(`false`)
- `isLeap`: `isLunar`가 `true`일 때 유효, 윤달 상황 처리 방법
  - `true`(기본값)로 설정하면 윤달의 전반부는 이전 달로, 후반부는 다음 달로 계산
  - `false`로 설정하면 윤달을 조정하지 않음
- `gender`: 성별, 열거형 사용, 가능한 값은 `Gender.male`(남성) 또는 `Gender.female`(여성)

## 추가 예제

더 많은 사용 예제는 example 폴더의 샘플 애플리케이션을 참조하세요.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

이 프로젝트는 원 프로젝트 [@SylarLong/iztro](https://github.com/SylarLong/iztro)와 동일한 오픈 소스 라이선스를 따릅니다. 저작권 관련 문제가 있는 경우 즉시 처리할 수 있도록 문의해 주세요.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 다국어 지원

이 라이브러리는 GetX 프레임워크를 사용하여 다국어 번역을 관리합니다. 다음은 다국어 기능을 사용하는 단계입니다:

### 1. 번역 서비스 초기화

애플리케이션 시작 시 번역 서비스를 초기화합니다:

```dart
void main() {
  // 번역 서비스 초기화, 초기 언어를 중국어로 설정
  IztroTranslationService.init(initialLocale: 'zh_CN');
  
  runApp(MyApp());
}
```

### 2. GetMaterialApp 사용

애플리케이션에서 MaterialApp 대신 GetMaterialApp을 사용해야 합니다:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 애플리케이션 구성
    );
  }
}
```

### 3. 언어 전환

언제든지 애플리케이션의 언어를 전환할 수 있습니다:

```dart
// 영어로 전환
IztroTranslationService.changeLocale('en_US');

// 중국어로 전환
IztroTranslationService.changeLocale('zh_CN');
```

### 4. 현재 언어 정보 가져오기

```dart
// 현재 언어의 Locale 객체 가져오기
Locale? locale = IztroTranslationService.currentLocale;

// 현재 언어 코드 가져오기
String languageCode = IztroTranslationService.currentLanguageCode;

// 현재 국가 코드 가져오기
String countryCode = IztroTranslationService.currentCountryCode;
```

### 5. 지원되는 언어

현재 지원되는 언어 목록:

```dart
List<Map<String, dynamic>> supportedLocales = IztroTranslationService.supportedLocales;
```

### 6. 애플리케이션 수준의 다국어 지원 통합

애플리케이션도 다국어 지원이 필요한 경우 애플리케이션의 번역과 라이브러리의 번역을 통합할 수 있습니다:

```dart
void main() {
  // 번역 서비스 초기화
  IztroTranslationService.init(initialLocale: 'zh_CN');
  
  // 애플리케이션 수준의 번역 추가
  IztroTranslationService.addAppTranslations({
    'zh_CN': {
      'app_name': '내 자미두수 앱',
      'welcome': '환영합니다',
      // 기타 애플리케이션 번역...
    },
    'en_US': {
      'app_name': 'My Zi Wei App',
      'welcome': 'Welcome',
      // 기타 애플리케이션 번역...
    },
  });
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 애플리케이션 번역을 통합한 번역 서비스 사용
      translations: IztroTranslationService.withAppTranslations(),
      locale: IztroTranslationService.currentLocale,
      fallbackLocale: const Locale('zh', 'CN'),
      title: 'app_name'.tr, // 애플리케이션 수준 번역
      home: HomePage(),
    );
  }
}
```

이렇게 하면 애플리케이션에서 라이브러리의 번역과 자체 번역을 모두 사용할 수 있습니다.

## 기여 가이드라인

`dart_iztro`에 관심이 있고 기여 팀에 참여하고 싶다면, 다음과 같은 방법으로 기여할 수 있습니다:

* 프로그램 기능에 대한 제안이 있다면, GitHub에서 '기능 요청'을 생성해 주세요.
* 프로그램에서 버그를 발견했다면, GitHub에서 '버그 보고서'를 생성해 주세요.
* 본 저장소를 자신의 저장소로 '포크'하여 편집한 후 본 저장소에 PR을 제출할 수도 있습니다.
* 외국어에 능숙하다면, 국제화 파일의 번역에 대한 기여도 환영합니다.

> **중요 안내**: 코드가 유용하다고 생각되면 ⭐을 눌러 지원해 주세요. 여러분의 ⭐은 제가 계속 업데이트하는 원동력입니다!

> **참고**: 이 오픈소스 코드를 합리적으로 사용하고, 불법적인 목적으로 사용하지 마세요.

## 후원 지원

이 프로젝트가 도움이 된다고 생각하시면, 커피 한 잔 ☕️을 후원해 주시는 것을 고려해 주세요.

<div style="display: flex; justify-content: space-around; margin: 20px 0;">
  <div style="text-align: center;">
    <img src="./alipay.jpg" width="300" alt="알리페이 QR 코드" />
    <p>알리페이</p>
  </div>
  <div style="text-align: center;">
    <img src="./wechat_pay.jpg" width="300" alt="위챗페이 QR 코드" />
    <p>위챗페이</p>
  </div>
</div> 