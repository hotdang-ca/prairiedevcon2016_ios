//
//  Room.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Room.h"

@implementation Room

+(RKObjectMapping *)roomMapping {
    RKObjectMapping *roomMapping = [RKObjectMapping mappingForClass:[self class]];
    [roomMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"name": @"name"
                                                      }];
    return roomMapping;
}


@end
