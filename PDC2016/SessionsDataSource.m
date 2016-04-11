//
//  SessionsDataSource.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionsDataSource.h"
#import <Restkit/RestKit.h>
#import "PDCApiProvider.h"

#import "Room.h"
#import "Speaker.h"
#import "Session.h"
#import "Timeslot.h"

@implementation SessionsDataSource
NSString *jsonFile = @"sessions.json.dat";

+(instancetype)sharedDataSource {
    static SessionsDataSource *datasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datasource = [[SessionsDataSource alloc] init];
    });
    
    return datasource;
}

-(instancetype)init {
    if (self = [super init]) {
        _sessions = @[];
    }
    return self;
}

-(void)persistToDisk {

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_sessions];
    [data writeToFile:[self.class jsonPath] atomically:YES];
    /*
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_sessions
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (!error) {
        [jsonString writeToFile:[self.class jsonPath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
     */
}

-(void)retrieveFromDisk {
    NSData *data = [NSData dataWithContentsOfFile:[self.class jsonPath]];
    NSArray *jsonArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (jsonArray) {
        [self willChangeValueForKey:@"sessions"];
        _sessions = jsonArray;
        _sortedSessionsByTimeslot = [self sortSessionsWithArray:_sessions];
        [self didChangeValueForKey:@"sessions"];
    }
    /*
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[self.class jsonPath]] options:kNilOptions error:&error];
    if (!error) {
        [self willChangeValueForKey:@"sessions"];
        _sessions = jsonArray;
        [self didChangeValueForKey:@"sessions"];
    }
     */
}

+(BOOL)isCacheAvailable {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.class jsonPath]];
}

+(NSString *)jsonPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *filePath = [cachesDirectory stringByAppendingPathComponent:jsonFile];
    NSLog(@"PATH: %@", filePath);
    
    return filePath;
}

-(void)reloadSessions:(BOOL)forceInternet {
    if (![self.class isCacheAvailable] || forceInternet) {
        [self getFromNetwork];
    } else {
        [self retrieveFromDisk];
    }
    
}

-(void)getFromNetwork {
    [[RKObjectManager sharedManager] getObjectsAtPath:kApiProviderSessionListURLString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [self willChangeValueForKey:@"sessions"];
        _sessions = mappingResult.array;
        [self persistToDisk];
        _sortedSessionsByTimeslot = [self sortSessionsWithArray:_sessions];
        
        [self didChangeValueForKey:@"sessions"];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

-(NSArray *)sortSessionsWithArray:(NSArray *)array {
    NSArray *uniqueTimeDateSlots = [array valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];
    
    
    NSMutableArray *mondayEvents = [NSMutableArray array];
    NSMutableArray *tuesdayEvents = [NSMutableArray array];
    
    for (Session *session in array) {
        if ([session.timeslot.dayString isEqualToString:@"Monday"]) {
            [mondayEvents addObject:session];
        } else if ([session.timeslot.dayString isEqualToString:@"Tuesday"]) {
            [tuesdayEvents addObject:session];
        }
    }
    
    NSArray *mondayTimeSlots = [mondayEvents valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];
    NSArray *tuesdayTimeSlots = [tuesdayEvents valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];
    
    NSMutableArray *mondayByTimeSlot = [NSMutableArray arrayWithCapacity:mondayTimeSlots.count];
    NSMutableArray *tuesdayByTimeSlot = [NSMutableArray arrayWithCapacity:tuesdayTimeSlots.count];
    
    for (int i = 0; i < mondayTimeSlots.count; i++) {
        [mondayByTimeSlot addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < tuesdayTimeSlots.count; i++) {
        [tuesdayByTimeSlot addObject:[NSMutableArray array]];
    }
    
    for (Session *session in mondayEvents) {
        NSInteger indexOfThisSessionTimeslot = [mondayTimeSlots indexOfObject:session.timeslot.timeRange];
        
        if (indexOfThisSessionTimeslot != NSNotFound) {
            [mondayByTimeSlot[indexOfThisSessionTimeslot] addObject:session];
        } else {
            
        }
    }
    
    for (Session *session in tuesdayEvents) {
        NSInteger indexOfThisSessionTimeSlot = [tuesdayTimeSlots indexOfObject:session.timeslot.timeRange];
        
        if (indexOfThisSessionTimeSlot != NSNotFound) {
            [tuesdayByTimeSlot[indexOfThisSessionTimeSlot] addObject:session];
        }
    }
    
    NSArray *sortedMondayArray = [mondayByTimeSlot sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSArray *mondayTimeOrdering = @[
                                        @"7:30 - 8:30",
                                        @"8:30 - 9:30",
                                        @"9:45 - 10:45",
                                        @"10:45 - 11:00",
                                        @"11:00 - 12:00",
                                        @"12:00 - 1:00",
                                        @"1:00 - 2:00",
                                        @"2:00 - 2:15",
                                        @"2:15 - 3:15",
                                        @"3:30 - 4:30",
                                        ];
        NSArray *aArray = (NSArray *)obj1;
        NSArray *bArray = (NSArray *)obj2;
        
        // they should all be grouped by timeslot, so i'm only interested in the first object.
        Session *a = (Session *)aArray[0];
        Session *b = (Session *)bArray[0];
        
        NSInteger aTimeSlotIndex = [mondayTimeOrdering indexOfObject:a.timeslot.timeRange];
        NSInteger bTimeSlotIndex = [mondayTimeOrdering indexOfObject:b.timeslot.timeRange];
        
        return aTimeSlotIndex > bTimeSlotIndex;
    }];
    
    NSArray *sortedTuesdayArray = [tuesdayByTimeSlot sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSArray *tuesdayTimeOrdering = @[
                                         @"7:30 - 8:30",
                                         @"8:30 - 9:30",
                                         @"9:45 - 10:45",
                                         @"10:45 - 11:00",
                                         @"11:00 - 12:00",
                                         @"12:00 - 1:00",
                                         @"1:00 - 2:00",
                                         @"2:00 - 2:15",
                                         @"2:15 - 3:15",
                                         @"3:30 - 4:30"];
        NSArray *aArray = (NSArray *)obj1;
        NSArray *bArray = (NSArray *)obj2;
        
        // they should all be grouped by timeslot, so i'm only interested in the first object.
        Session *a = (Session *)aArray[0];
        Session *b = (Session *)bArray[0];
        
        NSInteger aTimeSlotIndex = [tuesdayTimeOrdering indexOfObject:a.timeslot.timeRange];
        NSInteger bTimeSlotIndex = [tuesdayTimeOrdering indexOfObject:b.timeslot.timeRange];
        
        return aTimeSlotIndex > bTimeSlotIndex;
    }];
    
    
    // now i have two arrays, monday and tuesday.
    NSArray *allEvents = @[sortedMondayArray, sortedTuesdayArray];
    
    return [[NSArray alloc] initWithArray:allEvents];
}
@end
