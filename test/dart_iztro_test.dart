import 'package:flutter_test/flutter_test.dart';
import 'package:dart_iztro/dart_iztro.dart';
import 'package:dart_iztro/dart_iztro_platform_interface.dart';
import 'package:dart_iztro/dart_iztro_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDartIztroPlatform
    with MockPlatformInterfaceMixin
    implements DartIztroPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DartIztroPlatform initialPlatform = DartIztroPlatform.instance;

  test('$MethodChannelDartIztro is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDartIztro>());
  });

  test('getPlatformVersion', () async {
    DartIztro dartIztroPlugin = DartIztro();
    MockDartIztroPlatform fakePlatform = MockDartIztroPlatform();
    DartIztroPlatform.instance = fakePlatform;

    expect(await dartIztroPlugin.getPlatformVersion(), '42');
  });
}
