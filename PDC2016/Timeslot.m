//
//  Timeslot.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Timeslot.h"

#import "Room.h"
#import "Speaker.h"
#import "Session.h"

@implementation Timeslot

+(RKObjectMapping *)defaultMapping {
    RKObjectMapping *timeslotsMapping = [RKObjectMapping mappingForClass:[Timeslot class]];
    
    [timeslotsMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"identifier",
                                                           @"day": @"dayString",
                                                           @"timerange": @"timeRange"
                                                           }];
    return timeslotsMapping;
}

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setIdentifier:[self.identifier copyWithZone:zone]];
        [copy setDayString:[self.dayString copyWithZone:zone]];
        [copy setTimeRange:[self.timeRange copyWithZone:zone]];
        
        [copy setRoom:[self.room copyWithZone:zone]];
        [copy setSession:[self.session copyWithZone:zone]];
        [copy setSpeaker:[self.speaker copyWithZone:zone]];
    }
    return copy;
}
#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.dayString forKey:@"dayString"];
    [aCoder encodeObject:self.timeRange forKey:@"timeRange"];
    
    [aCoder encodeObject:self.room forKey:@"room"];
    [aCoder encodeObject:self.session forKey:@"session"];
    [aCoder encodeObject:self.speaker forKey:@"speaker"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.dayString = [aDecoder decodeObjectForKey:@"dayString"];
        self.timeRange = [aDecoder decodeObjectForKey:@"timeRange"];
        
        self.room = [aDecoder decodeObjectForKey:@"room"];
        self.session = [aDecoder decodeObjectForKey:@"session"];
        self.speaker = [aDecoder decodeObjectForKey:@"speaker"];
    }
    
    return self;
}
@end
