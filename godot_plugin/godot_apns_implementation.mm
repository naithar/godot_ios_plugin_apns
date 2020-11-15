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


//__attribute__((constructor))
//void apns_initialize() {
//    [GodotApplicalitionDelegate addService:[APNSAppDeletegate new]];
//}

struct APNSInitializer {
    
    APNSInitializer() {
        NSLog(@"registering new app delegate");
        [GodotApplicalitionDelegate addService:[APNSAppDelegate shared]];
    }
};
static APNSInitializer initializer;

@interface APNSAppDelegate()

@property (nonatomic, strong) APNSUserNotificationDelegate *unDelegate;
@end

@implementation APNSAppDelegate

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _unDelegate = [APNSUserNotificationDelegate new];
    }
    
    return self;
}

+ (instancetype)shared {
    static APNSAppDelegate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APNSAppDelegate alloc] init];
    });
    return sharedInstance;
}

- (void)registerPushNotifications {
    [UIApplication.sharedApplication registerForRemoteNotifications];
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"access: %@, error: %@", @(granted), error);
    }];
    UNUserNotificationCenter.currentNotificationCenter.delegate = self.unDelegate;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = (const char *)[deviceToken bytes];
    NSMutableString *token = [NSMutableString string];

    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    String device_token;
    device_token.parse_utf8([[token copy] UTF8String]);
    
    PluginExample::get_singleton()->update_device_token(device_token);
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
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
    } else {
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
    }
}

@end
