//
//  SessionTableViewCell.m
//  PDC2016
//
//  Created by James Perih on 2016-04-10.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "Session.h"
#import "Timeslot.h"
#import "Room.h"
#import "Speaker.h"

@interface SessionTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeslotLabel;
@end

@implementation SessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureWithSession:(Session *)session {
    if (session) {
        self.titleLabel.text = session.title;
        self.timeslotLabel.text = session.timeslot.timeRange;
    }
    
}
@end
