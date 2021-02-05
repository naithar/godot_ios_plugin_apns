//
//  godot_apns_implementation.h
//  godot_plugin
//
//  Created by Sergey Minakov on 15.11.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "godot_apn/godot_user_notification_delegate.h"

@interface APNSAppDelegate : NSObject <UIApplicationDelegate>

+ (instancetype)shared;

@end

@interface APNSUserNotificationDelegate : UserNotificationService

@end
