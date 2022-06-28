//
//  ProfileViewController.h
//  Instagram
//
//  Created by Alice Zhang on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "PFUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
