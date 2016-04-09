//
//  SessionCollectionViewCell.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionCollectionViewCell.h"
#import "Session.h"
#import "Speaker.h"
#import "Timeslot.h"
#import "Room.h"

@interface SessionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionKeywordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerCompany;
@property (weak, nonatomic) IBOutlet UILabel *sessionTimeslotDayAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionRoomNameLabel;
@end

@implementation SessionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *containingView = self.sessionTitleLabel.superview;
    containingView.layer.borderColor = [UIColor blackColor].CGColor;
    containingView.layer.borderWidth = 2.0;
    containingView.layer.cornerRadius = 5.0;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *containingView = self.sessionTitleLabel.superview;
        containingView.layer.borderColor = [UIColor blackColor].CGColor;
        containingView.layer.borderWidth = 2.0;
        containingView.layer.cornerRadius = 5.0;
    }
    return self;
}

-(void)configureWithSession:(Session *)session {
    _sessionTitleLabel.text = session.title;
    _sessionKeywordsLabel.text = session.keywordString; // don't need the individual keywords... yet...
    _sessionDescriptionLabel.text = session.sessionDescription;
    _sessionSpeakerNameLabel.text = session.speaker.name;
    
    _sessionSpeakerCompany.text = session.speaker.companyName.length > 2 ? [NSString stringWithFormat:@"(%@)", session.speaker.companyName] : @"";
    
    _sessionTimeslotDayAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@"
                                            , session.timeslot.day
                                            , session.timeslot.timeRange];
    _sessionRoomNameLabel.text = session.room.name;
}

@end
