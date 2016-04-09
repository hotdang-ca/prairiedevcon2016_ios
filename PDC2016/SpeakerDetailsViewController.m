//
//  SpeakerDetailsViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SpeakerDetailsViewController.h"

#import "Speaker.h"

#import <BlocksKit+UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface SpeakerDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *speakerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerCityAndRegionLabel;
@property (weak, nonatomic) IBOutlet UITextView *speakerBioTextView;
@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;

@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *blogButton;

@end

@implementation SpeakerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configure];
}

- (void)configure {
    if (_speaker) {
        self.speakerNameLabel.text = _speaker.name;
        self.speakerCompanyLabel.text = _speaker.companyName;
        self.speakerCityAndRegionLabel.text = [NSString stringWithFormat:@"%@, %@", _speaker.city, _speaker.region];
        self.speakerBioTextView.text = _speaker.bio;
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
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Speaker: %@", self.speaker.name);
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
