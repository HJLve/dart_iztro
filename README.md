# dart_iztro

一个紫微斗数计算的Flutter插件，支持多平台（Android、iOS、macOS、Windows和Web）。

## 功能特点

- 根据阳历日期计算农历日期
- 计算八字信息
- 计算紫微斗数星盘信息
- 提供星盘各宫位的详细信息
- 支持多平台：Android、iOS、macOS、Windows和Web

## 安装

将以下内容添加到您的 pubspec.yaml 文件中：

```yaml
dependencies:
  dart_iztro: ^0.0.1
```

然后运行：

```bash
flutter pub get
```

## 使用方法

```dart
import 'package:dart_iztro/dart_iztro.dart';

// 创建实例
final iztro = DartIztro();

// 获取八字信息
final birthData = await iztro.calculateBaZi(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 是否农历
  gender: Gender.male,
);

// 获取紫微斗数星盘
final chart = await iztro.calculateChart(
  year: 1990, 
  month: 1, 
  day: 1, 
  hour: 12, 
  minute: 0,
  isLunar: false, // 是否农历
  gender: Gender.male,
);

// 打印宫位信息
print(chart.palaces);
```

## 更多示例

更多使用示例请查看 example 文件夹中的示例应用。

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

