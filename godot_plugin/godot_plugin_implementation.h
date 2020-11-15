//
//  godot_plugin_implementation.h
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#ifndef godot_plugin_implementation_h
#define godot_plugin_implementation_h

#include "core/object.h"

class PluginExample : public Object {
    GDCLASS(PluginExample, Object);
    
    static void _bind_methods();
    
public:
    static PluginExample *get_singleton();
    
    void register_push_notifications();
    void update_device_token(String token);
    
    PluginExample();
    ~PluginExample();
};

#endif /* godot_plugin_implementation_h */
