//
//  Comment.m
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "Comment.h"
#import "Post.h"
@implementation Comment

@dynamic comment, author;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) updatePostWithComment:(NSString*)comment withPost:(Post*)post withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Comment* newComment = [Comment new];
    newComment.comment = comment;
    newComment.author = [PFUser currentUser];
    newComment.post = post;
    
    [newComment saveInBackgroundWithBlock:completion];
}

@end
