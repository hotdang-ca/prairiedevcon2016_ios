//
//  Timeslot.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Timeslot.h"

@implementation Timeslot

+(RKObjectMapping *)defaultMapping {
    RKObjectMapping *timeslotsMapping = [RKObjectMapping mappingForClass:[Timeslot class]];
    
    [timeslotsMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"identifier",
                                                           @"day": @"day",
                                                           @"timerange": @"timeRange"
                                                           }];
    return timeslotsMapping;
}

@end
