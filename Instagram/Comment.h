//
//  Comment.h
//  Instagram
//
//  Created by Jessica Shu on 7/11/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;

@end
