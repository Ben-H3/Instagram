//
//  NewPostViewController.h
//  instagram
//
//  Created by Benjamin Charles Hora on 7/7/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@end

NS_ASSUME_NONNULL_END
