//
//  DetailPostViewController.m
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "DetailPostViewController.h"

@interface DetailPostViewController ()

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPost:(Post *)post{
    _post = post;
    [self refreshData];
    NSLog(@"called refresh");
    
}
- (void) refreshData {
    self.userLabel.text = self.post.author.username;
    NSLog(@"%@", self.post.author.username);
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
    self.captionLabel.text = self.post.caption;
    
    // TODO: Format and set createdAtString
    // Format createdAt date string
    NSDate *date = self.post.createdAt;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configurs the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss X y";
    // Convert String to Date
    //NSDate *date = [formatter dateFromString:createdAtOriginalString];
    // Convert output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    if ([date daysAgo] > 7){
        self.timeLabel.text = [formatter stringFromDate:date];
    }
    else if ([date hoursAgo] > 24) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.ldd",[date daysAgo]];
    }
    else if ([date minutesAgo] > 60 ) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.fh",[date hoursAgo]];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%.fm",[date minutesAgo]];
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
