//
//  TimelineViewController.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/4/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "TimelineViewController.h"
#import "SignInViewController.h"
#import "DetailsViewController.h"
#import "NewPostViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "SceneDelegate.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchPosts];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // Use this instance method to associate action of making network call to update posts with a control event changing (i.e. reshresh control fully pulled) (https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget?language=objc)
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self.tableView reloadData];
}

- (void)fetchPosts {
    // Create query to view 20 posts stored in Parse by using PFQuery class instance method (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFQuery.html#/c:objc(cs)PFQuery(cm)queryWithClassName:)
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    // Make sure to account for all necessary keys needed for displaying posts on screen
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"caption"];
    [query includeKey:@"image"];
    // Use this Parse method to find posts in database asynchronously and store them into posts array (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFQuery.html#/c:objc(cs)PFQuery(im)findObjectsInBackgroundWithBlock:)
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Sucess fetching posts!");
            // Put all the received posts into array
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// This action will makes a network request to get updated data, update the tableView with the new data, and then hide the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // Create the network session with default configuration (caching policies, timeouts, proxies), delegate (not necessary as no additional authentication), and queue (simply use operation queue associated with the main thread).  (https://developer.apple.com/documentation/foundation/nsurlsession/1411597-sessionwithconfiguration?language=objc)
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    // Ensure that a new networking call is made to get most up-to-date data
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [self fetchPosts];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (IBAction)logout:(id)sender {
    // Access the scene delegate and storyboard
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *signInViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    // Set the new root view controller to be the sign in view controller (since user now signed out of timeline)
    sceneDelegate.window.rootViewController = signInViewController;
    // Parse method that asynchronously logs out the currently logged in user (setting currentUser to nil in the process) (https://parseplatform.org/Parse-SDK-iOS-OSX/api/Classes/PFUser.html#/c:objc(cs)PFUser(cm)logOutInBackgroundWithBlock:)
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Successful log out!");
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Access the cell and set the corresponding post to be associated with the proper cell (based on indexPath)
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [cell loadPost];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailsViewController class] ]){
        // Get clicked cell and corresponding post to send to DetailsViewController
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    else{
        // New Post was clicked so load in new VC for this task
        UINavigationController *navController = [segue destinationViewController];
        NewPostViewController *newPostViewController = (NewPostViewController*)navController.topViewController;
    }
}

@end
