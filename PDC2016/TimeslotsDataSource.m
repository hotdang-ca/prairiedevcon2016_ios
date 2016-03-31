//
//  TimeslotsDataSource.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "TimeslotsDataSource.h"
#import "Timeslot.h"
#import <Restkit/RestKit.h>
#import "PDCApiProvider.h"
#import "Room.h"
#import "Speaker.h"
#import "Session.h"

@implementation TimeslotsDataSource
+(instancetype)sharedDataSource {
    static TimeslotsDataSource *datasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datasource = [[TimeslotsDataSource alloc] init];
    });
    
    return datasource;
}

-(instancetype)init {
    if (self = [super init]) {
        _timeslots = @[];
    }
    return self;
}

-(void)reloadTimeslots {
    [[RKObjectManager sharedManager] getObjectsAtPath:kApiProviderTimeslotsListURLString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"timeslots"];
        _timeslots = mappingResult.array;
        [self didChangeValueForKey:@"timeslots"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}
@end
