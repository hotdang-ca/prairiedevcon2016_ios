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

#import "PDCFavoritesRepository.h"

#import <UIGestureRecognizer+BlocksKit.h>

CGFloat CORNER_RADIUS = 8.0;
CGFloat BORDER_WIDTH = 2.0;
#define SELECTED_BORDER_COLOR [UIColor yellowColor]
#define UNSELECTED_BORDER_COLOR [UIColor blackColor]

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
    containingView.layer.borderColor = UNSELECTED_BORDER_COLOR.CGColor;
    containingView.layer.borderWidth = BORDER_WIDTH;
    containingView.layer.cornerRadius = CORNER_RADIUS;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *containingView = self.sessionTitleLabel.superview;
        containingView.layer.borderColor = UNSELECTED_BORDER_COLOR.CGColor;
        containingView.layer.borderWidth = BORDER_WIDTH;
        containingView.layer.cornerRadius = CORNER_RADIUS;
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
    // should be selected
    NSArray *favorites = [PDCFavoritesRepository sharedRepository].listOfFavorites;
    
    if ([favorites indexOfObject:session.identifier] != NSNotFound) {
        [self configureAsSelected:YES];
    }
    
    [self configureActionsWithSession:session];
}

-(void)configureActionsWithSession:(Session *)session {
    id tapGestureBlock = ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
        [[PDCFavoritesRepository sharedRepository] toggleFavorited:session.identifier];
        [self configureAsSelected:!self.selected];
    };
    UITapGestureRecognizer *onTapRecognizer = [UITapGestureRecognizer bk_recognizerWithHandler:tapGestureBlock];
    [self.contentView setGestureRecognizers:@[onTapRecognizer]];
}

-(void)configureAsSelected:(BOOL)selected {
    self.selected = selected;
    
    self.layer.borderWidth = BORDER_WIDTH;
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.borderColor = self.selected ? SELECTED_BORDER_COLOR.CGColor : UNSELECTED_BORDER_COLOR.CGColor;
    self.backgroundColor = [UIColor greenColor];
}
@end
