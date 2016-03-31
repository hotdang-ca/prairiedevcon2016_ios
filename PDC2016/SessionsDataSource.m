//
//  SessionsDataSource.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionsDataSource.h"
#import <Restkit/RestKit.h>
#import "PDCApiProvider.h"

#import "Room.h"
#import "Speaker.h"
#import "Session.h"
#import "Timeslot.h"

@implementation SessionsDataSource

+(instancetype)sharedDataSource {
    static SessionsDataSource *datasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datasource = [[SessionsDataSource alloc] init];
    });
    
    return datasource;
}

-(instancetype)init {
    if (self = [super init]) {
        _sessions = @[];
    }
    return self;
}

-(void)reloadSessions {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kApiProviderSessionListURLString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"sessions"];
        _sessions = mappingResult.array;
        [self didChangeValueForKey:@"sessions"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}


@end
