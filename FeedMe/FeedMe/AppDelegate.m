//
//  AppDelegate.m
//  FeedMe
//
//  Created by Nicole Zhu on 10/29/14.
//  Copyright (c) 2014 Delta Hackers. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*[Parse setApplicationId:@"AQt6deyZo6unOjL3FdCKP0qaHqXIxS0eyWHCAIhI"
                  clientKey:@"VSx241clNpLEUWnzAh9dOgEwsMuYWTLza7Z3bo1n"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];*/
    
    [Parse setApplicationId:@"WqcccQ2PuWTgbijSnafJlJrtHH6ca8OnGR7lH5Oy"
                  clientKey:@"6itJjF0AgLOUzVOW0YzAz3JPJMQmKiLlWp9IlNHG"];
    [self registerForNotifications:application];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        self.firstLaunch = NO;
    }
    else
    {
        PFUser *currentUser = [PFUser user];
        NSString *UUID = [[NSUUID UUID] UUIDString];
        [currentUser setUsername:UUID];
        [currentUser setPassword:@""];
        [currentUser setObject:@"Food" forKey:@"notificationSelection"];
        [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                [[PFInstallation currentInstallation] saveInBackground];
            }
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        self.firstLaunch = YES;
    }
    return YES;
}

-(void)registerForNotifications:(UIApplication *)application
{
    // Register for Push Notifications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // set up for camera button category
        UIMutableUserNotificationAction *pictureAction = [[UIMutableUserNotificationAction alloc] init];
        pictureAction.identifier = @"PICTURE_ID";
        pictureAction.title = @"Take a picture";
        pictureAction.destructive = NO;
        pictureAction.authenticationRequired = NO;
        pictureAction.activationMode = UIUserNotificationActivationModeBackground;
        UIMutableUserNotificationCategory *pictureCategory = [[UIMutableUserNotificationCategory alloc] init];
        [pictureCategory setActions:@[pictureAction] forContext:UIUserNotificationActionContextDefault];
        [pictureCategory setActions:@[pictureAction] forContext:UIUserNotificationActionContextMinimal];
        pictureCategory.identifier = @"PICTURE_CATEGORY";
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:[NSSet setWithArray:@[pictureCategory]]];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"PICTURE_ID"]) {
        
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [PFPush handlePush:userInfo];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
