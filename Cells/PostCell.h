//
//  PostCell.h
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"
#import "PFUser.h"
#import "InsPost.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImage;

@property (strong, nonatomic) InsPost *post;

@property (nonatomic, weak) id<PostCellDelegate> delegate;


@end

@protocol PostCellDelegate
- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user;
@end

NS_ASSUME_NONNULL_END
