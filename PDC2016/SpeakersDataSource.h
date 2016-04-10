//
//  SpeakersDataSource.h
//  PDC2016
//
//  Created by James Perih on 2016-04-10.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSpeakersDataSourceObjectKeyPath @"speakers"
#define kSpeakersDataSourceSingleObjectKeyPath @"speaker"

@interface SpeakersDataSource : NSObject
+(instancetype)sharedDataSource;

-(void)reloadSpeakers;
-(void)reloadSpeakersWithCompanyName:(NSString *)company;
-(void)reloadSpeakersWithIdentifier:(NSNumber *)identifier;

@property (strong, nonatomic) NSArray *speakers;

@end
