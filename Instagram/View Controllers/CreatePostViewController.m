//
//  CreatePostViewController.m
//  Instagram
//
//  Created by Jessica Shu on 7/10/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "CreatePostViewController.h"
#import "Post.h"

@interface CreatePostViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButton:(id)sender {
    [Post postUserImage:self.image withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Post Success!");
            [self.delegate didPost];
            [self dismissViewControllerAnimated:true completion:nil];

        }
        else {
            NSLog(@"Error posting image: %@", error.localizedDescription);
            [self noNetworkAlert];
            
        }
        
    }];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)setImage:(UIImage *)image {
    _image = image;
    [self refreshData];
}

- (void) refreshData {
    self.postImageView.image = self.image;
}

- (void)noNetworkAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Check you connection" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        // handle response here
        [self dismissViewControllerAnimated:true completion:nil];

    }];
    
    //create the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
        
    }];
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
