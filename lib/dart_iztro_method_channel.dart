import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart_iztro_platform_interface.dart';

/// An implementation of [DartIztroPlatform] that uses method channels.
class MethodChannelDartIztro extends DartIztroPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dart_iztro');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
