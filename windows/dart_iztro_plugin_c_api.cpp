#include "include/dart_iztro/dart_iztro_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "dart_iztro_plugin.h"

void DartIztroPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  dart_iztro::DartIztroPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
