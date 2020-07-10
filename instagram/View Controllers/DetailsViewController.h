//
//  DetailsViewController.h
//  instagram
//
//  Created by Benjamin Charles Hora on 7/8/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post* post;

@end

NS_ASSUME_NONNULL_END
