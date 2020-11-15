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
    ClassDB::bind_method(D_METHOD("register_push_notifications"), &PluginExample::register_push_notifications);
    
    ADD_SIGNAL(MethodInfo("device_address_changed", PropertyInfo(Variant::STRING, "id")));
}

void PluginExample::register_push_notifications() {
    [[APNSAppDelegate shared] registerPushNotifications];
}

void PluginExample::update_device_token(String token) {
    emit_signal("device_address_changed", token);
}

PluginExample::PluginExample() {
    NSLog(@"initialize object");
    singleton = this;
}

PluginExample::~PluginExample() {
    NSLog(@"deinitialize object");
    singleton = NULL;
}
