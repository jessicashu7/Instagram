//
//  DetailPostViewController.m
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "DetailPostViewController.h"
#import "CommentCell.h"
#import "SVProgressHUD.h"
#import "PostCell.h"
#import "CommentViewController.h"

@interface DetailPostViewController ()

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchComments];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchComments) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) fetchComments {
 /*   [self.post fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable post, NSError * _Nullable error) {
        if (!error){
            NSLog(@"fetched comments successfully");
        
            self.comments = post[@"comments"];

            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            
        }
    }];
  
 
    PFQuery *query
    = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    //[query includeKey:@"comments"];
    //[query includeKey:@"Comment"];
    [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject* post, NSError *error){
        if (!error){
            
            NSLog(@"fetched comments successfully");
            NSLog(@"%@", post);
            self.comments = post[@"comments"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        }
        else {
            NSLog(@"error fetching comments: %@", error.localizedDescription);
            [self noNetworkAlert];

        }
    }];
  */
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"post" equalTo:self.post];
    [query includeKey:@"author"];
    //[query includeKey:@"post"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *cmts, NSError * _Nullable error) {
        if (cmts != nil){
            NSLog(@"fetched comments successfully");
            self.comments = cmts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        }
        else {
            NSLog(@"error fetching posts: %@", error.localizedDescription);
            [self noNetworkAlert];
        }
    }];
    
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
    
    // Convert Date to String
    if ([date daysAgo] > 7){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configurs the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss X y";
        // Convert String to Date
        //NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Convert output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.timeLabel.text = [formatter stringFromDate:date];
    }
    else if ([date hoursAgo] > 24) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.ldd",[date daysAgo]];
    }
    else if ([date minutesAgo] > 60 ) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.fh",[date hoursAgo]];
    }
    else if ([date secondsAgo] > 60 ){
        self.timeLabel.text = [NSString stringWithFormat:@"%.fm",[date minutesAgo]];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%.fs",[date secondsAgo]];
    }
    [self fetchComments];

    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.comment = self.comments[indexPath.row];
    return cell;
    
}

- (void) didComment {
    [self fetchComments];
}

- (void)noNetworkAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Check you connection" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        // handle response here
        [self.refreshControl endRefreshing];

    }];
    
    //create the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"CommentSegue2"]){
        UINavigationController *navigationController =  [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        commentViewController.post = self.post;
        commentViewController.delegate = self;
        
    }
}


@end
