//
//  PostCell.m
//  Instagram
//
//  Created by Jessica Shu on 7/9/18.
//  Copyright © 2018 jessicashu7. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPost:(Post *)post{
    _post = post;
    [self refreshData];
    
}

- (void) refreshData {
    self.userLabel.text = self.post.author.username;
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


@end

