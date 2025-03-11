import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dart_iztro_method_channel.dart';

abstract class DartIztroPlatform extends PlatformInterface {
  /// Constructs a DartIztroPlatform.
  DartIztroPlatform() : super(token: _token);

  static final Object _token = Object();

  static DartIztroPlatform _instance = MethodChannelDartIztro();

  /// The default instance of [DartIztroPlatform] to use.
  ///
  /// Defaults to [MethodChannelDartIztro].
  static DartIztroPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DartIztroPlatform] when
  /// they register themselves.
  static set instance(DartIztroPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
