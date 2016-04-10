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
#import "DetailNotesViewController.h"

#import "PDCFavoritesRepository.h"

#import <BlocksKit+UIKit.h>

#define BUTTON_TAG_FAV 1
#define BUTTON_TAG_EDIT 2
#define SYSTEM_SPEAKER_ID @34

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
    [_sessionDetailsTextView setContentOffset:CGPointZero animated:YES];
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
        
        [self setupGestures];        
        
        [self setupFavoriteButtonIfNeeded];
        [self setupEditButtonIfNeeded];
    }
    
}

-(void)setupEditButtonIfNeeded {
    if ([_session.speaker.identifier isEqualToNumber:SYSTEM_SPEAKER_ID]) {
        return;
    }
    
    UIImage *editImage = [UIImage imageNamed:@"edit"];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] bk_initWithImage:editImage style:UIBarButtonItemStylePlain handler:^(id sender) {
        DetailNotesViewController *notesViewController = [[DetailNotesViewController alloc] initWithNibName:NSStringFromClass(DetailNotesViewController.class)  bundle:[NSBundle mainBundle]];
        if (notesViewController) {
            
            notesViewController.sessionOrSpeakerObject = _session;
            
            [self.navigationController pushViewController:notesViewController animated:YES];
        }
    }];
    
    editButton.tag = BUTTON_TAG_EDIT;
    
    NSMutableArray <UIBarButtonItem *> *rightBarItems = [self.navigationItem.rightBarButtonItems mutableCopy] ?: [[NSMutableArray alloc] init];
    
    [rightBarItems addObject:editButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:rightBarItems];
}
-(void)setupFavoriteButtonIfNeeded {
    if ([_session.speaker.identifier isEqualToNumber:SYSTEM_SPEAKER_ID]) {
        return;
    }
    
    BOOL isFavorite = [[PDCFavoritesRepository sharedRepository] isFavorite:_session.identifier];
    
    UIImage *favImage = [UIImage imageNamed:isFavorite ? @"fav_bar" : @"no_fav_bar"];
    
    UIBarButtonItem *favButton = [[UIBarButtonItem alloc] bk_initWithImage:favImage style:UIBarButtonItemStylePlain handler:^(id sender) {
        [[PDCFavoritesRepository sharedRepository] toggleFavorited:_session.identifier];
        [self changeFavoriteImage: [[PDCFavoritesRepository sharedRepository] isFavorite:_session.identifier]];
    }];
    favButton.tag = BUTTON_TAG_FAV;
    
    NSMutableArray <UIBarButtonItem *> *rightBarItems = [self.navigationItem.rightBarButtonItems mutableCopy] ?: [[NSMutableArray alloc] init];
    
    [rightBarItems addObject:favButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:rightBarItems];
}

-(void)changeFavoriteImage:(BOOL)isFavorite {
    
    id passingTestBlock = ^BOOL(UIBarButtonItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        return item.tag == BUTTON_TAG_FAV;
    };
    
    UIBarButtonItem *favButton = [self.navigationItem.rightBarButtonItems objectAtIndex:[self.navigationItem.rightBarButtonItems indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:passingTestBlock]];
    
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
