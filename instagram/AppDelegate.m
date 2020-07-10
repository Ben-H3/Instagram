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

// Function called when launch process is almost done and the app is almost ready to run (https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application?language=objc)
// Put in tasks that are final initialization steps before window loads
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // initialize the parse client with proper key's as created through Heroku (Parse Server)
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"instagramAppId";
        configuration.clientKey = @"instagramMasterKey";
        configuration.server = @"https://instagram-parse-server-project.herokuapp.com/parse";
    }];
    [Parse initializeWithConfiguration:configuration];
    
    // Check if the user is not nil (meaning that there has already been a sign in and we want to keep this sign in even if the app closes)
    if (PFUser.currentUser) {
        // Set the root controller to the TimelineViewController (instead of the SignInViewController)
        // Want this if user already signed in (not make them log in again)
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineViewController"];
    }
    
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
