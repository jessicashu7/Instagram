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
#import "AppDelegate.h"
#import "LoginViewController.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error){
            NSLog(@"error logging out: %@", error.localizedDescription);
        }
        else {
            NSLog(@"user logged out successfully");
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController =  [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
            
        }
    }];
}

- (IBAction)post:(id)sender {
    [self createImagePickerController];
    
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

- (void)createImagePickerController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    // Get thew image captured by the UIImagePickerController
    //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    
    // Dismess UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        [self performSegueWithIdentifier:@"CreatePostSegue2" sender:editedImage];
    }];
    
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

- (void)didPost {
    [self fetchPosts];
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
    else if ([segue.identifier isEqual:@"CreatePostSegue2"]){
        UIImage *image = sender;
        UINavigationController *navigationController =  [segue destinationViewController];
        CreatePostViewController *createPostViewController = (CreatePostViewController*)navigationController.topViewController;
        createPostViewController.image = image;
        createPostViewController.delegate = self;
    }
}


@end
