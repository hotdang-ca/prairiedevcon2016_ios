//
//  SpeakersDataSource.m
//  PDC2016
//
//  Created by James Perih on 2016-04-10.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SpeakersDataSource.h"

#import <Restkit/RestKit.h>
#import "PDCApiProvider.h"

@implementation SpeakersDataSource
+(instancetype)sharedDataSource {
    static SpeakersDataSource *datasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datasource = [[SpeakersDataSource alloc] init];
    });
    
    return datasource;
}

-(instancetype)init {
    if (self = [super init]) {
        _speakers = @[];
    }
    return self;
}

-(void)reloadSpeakers {
    [[RKObjectManager sharedManager] getObjectsAtPath:kApiProviderSpeakerListURLString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"speakers"];
        _speakers = mappingResult.array;
        
        [self didChangeValueForKey:@"speakers"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

-(void)reloadSpeakersWithCompanyName:(NSString *)company {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:kApiProviderSpeakersByCompanyURLString, company] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"speakers"];
        _speakers = mappingResult.array;
        [self didChangeValueForKey:@"speakers"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

-(void)reloadSpeakersWithIdentifier:(NSNumber *)identifier {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:kApiProviderSpeakerByIdURLString, identifier] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self willChangeValueForKey:@"speakers"];
        _speakers = mappingResult.array;
        [self didChangeValueForKey:@"speakers"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

@end
