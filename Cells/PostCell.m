//
//  PostCell.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "PostCell.h"
#import "Parse/PFImageView.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //remove the gray highlight after you select a cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    if(post.liked == YES) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTapLike:(id)sender {
    NSLog(@"Did tap like");
    
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
        
        // Update cell UI
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
    }
}

@end
