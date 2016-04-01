//
//  SessionCollectionViewCell.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Session;

#define kSessionReuseIdentifier @"SessionCell"

@interface SessionCollectionViewCell : UICollectionViewCell
-(void)configureWithSession:(Session *)session;

@end
