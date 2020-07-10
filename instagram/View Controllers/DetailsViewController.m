//
//  DetailsViewController.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/8/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *bodyText;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bodyText.text = self.post.caption;
    NSDate *date = self.post.timeStamp;
    // Create a date formatter to properly reformat the provided timeStamp into readable date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.date.text = dateString;
    // Parse method that will asynchronously collect the data from cache if available or fetches its contents from the network if necessary (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFFileObject.html#/c:objc(cs)PFFileObject(im)getDataInBackgroundWithBlock:)
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Profile image loaded successfully!");
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *postImageView = [[UIImageView alloc] initWithImage:image];
            self.image.image = postImageView.image;
        }
    }];
    // Convert from object NSNumber to NSString using built in intValue function
    NSString *numLiked = [self.post.likeCount stringValue];
    if ([self.post.likeCount isEqual: @1]) {
        self.likeLabel.text = [numLiked stringByAppendingString:@" Like"];
    }
    else {
        self.likeLabel.text = [numLiked stringByAppendingString:@" Likes"];
    }
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
