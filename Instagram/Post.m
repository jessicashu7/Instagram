//
//  Post.m
//  Instagram
//
//  Created by Jessica Shu on 7/9/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>

@implementation Post

@dynamic postID, userID, author, caption, image, likeCount, commentCount, comments;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.comments = [[NSArray alloc] init];
    
    [newPost saveInBackgroundWithBlock:completion];
}

+ (PFFile *)getPFFileFromImage: (UIImage *_Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not null
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void)didComment:(NSString*)comment withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.comment = comment;
    
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
        if (succeeded){
            NSLog(@"new comment saved");
            [self updatePostWithComment:newComment withCompletion:completion];
        }
        else {
            NSLog(@"new comment not saved");
            completion(NO, error);
        }
    }];
    
}

- (void)updatePostWithComment:(Comment*)comment withCompletion:(PFBooleanResultBlock _Nullable)completion {
    //NSLog(@"update post called");
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *post, NSError* error){
        if (!error){
            [post addUniqueObject:comment forKey:@"comments"];
            [post incrementKey:@"commentCount"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"post updated with comment");
                    completion(YES,nil);
                }
                else {
                    NSLog(@"post not updated");
                    completion(NO, error);
                }
            }];
            
        }
        else {
            NSLog(@"post not retrieved");
            completion(NO, error);
        }
    }];
}



@end
