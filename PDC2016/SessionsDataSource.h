//
//  SessionsDataSource.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSessionsDataSourceObjectKeyPath @"sessions"

@interface SessionsDataSource : NSObject
+(instancetype)sharedDataSource;

-(void)reloadSessions:(BOOL)forceInternet;

@property (strong, nonatomic) NSArray *sessions;
@property (strong, nonatomic) NSArray *sortedSessionsByTimeslot;
@end
