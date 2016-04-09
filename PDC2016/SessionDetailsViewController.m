//
//  SessionDetailsViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionDetailsViewController.h"

#import "Session.h"
#import "Room.h"
#import "Speaker.h"
#import "Timeslot.h"

#import "SpeakerDetailsViewController.h"
#import "PDCFavoritesRepository.h"

#import <BlocksKit+UIKit.h>

@interface SessionDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerCompanyLabel;
@property (weak, nonatomic) IBOutlet UITextView *sessionDetailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *keywordsLabel;

@end

@implementation SessionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self config];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[PDCFavoritesRepository sharedRepository] bk_removeObserversWithIdentifier:@"favoritesChanged"];
}

- (void)config {
    if (_session) {
        self.sessionTitleLabel.text = _session.title;
        self.sessionSpeakerLabel.text = _session.speaker.name;
        self.sessionSpeakerCompanyLabel.text = _session.speaker.companyName.length > 2
        ? [NSString stringWithFormat:@"(%@)", _session.speaker.companyName]
        : @"";
        self.sessionDetailsTextView.text = _session.sessionDescription;
        
        self.locationLabel.text = [NSString stringWithFormat:@"%@ - %@"
                                   , _session.timeslot.timeRange
                                   , _session.room.name];
        self.keywordsLabel.text = _session.keywordString;
        
        [self.sessionDetailsTextView scrollRangeToVisible:NSMakeRange(0, 0)];
        
        [self setupGestures];
        
        
        BOOL isFavorite = [[PDCFavoritesRepository sharedRepository] isFavorite:_session.identifier];
        
        UIImage *image = [UIImage imageNamed:isFavorite ? @"fav_bar" : @"no_fav_bar"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:image style:UIBarButtonItemStylePlain handler:^(id sender) {
            [[PDCFavoritesRepository sharedRepository] toggleFavorited:_session.identifier];
            [self changeFavoriteImage: [[PDCFavoritesRepository sharedRepository] isFavorite:_session.identifier]];
        }];
    }
    
}

-(void)changeFavoriteImage:(BOOL)isFavorite {
    UIBarButtonItem *favButton = self.navigationItem.rightBarButtonItem;
    if (favButton) {
        [favButton setImage:[UIImage imageNamed:isFavorite ? @"fav_bar" : @"no_fav_bar"]];
    }
}
-(void)setupGestures {
    
    self.sessionSpeakerLabel.userInteractionEnabled = YES;
    
    [self.sessionSpeakerLabel addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        SpeakerDetailsViewController *speakerDetails = [[SpeakerDetailsViewController alloc] initWithNibName:NSStringFromClass(SpeakerDetailsViewController.class) bundle:[NSBundle mainBundle]];
        if (speakerDetails) {
            speakerDetails.speaker = _session.speaker;
            
            [self.navigationController pushViewController:speakerDetails animated:YES];
        }
    }]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
