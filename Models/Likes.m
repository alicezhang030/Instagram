//
//  Likes.m
//  Instagram
//
//  Created by Alice Zhang on 6/30/22.
//

#import "Likes.h"

@implementation Likes

@dynamic post;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Likes";
}

+ (void) postLike: (InsPost * _Nullable) post fromUser: (PFUser * _Nullable) user withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Likes *newLike = [Likes new];
    
    newLike.post = post;
    newLike.user = user;
    
    [newLike saveInBackgroundWithBlock: completion];
}

+ (void) deleteLike: (Likes * _Nullable) like {
    [like deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully deleted the like");
        } else {
            NSLog(@"Failed to delete the like: %@", error.localizedDescription);
        }
    }];
}

@end
