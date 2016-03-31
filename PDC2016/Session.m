//
//  Session.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Session.h"

@implementation Session

+(RKObjectMapping *)defaultMapping {
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[self class]];
    [sessionMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"title": @"title",
                                                      @"keywords": @"keywordString",
                                                      @"description": @"sessionDescription"
                                                      }];
    return sessionMapping;
}

-(NSArray *)keywords {
    return [self.keywordString componentsSeparatedByString:@","];
}
@end
