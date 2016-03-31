//
//  PDCApiProvider.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "PDCApiProvider.h"

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

-(NSURL *)timeslotsUrl {
    return [NSURL URLWithString:@"/api/timeslots" relativeToURL:[self baseUrl]];
}

-(NSURL *)timeslotUrlForIdentifier:(NSNumber *)identifier {
    return [NSURL URLWithString:[NSString stringWithFormat:@"/api/timeslots/%d", identifier.integerValue] relativeToURL:[self baseUrl]];
}

@end
