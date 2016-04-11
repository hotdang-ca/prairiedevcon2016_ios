//
//  Session.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>
@class Speaker;
@class Room;
@class Timeslot;

@interface Session : NSObject <NSCopying,NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *keywordString;
@property (strong, nonatomic) NSString *sessionDescription;

@property (strong, nonatomic) Speaker *speaker;
@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) Timeslot *timeslot;

+(RKObjectMapping *)defaultMapping;
-(NSArray *)keywords;
@end
