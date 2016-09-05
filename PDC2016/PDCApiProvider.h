//
//  PDCApiProvider.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApiProviderBaseURLString @"http://pdc.hotdang.ca"
#define kApiProviderTimeslotsListURLString @"/api/timeslots"
#define kApiProviderSessionListURLString @"/api/sessions"
#define kApiProviderSpeakerListURLString @"/api/speakers"
#define kApiProviderSpeakerByIdURLString @"/api/speakers/%@"
#define kApiProviderSpeakersByCompanyURLString @"/api/speakers/company/%@"


@interface PDCApiProvider : NSObject
+(instancetype)sharedApiProvider;

-(void)configureForRestkit;
-(NSURL *)baseUrl;

@end
