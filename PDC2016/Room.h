//
//  Room.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>
@interface Room : NSObject <NSCoding, NSCopying>

@property(strong,nonatomic) NSNumber *identifier;
@property(strong,nonatomic) NSString *name;

+(RKObjectMapping *)defaultMapping;
@end
