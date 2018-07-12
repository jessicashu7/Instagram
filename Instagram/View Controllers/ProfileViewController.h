//
//  ProfileViewController.h
//  Instagram
//
//  Created by Jessica Shu on 7/12/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import <Parse/Parse.h>
@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* posts;
@end
