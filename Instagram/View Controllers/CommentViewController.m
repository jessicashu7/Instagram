//
//  CommentViewController.m
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "CommentViewController.h"
#import "SVProgressHUD.h"


@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapComment:(id)sender {
    
    [SVProgressHUD show];
    [Comment updatePostWithComment:self.commentTextField.text withPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (succeeded){
            NSLog(@"comment success");
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"Error commenting: %@", error.localizedDescription);
            [self noNetworkAlert];
        }
    }];
    
    /*
    [self.post didComment:self.commentTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (succeeded){
            NSLog(@"Comment Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"Error commenting: %@", error.localizedDescription);
            [self noNetworkAlert];
        }
    }];
*/
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
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
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
