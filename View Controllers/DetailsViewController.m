//
//  DetailsViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/28/22.
//

#import "DetailsViewController.h"
#import "Parse/PFImageView.h"
#import "DateTools.h"
#import "Likes.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionLabel.text = self.detailPost[@"caption"];
    
    self.postImageView.file = self.detailPost[@"image"];
    [self.postImageView loadInBackground];
    
    self.profileImage.file = self.detailPost.author[@"profile_image"];
    [self.profileImage loadInBackground];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.usernameLabel.text = self.detailPost.author.username;
    
    self.likeLabel.text = [NSString stringWithFormat:@"%d", [self.detailPost[@"likeCount"] intValue]];
    
    // Set the date
    NSDate *originalDate = self.detailPost.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    NSString *formattedDateStr = [formatter stringFromDate:originalDate];
    NSDate *date = [formatter dateFromString:formattedDateStr];
    
    NSString *dateSince = date.shortTimeAgoSinceNow;
    if ([dateSince containsString:@"d"] || [dateSince containsString:@"w"] || [dateSince containsString:@"M"] || [dateSince containsString:@"y"]) { //has been more than a day
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.dateLabel.text = [formatter stringFromDate:date];
    } else { //it has not been a day since the tweet
        self.dateLabel.text = dateSince;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (likes != nil) {
            bool likedPostBefore = NO;
            
            for (Likes *likeObj in likes) {
                //User has liked the post in question, so delete the Like entry
                if([likeObj.post.objectId isEqualToString:self.detailPost.objectId]) {
                    likedPostBefore = YES;
                }
            }
            
            if(likedPostBefore) {
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
            } else {
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLikeButton:(id)sender {
    NSLog(@"Did tap details view like");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (likes != nil) {
            bool likedPostBefore = NO;
            
            for (Likes *likeObj in likes) {
                if([likeObj.post.objectId isEqualToString:self.detailPost.objectId]) { //User has liked the post before -> delete the Like entry
                    likedPostBefore = YES;
                    
                    // Update likeCount
                    int likeCountInt = [self.detailPost[@"likeCount"] intValue];
                    likeCountInt -= 1;
                    self.detailPost[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
                    
                    [self.detailPost saveInBackground];
                    
                    // Update cell UI
                    [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                    self.likeLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
                    
                    [Likes deleteLike:likeObj];
                }
            }
            
            //User has liked posts but has not liked the post in question, so add a Like entry
            if(!likedPostBefore) {
                [Likes postLike:self.detailPost fromUser: [PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        NSLog(@"The Like was uploaded!");
                        
                        // Update likeCount
                        int likeCountInt = [self.detailPost[@"likeCount"] intValue];
                        likeCountInt += 1;
                        self.detailPost[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
                        
                        [self.detailPost saveInBackground];
                        
                        // Update cell UI
                        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
                        self.likeLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
                    } else {
                        NSLog(@"Problem uploading the Like: %@", error.localizedDescription);
                    }
                }];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
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
