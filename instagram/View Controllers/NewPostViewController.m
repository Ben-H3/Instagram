//
//  NewPostViewController.m
//  instagram
//
//  Created by Benjamin Charles Hora on 7/7/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "NewPostViewController.h"
#import "Post.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NewPostViewController

- (IBAction)useCamera:(id)sender {
    // Utilize UIImagePickerController to determine whether or not camera available (https://developer.apple.com/documentation/uikit/uiimagepickercontroller)
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // isSourceTypeAvailable returns a boolean checking whether the specific device being used supports use of camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"Camera is available to use!");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead.");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)openGallery:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // Immediately set the VC type to be displaying the photo library
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// This function allows for quick edits to and/or examination of an asset right after the user selects it (https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate/1619126-imagepickercontroller)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 375)];
    self.photo.image = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This function allows for an image to be resized, standardizing all posts
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    // Create new view pased on provided parameters
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    // Fill the view fully, clipping small portions of the image if necessary
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    // Create a new graphics context of given size and set it as the current graphics context (https://developer.apple.com/documentation/uikit/1623922-uigraphicsbeginimagecontext?language=objc)
    UIGraphicsBeginImageContext(size);
    // Render resized image in this new graphics context (https://developer.apple.com/documentation/quartzcore/calayer/1410909-renderincontext)
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // Store the image now rendered based on current graphics context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End current graphics context
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)post:(id)sender {
    // Call the block implemented within the Post Model with the necessary parameters and verify post succeeded
    [Post createNewPost:self.photo.image withCaption:self.bodyText.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Successful creating a new post!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
           NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
