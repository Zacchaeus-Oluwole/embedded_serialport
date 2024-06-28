//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <embedded_serialport/embedded_serialport_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) embedded_serialport_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "EmbeddedSerialportPlugin");
  embedded_serialport_plugin_register_with_registrar(embedded_serialport_registrar);
}
