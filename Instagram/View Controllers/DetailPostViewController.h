//
//  DetailPostViewController.h
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"
#import "DateTools.h"

@interface DetailPostViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;


@property (strong, nonatomic) Post* post;

@end
