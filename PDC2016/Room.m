//
//  Room.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Room.h"

@implementation Room

+(RKObjectMapping *)defaultMapping {
    RKObjectMapping *roomMapping = [RKObjectMapping mappingForClass:[self class]];
    [roomMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"name": @"name"
                                                      }];
    return roomMapping;
}

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setIdentifier:[self.identifier copyWithZone:zone]];
        [copy setName:[self.name copyWithZone:zone]];
    }
    
    return copy;
}
#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end
