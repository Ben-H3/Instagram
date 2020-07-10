//
//  AppDelegate.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/3/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

// Function called when launch process is almost done and the app is almost ready to run
// (https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application?language=objc)
// Put in tasks that are final initialization steps before window loads
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize the parse client with proper key's as created through Heroku (Parse Server)
    // This block creates a new SDK configuration object, set parameters, and then be initialized
    // (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/ParseClientConfiguration.html#/c:objc(cs)ParseClientConfiguration(cm)configurationWithBlock:)
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"instagramAppId";
        configuration.clientKey = @"instagramMasterKey";
        configuration.server = @"https://instagram-parse-server-project.herokuapp.com/parse";
    }];
    [Parse initializeWithConfiguration:configuration];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
