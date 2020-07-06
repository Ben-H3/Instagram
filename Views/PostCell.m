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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadPost {
    // Load in information about post
    PFUser *user = self.post[@"author"];
    NSDate *date = self.post[@"timeStamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    // Set labels for post
    self.name.text = user.username;
    self.bodyText.text = self.post[@"caption"];
    self.date.text = dateString;
    // Load in profile picture
    PFFileObject *proPic = [user valueForKey:@"proPic"];
    [proPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:image];
        self.profileImage.image = postImageView.image;
    }];
    // Load in post picture
    PFFileObject *postPic = self.post[@"image"];
    [postPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:image];
        self.postImage.image = postImageView.image;
    }];
    // Load in correctly colored like button
    if([self.post[@"liked"] isEqual:@YES]) {
        UIImage *image = [UIImage imageNamed:@"favor-icon-red"];
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
        int numLiked = [self.post.likeCount intValue];
        self.post.likeCount = [NSNumber numberWithInteger:(numLiked - 1)];
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

- (IBAction)comment:(id)sender {
}

@end
