//
//  PostCell.h
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end

NS_ASSUME_NONNULL_END
