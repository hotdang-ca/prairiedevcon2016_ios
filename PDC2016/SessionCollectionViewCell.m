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

CGFloat CORNER_RADIUS = 2.0;
CGFloat BORDER_WIDTH = 0.0;
#define SELECTED_BORDER_COLOR [UIColor yellowColor]
#define UNSELECTED_BORDER_COLOR [UIColor whiteColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:203/255 green:91/255 blue:94/255 alpha:1.0]

@interface SessionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionKeywordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerCompany;
@property (weak, nonatomic) IBOutlet UILabel *sessionTimeslotDayAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionRoomNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIView *view;

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
                                            , session.timeslot.dayString
                                            , session.timeslot.timeRange];
    _sessionRoomNameLabel.text = session.room.name;
    // should be selected
    NSArray *favorites = [PDCFavoritesRepository sharedRepository].listOfFavorites;
    
    if ([favorites indexOfObject:session.identifier] != NSNotFound) {
        [self configureAsSelected:YES];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:(237.0/255.0) green:(237.0/255.0) blue:(237.0/255.0) alpha:1.0];
    
    [self configureActionsWithSession:session];
}

-(void)configureActionsWithSession:(Session *)session {
    id tapGestureBlock = ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
        [[PDCFavoritesRepository sharedRepository] toggleFavorited:session.identifier];
        [self configureAsSelected:!self.selected];
    };
    UITapGestureRecognizer *onTapRecognizer = [UITapGestureRecognizer bk_recognizerWithHandler:tapGestureBlock];
    
    // TODO: this should only be on the Favorites button
    // What favorites button? Oh yeah...
    [self.favoriteImageView setGestureRecognizers:@[onTapRecognizer]];
} 

-(void)configureAsSelected:(BOOL)selected {
    self.selected = selected;
    
    self.layer.borderWidth = BORDER_WIDTH;
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.borderColor = UNSELECTED_BORDER_COLOR.CGColor;
    
    self.favoriteImageView.image = [UIImage imageNamed:selected ? @"fav_bar" : @"no_fav_bar"];
}
@end
