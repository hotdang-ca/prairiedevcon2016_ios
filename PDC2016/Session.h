//
//  Session.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>

@interface Session : NSObject
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *keywordString;
@property (strong, nonatomic) NSString *sessionDescription;

+(RKObjectMapping *)defaultMapping;
-(NSArray *)keywords;
@end
