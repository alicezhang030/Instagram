//
//  PostCell.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "PostCell.h"
#import "Parse/PFImageView.h"
#import "DateTools.h"
#import "Likes.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //remove the gray highlight after you select a cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userProfileImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.userProfileImage setUserInteractionEnabled:YES];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post.author];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPost:(InsPost *)post {
    _post = post;
    self.captionLabel.text = post.caption;
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    self.usernameLabel.text = post.author.username;
    
    self.userProfileImage.file = post.author[@"profile_image"];
    [self.userProfileImage loadInBackground];
    
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height /2;
    self.userProfileImage.layer.masksToBounds = YES;
    self.userProfileImage.layer.borderWidth = 0;
    
    // Set the like label
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", [post[@"likeCount"] intValue]];
    
    // Set the date
    NSDate *originalDate = post.createdAt;
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
                if([likeObj.post.objectId isEqualToString:self.post.objectId]) {
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


- (IBAction)didTapLike:(id)sender {
    NSLog(@"Did tap (un)like button");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (likes != nil) {
            bool likedPostBefore = NO;
            
            for (Likes *likeObj in likes) {
                if([likeObj.post.objectId isEqualToString:self.post.objectId]) { //User has liked the post before -> delete the Like entry
                    likedPostBefore = YES;
                    
                    // Update likeCount
                    int likeCountInt = [self.post[@"likeCount"] intValue];
                    likeCountInt -= 1;
                    self.post[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
                    
                    [self.post saveInBackground];
                    
                    // Update cell UI
                    [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
                    
                    [Likes deleteLike:likeObj];
                }
            }
            
            //User has liked posts but has not liked the post in question, so add a Like entry
            if(!likedPostBefore) {
                [Likes postLike:self.post fromUser: [PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        NSLog(@"The Like was uploaded!");
                        
                        // Update likeCount
                        int likeCountInt = [self.post[@"likeCount"] intValue];
                        likeCountInt += 1;
                        self.post[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
                        
                        [self.post saveInBackground];
                        
                        // Update cell UI
                        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
                        self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
                    } else {
                        NSLog(@"Problem uploading the Like: %@", error.localizedDescription);
                    }
                }];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (likes != nil) {
            bool likedPostBefore = NO;
            
            for (Likes *likeObj in likes) {
                //User has liked the post in question, so delete the Like entry
                if([likeObj.post.objectId isEqualToString:self.post.objectId]) {
                    likedPostBefore = YES;
                    [Likes deleteLike:likeObj];
                }
            }
            
            //User has liked posts but has not liked the post in question, so add a Like entry
            if(!likedPostBefore) {
                [Likes postLike:self.post fromUser: [PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        NSLog(@"The Like was uploaded!");
                    } else {
                        NSLog(@"Problem uploading the Like: %@", error.localizedDescription);
                    }
                }];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];*/
    
    /*
    if(self.post.liked != YES) {
        // Update liked boolean
        self.post.liked = YES;
        
        // Update likeCount
        int likeCountInt = [self.post[@"likeCount"] intValue];
        likeCountInt += 1;
        self.post[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
        
        // Update database
        [self.post saveInBackground];
        
        // Update cell UI
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
    } else { //unfavorite
        self.post.liked = NO;
        
        // Update likeCount
        int likeCountInt = [self.post[@"likeCount"] intValue];
        likeCountInt -= 1;
        self.post[@"likeCount"] = [NSNumber numberWithInt:likeCountInt];
        
        [self.post saveInBackground];
        
        // -Update cell UI
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
    }*/
}

@end
