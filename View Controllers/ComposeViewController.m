//
//  ComposeViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "ComposeViewController.h"
#import "InsPost.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextView *captionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner; //spinner while waiting for API

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spinner.hidesWhenStopped = YES; //when the data retrival is finished, the spinner will disappear
    
    self.captionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.captionView.layer.borderWidth = 0.5;
}

- (IBAction)tapSelectFromLibrary:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)tapUseCamera:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    [self.imagePreview setImage:originalImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelCompose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)postCompose:(id)sender {
    [self.spinner startAnimating];
    
    CGRect bounds = UIScreen.mainScreen.bounds;      // fetches device's screen
    CGFloat width = bounds.size.width;               // extracts width of bounds
    CGSize imageSize = CGSizeMake(width, width);     // creates square image
    
    UIImage *newImage = [self resizeImage:self.imagePreview.image withSize:imageSize];
    
    [InsPost postUserImage:newImage withCaption:self.captionView.text withCompletion:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was posted!");
                [self dismissViewControllerAnimated:true completion:nil];
                [self.spinner stopAnimating];
            } else {
                NSLog(@"Problem posting: %@", error.localizedDescription);
            }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
