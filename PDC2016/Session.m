//
//  Session.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Session.h"

#import "Speaker.h"
#import "Timeslot.h"
#import "Room.h"

@implementation Session

+(RKObjectMapping *)defaultMapping {
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[self class]];
    [sessionMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"title": @"title",
                                                      @"keywords": @"keywordString",
                                                      @"description": @"sessionDescription"
                                                      }];
    return sessionMapping;
}

-(NSArray *)keywords {
    return [self.keywordString componentsSeparatedByString:@","];
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.keywordString forKey:@"keywordString"];
    [aCoder encodeObject:self.sessionDescription forKey:@"sessionDescription"];
    
    [aCoder encodeObject:self.speaker forKey:@"speaker"];
    [aCoder encodeObject:self.timeslot forKey:@"timeslot"];
    [aCoder encodeObject:self.room forKey:@"room"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.keywordString = [aDecoder decodeObjectForKey:@"keywordString"];
        self.sessionDescription = [aDecoder decodeObjectForKey:@"sessionDescription"];
        
        self.speaker = [aDecoder decodeObjectForKey:@"speaker"];
        self.timeslot = [aDecoder decodeObjectForKey:@"timeslot"];
        self.room = [aDecoder decodeObjectForKey:@"room"];
    }
    return self;
}


#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setIdentifier:[self.identifier copyWithZone:zone]];
        [copy setTitle:[self.title copyWithZone:zone]];
        [copy setKeywordString:[self.keywordString copyWithZone:zone]];
        [copy setSpeaker:[self.speaker copyWithZone:zone]];
        [copy setTimeslot:[self.timeslot copyWithZone:zone]];
        [copy setRoom:[self.room copyWithZone:zone]];
    }
    return copy;
}
@end
