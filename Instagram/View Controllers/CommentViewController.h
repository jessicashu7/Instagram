//
//  CommentViewController.h
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"
#import "Comment.h"
@interface CommentViewController : UIViewController

//@property (weak, nonatomic) id<CommentControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField* commentTextField;

@property (strong, nonatomic) Post* post;

@end
