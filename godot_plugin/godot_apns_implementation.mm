//
//  godot_apns_implementation.m
//  godot_plugin
//
//  Created by Sergey Minakov on 15.11.2020.
//  Copyright © 2020 Godot. All rights reserved.
//

#import "godot_apns_implementation.h"

#import "godot_plugin_implementation.h"
#import "platform/iphone/godot_app_delegate.h"

struct APNSInitializer {
    
    APNSInitializer() {
        NSLog(@"registering new app delegate extension");
        [GodotApplicalitionDelegate addService:[APNSAppDelegate shared]];
        NSLog(@"registering user notification delegate extension");
        [GodotUserNotificationDelegate addService:[APNSUserNotificationDelegate new]];
    }
};
static APNSInitializer initializer;

@interface APNSAppDelegate()

@property (nonatomic, strong) APNSUserNotificationDelegate *unDelegate;
@end

@implementation APNSAppDelegate

+ (instancetype)shared {
    static APNSAppDelegate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APNSAppDelegate alloc] init];
    });
    return sharedInstance;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"registered device token");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"new data: %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

@end

@implementation APNSUserNotificationDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"trying to present notification");
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
    } else {
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
    }
}

@end
