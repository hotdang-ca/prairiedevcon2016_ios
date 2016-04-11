//
//  Speaker.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "Speaker.h"
@implementation Speaker

+(RKObjectMapping *)defaultMapping {
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

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.identifier = [decoder decodeObjectForKey:@"identifier"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.companyName = [decoder decodeObjectForKey:@"companyName"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.region = [decoder decodeObjectForKey:@"region"];
        self.bio = [decoder decodeObjectForKey:@"bio"];
        self.imageUrlString = [decoder decodeObjectForKey:@"imageUrlString"];
        self.blogUrlString = [decoder decodeObjectForKey:@"blogUrlString"];
        self.webUrlString = [decoder decodeObjectForKey:@"webUrlString"];
        self.twitterName = [decoder decodeObjectForKey:@"twitterName"];
        self.sessions = [decoder decodeObjectForKey:@"sessions"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.companyName forKey:@"companyName"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.region forKey:@"region"];
    [encoder encodeObject:self.bio forKey:@"bio"];
    [encoder encodeObject:self.imageUrlString forKey:@"imageUrlString"];
    [encoder encodeObject:self.blogUrlString forKey:@"blogUrlString"];
    [encoder encodeObject:self.webUrlString forKey:@"webUrlString"];
    [encoder encodeObject:self.twitterName forKey:@"twitterName"];
    [encoder encodeObject:self.sessions forKey:@"sessions"];
}
#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setIdentifier:[self.identifier copyWithZone:zone]];
        [copy setName:[self.name copyWithZone:zone]];
        [copy setCompanyName:[self.companyName copyWithZone:zone]];
        [copy setCity:[self.city copyWithZone:zone]];
        [copy setRegion:[self.region copyWithZone:zone]];
        [copy setBio:[self.bio copyWithZone:zone]];
        [copy setImageUrlString:[self.imageUrlString copyWithZone:zone]];
        [copy setBlogUrlString:[self.blogUrlString copyWithZone:zone]];
        [copy setWebUrlString:[self.webUrlString copyWithZone:zone]];
        [copy setTwitterName:[self.twitterName copyWithZone:zone]];
        [copy setSessions:[self.sessions copyWithZone:zone]];
    }
    return copy;
}
@end
