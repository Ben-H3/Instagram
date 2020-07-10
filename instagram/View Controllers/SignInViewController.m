//
//  SignInViewController.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/4/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signIn;
@property (weak, nonatomic) IBOutlet UIButton *signUp;

@end

@implementation SignInViewController

- (IBAction)loginUser:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    // Parse method makes asynchronous request to log in user. Automatically sets currentUser getter/setter methods to store new user if login credentials are correct.
    // (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFUser.html#/c:objc(cs)PFUser(cm)logInWithUsernameInBackground:password:block:)
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // Display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"timelineSegue" sender:nil];
        }
    }];
}
- (IBAction)registerUser:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // Set user properties
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    // Sign up a new user asynchronously to access the app. Will automatically enforce that the username is not already taken.
    // (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFUser.html#/c:objc(cs)PFUser(im)signUpInBackgroundWithBlock:)
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            // Manually segue to logged in view
            [self performSegueWithIdentifier:@"timelineSegue" sender:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
