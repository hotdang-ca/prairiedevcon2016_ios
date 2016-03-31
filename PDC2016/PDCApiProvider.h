//
//  PDCApiProvider.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApiProviderBaseURLString @"http://192.168.100.112:8000"
#define kApiProviderTimeslotsListURLString @"/api/timeslots"
#define kApiProviderTimeslotsItemURLString @"/api/timeslots/%@"

@interface PDCApiProvider : NSObject
+(instancetype)sharedApiProvider;
-(NSURL *)baseUrl;
-(NSURL *)timeslotsUrl;
-(NSURL *)timeslotUrlForIdentifier:(NSNumber *)identifier;
@end
