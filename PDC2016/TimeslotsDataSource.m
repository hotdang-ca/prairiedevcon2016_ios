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

#define kTimeslotsDataSourceObjectKeyPath @"timeslots"

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
        [self configureForRestkit];
    }
    return self;
}

-(void)configureForRestkit {
    NSURL *baseURL = [[PDCApiProvider sharedApiProvider] baseUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
        
    RKObjectMapping *timeslotsMapping = [RKObjectMapping mappingForClass:[Timeslot class]];
    
    [timeslotsMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"identifier",
                                                           @"day": @"day",
                                                           @"timerange": @"timeRange"
                                                           }];
    [timeslotsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"room" toKeyPath:@"room" withMapping:[Room roomMapping]]];
    [timeslotsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"speaker" toKeyPath:@"speaker" withMapping:[Speaker speakerMapping]]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeslotsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kApiProviderTimeslotsListURLString
                                                keyPath:kTimeslotsDataSourceObjectKeyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
}

-(void)reloadTimeslots {
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/timeslots" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"timeslots"];
        _timeslots = mappingResult.array;
        [self didChangeValueForKey:@"timeslots"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}
@end
