//
//  ProfileViewController.m
//  Instagram
//
//  Created by Jessica Shu on 7/12/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCell.h"
#import "CommentViewController.h"
#import "DetailPostViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface ProfileViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property int queryCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.queryCount = 3;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self fetchMorePosts];
    }];
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    query.limit = self.queryCount;
    
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        if (posts != nil){
            NSLog(@"fetched posts successfully");
            self.posts = posts;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];

            
        }
        else {
            NSLog(@"error fetching posts: %@", error.localizedDescription);
            [self noNetworkAlert];
        }
    }];
}

- (void) fetchMorePosts {
    self.queryCount = self.queryCount + 3;
    [self fetchPosts];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.row];
    cell.post = post;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"CommentSegue3"]){
        PostCell *cell = (PostCell*)[[sender superview] superview];
        UINavigationController *navigationController =  [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        commentViewController.post = cell.post;
        
    }
    else if ([segue.identifier isEqual:@"DetailPostSegue2"]){
        PostCell *cell = sender;
        DetailPostViewController *detailPostViewController = [segue destinationViewController];
        detailPostViewController.post = cell.post;
    }
}


@end
