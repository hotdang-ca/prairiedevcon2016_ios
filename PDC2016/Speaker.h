//
//  Speaker.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>

@interface Speaker : NSObject
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *imageUrlString;
@property (strong, nonatomic) NSString *blogUrlString;
@property (strong, nonatomic) NSString *webUrlString;
@property (strong, nonatomic) NSString *twitterName;

+(RKObjectMapping *)defaultMapping;
@end
