//
//  TimeSlotCollectionViewCell.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "TimeSlotCollectionViewCell.h"
#import "Timeslot.h"

@interface TimeSlotCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLabel;
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
    self.dayLabel.text = timeslot.day;
    self.timeRangeLabel.text = timeslot.timeRange;
}
@end
