//
//  SessionTableViewCell.h
//  PDC2016
//
//  Created by James Perih on 2016-04-10.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Session;

@interface SessionTableViewCell : UITableViewCell
-(void)configureWithSession:(Session *)session;
@end
