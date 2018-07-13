//
//  FeedViewController.h
//  Instagram
//
//  Created by Jessica Shu on 7/9/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePostViewController.h"

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CreatePostControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* posts;

@end
