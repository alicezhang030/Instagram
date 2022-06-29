//
//  ProfilePostCollectionViewCell.h
//  Instagram
//
//  Created by Alice Zhang on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userPostImage;

@end

NS_ASSUME_NONNULL_END
