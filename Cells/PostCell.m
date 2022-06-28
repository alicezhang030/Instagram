//
//  PostCell.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "PostCell.h"
#import "Parse/PFImageView.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(InsPost *)post {
    _post = post;
    self.captionLabel.text = post[@"caption"];
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
}

@end
