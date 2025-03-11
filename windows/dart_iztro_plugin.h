#ifndef FLUTTER_PLUGIN_DART_IZTRO_PLUGIN_H_
#define FLUTTER_PLUGIN_DART_IZTRO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace dart_iztro {

class DartIztroPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DartIztroPlugin();

  virtual ~DartIztroPlugin();

  // Disallow copy and assign.
  DartIztroPlugin(const DartIztroPlugin&) = delete;
  DartIztroPlugin& operator=(const DartIztroPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace dart_iztro

#endif  // FLUTTER_PLUGIN_DART_IZTRO_PLUGIN_H_
