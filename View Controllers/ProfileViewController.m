//
//  ProfileViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/28/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "PostCell.h"
#import "ProfilePostCollectionViewCell.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) NSArray *arrayOfUserPosts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Set up CollectionView
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    // Fetch the profile image
    if(self.userToDisplay == nil) {
        self.userToDisplay = [PFUser currentUser];
    }
    
    self.userProfileImageView.file = self.userToDisplay[@"profile_image"];
    [self.userProfileImageView loadInBackground];
    
    // Fetch the username
    self.usernameLabel.text = self.userToDisplay.username;
    
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height /2;
    self.userProfileImageView.layer.masksToBounds = YES;
    self.userProfileImageView.layer.borderWidth = 0;
    
    // Fetch the posts
    [self fetchPosts];
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
    
    CGRect bounds = UIScreen.mainScreen.bounds;      // fetches device's screen
    CGFloat width = bounds.size.width;               // extracts width of bounds
    CGSize imageSize = CGSizeMake(width, width);     // creates square image
    
    self.userProfileImageView.image = [self resizeImage:originalImage withSize:imageSize];
    
    NSData *imageData = UIImagePNGRepresentation(self.userProfileImageView.image);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
    
    //PFUser *currentUser = [PFUser currentUser];
    self.userToDisplay[@"profile_image"] = imageFile;
    
    [self.userToDisplay saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"InsPost"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.userToDisplay];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfUserPosts = posts;
            [self.tableView reloadData];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// -------- TABLE VIEW --------

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier: @"PostCell"];
    cell.post = self.arrayOfUserPosts[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUserPosts.count;
}*/

// -------- COLLECTION VIEW --------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfilePostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCollectionViewCell" forIndexPath:indexPath];
    
    InsPost *post = self.arrayOfUserPosts[indexPath.row];
    
    // Set the cell
    cell.userPostImage.file = post.image;
    [cell.userPostImage loadInBackground];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfUserPosts.count;
}

 //#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString: @"didTapCollectionPost"]) {
         NSIndexPath *myIndexPath = [self.collectionView indexPathForCell: (ProfilePostCollectionViewCell*) sender];
         InsPost *dataToPass = self.arrayOfUserPosts[myIndexPath.row];
         DetailsViewController *detailVC = [segue destinationViewController];
         detailVC.detailPost = dataToPass;
     }
 }
 

@end
