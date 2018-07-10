//
//  CreatePostViewController.h
//  Instagram
//
//  Created by Jessica Shu on 7/10/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"


@protocol CreatePostControllerDelegate

- (void)didPost;

@end

@interface CreatePostViewController : UIViewController

@property (weak, nonatomic) id<CreatePostControllerDelegate> delegate;

@property (strong, nonatomic) UIImage * image;

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end
