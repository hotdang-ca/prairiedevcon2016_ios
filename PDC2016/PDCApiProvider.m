//
//  PDCApiProvider.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "PDCApiProvider.h"
#import <Restkit/Restkit.h>

#import "Timeslot.h"
#import "TimeslotsDataSource.h"

#import "Speaker.h"
#import "SpeakersDataSource.h"

#import "Session.h"
#import "SessionsDataSource.h"

#import "Room.h"

@implementation PDCApiProvider

+(instancetype)sharedApiProvider {
    static PDCApiProvider *apiProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiProvider = [[PDCApiProvider alloc] init];
    });
    return apiProvider;
}

-(NSURL *)baseUrl {
    return [NSURL URLWithString:kApiProviderBaseURLString];
}

-(void)configureForRestkit {
    NSURL *baseURL = [[PDCApiProvider sharedApiProvider] baseUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *timeslotsMapping = [Timeslot defaultMapping];
    RKObjectMapping *speakersMapping = [Speaker defaultMapping];
    RKObjectMapping *sessionMapping = [Session defaultMapping];
    

    // TODO: need many sessions
    [speakersMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sessions" toKeyPath:@"sessions" withMapping:sessionMapping]];
    
    
    
//    RKResponseDescriptor *speakersByIdResponseDescriptor =
//    [RKResponseDescriptor responseDescriptorWithMapping:speakersMapping
//                                                 method:RKRequestMethodGET
//                                            pathPattern:kApiProviderSpeakerByIdURLString
//                                                keyPath:kSpeakersDataSourceSingleObjectKeyPath
//                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [timeslotsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"room" toKeyPath:@"room" withMapping:[Room defaultMapping]]];
    [timeslotsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"speaker" toKeyPath:@"speaker" withMapping:[Speaker defaultMapping]]];
    [timeslotsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"session" toKeyPath:@"session" withMapping:[Session defaultMapping]]];
    

    
    
    [sessionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"speaker" toKeyPath:@"speaker" withMapping:[Speaker defaultMapping]]];
    [sessionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"room" toKeyPath:@"room" withMapping:[Room defaultMapping]]];
    [sessionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"timeslot" toKeyPath:@"timeslot" withMapping:[Timeslot defaultMapping]]];
    
    
    RKResponseDescriptor *timeslotResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:timeslotsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kApiProviderTimeslotsListURLString
                                                keyPath:kTimeslotsDataSourceObjectKeyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *speakersResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:speakersMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kApiProviderSpeakerListURLString
                                                keyPath:kSpeakersDataSourceObjectKeyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];

    RKResponseDescriptor *sessionResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:sessionMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kApiProviderSessionListURLString
                                                keyPath:kSessionsDataSourceObjectKeyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:speakersResponseDescriptor];
//    [objectManager addResponseDescriptor:speakersByIdResponseDescriptor];
    
    [objectManager addResponseDescriptor:timeslotResponseDescriptor];
    [objectManager addResponseDescriptor:sessionResponseDescriptor];
}
@end
