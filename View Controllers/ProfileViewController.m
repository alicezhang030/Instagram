//
//  ProfileViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/28/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Fetch the profile image
    PFUser *currentUser = [PFUser currentUser];
    self.userProfileImageView.file = currentUser[@"profile_image"];
    [self.userProfileImageView loadInBackground];
    
    // Do any additional setup after loading the view.
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

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // Check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // Get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data: imageData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    [self.userProfileImageView setImage:originalImage];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profile_image"] = self.userProfileImageView.file;
    
    [currentUser saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateProfile {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profile_image"] = self.userProfileImageView.file;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");
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
