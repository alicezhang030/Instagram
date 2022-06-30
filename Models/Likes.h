//
//  Likes.h
//  Instagram
//
//  Created by Alice Zhang on 6/30/22.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "InsPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface Likes : PFObject<PFSubclassing>

@property (nonatomic, strong) InsPost *post;
@property (nonatomic, strong) PFUser *user;

+ (void) postLike: (InsPost * _Nullable) post fromUser: (PFUser * _Nullable) user withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) deleteLike: (Likes * _Nullable) like;

@end

NS_ASSUME_NONNULL_END
