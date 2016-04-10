//
//  SpeakerDetailsViewController.h
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Speaker;

@interface SpeakerDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Speaker *speaker;

@end
