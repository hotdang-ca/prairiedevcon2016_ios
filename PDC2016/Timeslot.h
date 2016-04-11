//
//  Timeslot.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>

@class Room;
@class Speaker;
@class Session;

@interface Timeslot : NSObject <NSCopying, NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *dayString;
@property (strong, nonatomic) NSString *timeRange;
@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) Speaker *speaker;
@property (strong, nonatomic) Session *session;

+(RKObjectMapping *)defaultMapping;
@end
