//
//  TimeSlotCollectionViewCell.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "TimeSlotCollectionViewCell.h"
#import "Timeslot.h"
#import "Room.h"
#import "Speaker.h"
#import "Session.h"

@interface TimeSlotCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@end

@implementation TimeSlotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *containingView = self.dayLabel.superview;
    containingView.layer.borderColor = [UIColor blackColor].CGColor;
    containingView.layer.borderWidth = 2.0;
    containingView.layer.cornerRadius = 5.0;
    
    // Initialization code
}

-(void)configureWithTimeSlot:(Timeslot *)timeslot {
    self.dayLabel.text = timeslot.dayString;
    self.timeRangeLabel.text = timeslot.timeRange;
    self.roomLabel.text = timeslot.room.name;
    self.speakerNameLabel.text = timeslot.speaker.name;
    self.sessionTitleLabel.text = timeslot.session.title;
}
@end
