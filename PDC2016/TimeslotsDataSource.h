//
//  TimeslotsDataSource.h
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeslotsDataSource : NSObject
+(instancetype)sharedDataSource;

-(void)reloadTimeslots;

@property (strong, nonatomic) NSArray *timeslots;
@end
