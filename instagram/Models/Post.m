//
//  Post.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/4/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "Post.h"

@implementation Post

// @dynamic refers to the fact that the getter/setter methods for the property will be setup at runtime (https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html)
// Tell compiler get/set implemented not by this class itself but elsewhere in code (done by Parse in PFSubclassing)
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic timeStamp;

// Create class methods here (methods that relate to the post class in general but do not operate on any specific object in the class)

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

// Set necessary variables to make a new post and store it within Parse
+ (void) createNewPost: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // Create a new instance of a Post
    Post *newPost = [Post new];
    // Call this method to extract a PFFileObject from a standard UI image (so it can be stored in Parse)
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    // Store object NSNumber
    // Choose object instead of primative type as allows for more functionality (i.e. will call convert to string method later in code)
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.timeStamp = [NSDate date];
    // This function saves the new Post asynchronously within Parse for later use/modification
    // (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFFileObject.html#/c:objc(cs)PFFileObject(im)saveInBackgroundWithBlock:)
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
