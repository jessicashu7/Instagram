//
//  PostCell.h
//  Instagram
//
//  Created by Jessica Shu on 7/9/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong, nonatomic) Post* post;
@end

