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

@interface SessionDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionSpeakerCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDetailsLabel;
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

- (void)config {
    if (_session) {
        self.sessionTitleLabel.text = _session.title;
        self.sessionSpeakerLabel.text = _session.speaker.name;
        self.sessionSpeakerCompanyLabel.text = _session.speaker.companyName.length > 2
        ? [NSString stringWithFormat:@"(%@)", _session.speaker.companyName]
        : @"";
        self.sessionDetailsLabel.text = _session.sessionDescription;
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

@end
