//
//  Timeslot.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeslot : NSObject
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *timeRange;

// has one room
// has one session
// has one speaker

@end
