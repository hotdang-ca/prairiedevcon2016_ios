//
//  SpeakerDetailsViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SpeakerDetailsViewController.h"
#import "DetailNotesViewController.h"

#import "Speaker.h"
#import "SpeakersDataSource.h"

#import "Session.h"
#import "SessionDetailsViewController.h"

#import "SessionTableViewCell.h"

#import "Timeslot.h"

#import <BlocksKit+UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface SpeakerDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerCityAndRegionLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerBioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;

@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *blogButton;

@property (weak, nonatomic) IBOutlet UITableView *sessionsTableView;

@property (strong, nonatomic) NSArray *sessions;
@end

@implementation SpeakerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _sessions = @[];
    
    UINib *sessionNib = [UINib nibWithNibName:NSStringFromClass(SessionTableViewCell.class) bundle:[NSBundle mainBundle]];
    [self.sessionsTableView registerNib:sessionNib forCellReuseIdentifier:@"SpeakerSessionCell"];
    
    [self configure];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[SpeakersDataSource sharedDataSource] addObserver:self forKeyPath:@"speakers" options:0 context:NULL];
    [[SpeakersDataSource sharedDataSource] reloadSpeakers];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // speakers array is new
    NSInteger speakerIndex = [[SpeakersDataSource sharedDataSource].speakers indexOfObjectPassingTest:^BOOL(Speaker * _Nonnull speaker, NSUInteger idx, BOOL * _Nonnull stop) {
        return [speaker.identifier isEqualToNumber:_speaker.identifier];
    }];
    
    Speaker *detailedSpeaker = [SpeakersDataSource sharedDataSource].speakers[speakerIndex];
    _sessions = [detailedSpeaker.sessions allObjects];
    
    [_sessionsTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SpeakersDataSource sharedDataSource] removeObserver:self forKeyPath:@"speakers"];
}

- (void)configure {
    if (_speaker) {
        self.speakerNameLabel.text = _speaker.name;
        self.speakerCompanyLabel.text = _speaker.companyName;
        self.speakerCityAndRegionLabel.text = [NSString stringWithFormat:@"%@, %@", _speaker.city, _speaker.region];
        self.speakerBioLabel.text = _speaker.bio;
        
        [self.speakerImageView setImageWithURL:[NSURL URLWithString:_speaker.imageUrlString]placeholderImage:[UIImage imageNamed:@"PrDCLogo"]];
        
        if (_speaker.webUrlString && _speaker.webUrlString.length > 0) {
            [_webButton setEnabled:YES];
            [_webButton bk_whenTapped:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_speaker.webUrlString]];
            }];
        } else {
            [_webButton setEnabled:NO];
        }
        
        if (_speaker.twitterName && _speaker.twitterName.length > 0) {
            _twitterButton.enabled = YES;
            NSString *twitterURLString = [NSString stringWithFormat:@"https://twitter.com/%@",_speaker.twitterName];
            [_twitterButton setTitle:[NSString stringWithFormat:@"@%@", _speaker.twitterName] forState:UIControlStateNormal];
            [_twitterButton bk_whenTapped:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterURLString]];
            }];
        } else {
            _twitterButton.enabled = NO;
            [_twitterButton setTitle:@"Twitter" forState:UIControlStateNormal];
        }
        
        if (_speaker.blogUrlString && _speaker.blogUrlString.length > 0) {
            _blogButton.enabled = YES;
            [_blogButton bk_whenTapped:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_speaker.blogUrlString]];
            }];
        } else {
            _blogButton.enabled = NO;
        }
        
        
        UIImage *editImage = [UIImage imageNamed:@"edit"];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] bk_initWithImage:editImage style:UIBarButtonItemStylePlain handler:^(id sender) {
            DetailNotesViewController *notesViewController = [[DetailNotesViewController alloc] initWithNibName:NSStringFromClass(DetailNotesViewController.class)  bundle:[NSBundle mainBundle]];
            if (notesViewController) {
                notesViewController.sessionOrSpeakerObject = _speaker;
                [self.navigationController pushViewController:notesViewController animated:YES];
            }
        }];
        
        self.navigationItem.rightBarButtonItems = @[editButton];
    }
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

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sessions.count;
}

#pragma mark - TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell *cell = [_sessionsTableView dequeueReusableCellWithIdentifier:@"SpeakerSessionCell" forIndexPath:indexPath];
    
    Session *session = [_sessions objectAtIndex:indexPath.row];
    
    if (cell && session) {
        [cell configureWithSession:session];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Session *session = [_sessions objectAtIndex:indexPath.row];
    
    SessionDetailsViewController *detailsController = [[SessionDetailsViewController alloc] initWithNibName:@"SessionDetailsViewController" bundle:[NSBundle mainBundle]];
    
    detailsController.session = session;
    [self.navigationController pushViewController:detailsController animated:YES];
}
@end
