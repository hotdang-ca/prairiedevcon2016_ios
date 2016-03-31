//
//  Speaker.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Speaker.h"
@implementation Speaker

+(RKObjectMapping *)speakerMapping {
    RKObjectMapping *speakerMapping = [RKObjectMapping mappingForClass:[self class]];
    [speakerMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"name": @"name",
                                                      @"company": @"companyName",
                                                      @"city": @"city",
                                                      @"region": @"region",
                                                      @"bio": @"bio",
                                                      @"image_url": @"imageUrlString",
                                                      @"blog_url": @"blogUrlString",
                                                      @"website_url": @"webUrlString",
                                                      @"twitter_name": @"twitterName"
                                                      }];
    return speakerMapping;
}
@end
