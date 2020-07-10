//
//  PostCell.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/4/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import <Parse/Parse.h>
#import "PostCell.h"

@implementation PostCell

- (void)loadPost {
    // Load in information about post
    PFUser *user = self.post[@"author"];
    NSDate *date = self.post[@"timeStamp"];
    // Create a date formatter to properly reformat the provided timeStamp into readable date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    // Set labels for post
    self.name.text = user.username;
    self.bodyText.text = self.post[@"caption"];
    self.date.text = dateString;
    // Load in profile picture
    PFFileObject *proPic = [user valueForKey:@"proPic"];
    // Parse method that will asynchronously collect the data from cache if available or fetches its contents from the network if necessary (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFFileObject.html#/c:objc(cs)PFFileObject(im)getDataInBackgroundWithBlock:)
    [proPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Profile image loaded successfully!");
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *postImageView = [[UIImageView alloc] initWithImage:image];
            self.profileImage.image = postImageView.image;
        }
    }];
    // Load in post picture
    PFFileObject *postPic = self.post[@"image"];
    // Use same parse method to asynchronously fetch image data
    [postPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Post image loaded successfully!");
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *postImageView = [[UIImageView alloc] initWithImage:image];
            self.postImage.image = postImageView.image;
        }
    }];
    // Load in correctly colored like button
    if([self.post[@"liked"] isEqual:@YES]) {
        UIImage *image = [UIImage imageNamed:@"favor-icon-red"];
        // These two following methods set the image and title for the button at a certain state (https://developer.apple.com/documentation/uikit/uibutton/1623997-setimage?language=objc)
        // We chose UIControlStateNormal since this occurs when the button is enabled but neither selected nor highlighted
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", self.post.likeCount] forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", self.post.likeCount] forState:UIControlStateNormal];
    };
}

- (IBAction)like:(id)sender {
    if([self.post[@"liked"] isEqual:@YES]){
        self.post[@"liked"] = @NO;
        // Convert from object NSNumber to int using built in intValue function
        int numLiked = [self.post.likeCount intValue];
        // Convert back the other way using function (from int to NSNumber object to be stored in Post object)
        self.post.likeCount = [NSNumber numberWithInteger:(numLiked - 1)];
        // This function saves the new Post asynchronously within Parse for later use/modification (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFFileObject.html#/c:objc(cs)PFFileObject(im)saveInBackgroundWithBlock:)
        [self.post saveInBackgroundWithBlock:nil];
        UIImage *image = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", self.post.likeCount] forState:UIControlStateNormal];
    }
    else{
        self.post[@"liked"] = @YES;
        int numLiked = [self.post.likeCount intValue];
        self.post.likeCount = [NSNumber numberWithInteger:(numLiked + 1)];
        [self.post saveInBackgroundWithBlock:nil];
        UIImage *image = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", self.post.likeCount] forState:UIControlStateNormal];
    };
}

@end
