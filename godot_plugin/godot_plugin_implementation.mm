//
//  godot_plugin_implementation.m
//  godot_plugin
//
//  Created by Sergey Minakov on 14.08.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "core/project_settings.h"
#include "core/class_db.h"

#import "godot_plugin_implementation.h"
#import "godot_apns_implementation.h"

static PluginExample *singleton;

PluginExample *PluginExample::get_singleton() {
    return singleton;
}

void PluginExample::_bind_methods() {
    
}

PluginExample::PluginExample() {
    NSLog(@"initialize object");
    singleton = this;
}

PluginExample::~PluginExample() {
    NSLog(@"deinitialize object");
    singleton = NULL;
}
