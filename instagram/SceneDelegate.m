//
//  SceneDelegate.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/3/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "SceneDelegate.h"
#import <Parse/Parse.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Check if the user is not nil (meaning that there has already been a sign in and we want to keep this sign in even if the app closes)
    if (PFUser.currentUser) {
        // Set the root controller to the TimelineViewController (instead of the SignInViewController)
        // Want this if user already signed in (not make them log in again)
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineViewController"];
    }
}


@end
