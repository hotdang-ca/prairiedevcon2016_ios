//
//  PDCFavoritesRepository.m
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "PDCFavoritesRepository.h"

@interface PDCFavoritesRepository ()
@property (strong, nonatomic) NSMutableArray *sharedFavorites;
@end

@implementation PDCFavoritesRepository

#pragma mark - Initializers
+(instancetype)sharedRepository {
    static PDCFavoritesRepository *favoritesRepository = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        favoritesRepository = [[PDCFavoritesRepository alloc] init];
    });
    
    return favoritesRepository;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.sharedFavorites = [[NSMutableArray alloc] initWithArray:[[self class] favoritesFromPrefs]];
    }
    return self;
}

#pragma mark - Instance Methods
-(void)toggleFavorited:(NSNumber *)identifier {
    if (self.sharedFavorites) {
        [self willChangeValueForKey:@"listOfFavorites"];
        
        if ([self.sharedFavorites indexOfObject:identifier] == NSNotFound) {
            [self.sharedFavorites addObject:identifier];
        } else {
            [self.sharedFavorites removeObject:identifier];
        }
        
        [self didChangeValueForKey:@"listOfFavorites"];
        
        [self.class saveToPrefs:self.sharedFavorites];
    }
}

-(NSArray *)listOfFavorites {
    return [NSArray arrayWithArray:self.sharedFavorites];
}

-(BOOL)isFavorite:(NSNumber *)identifier {
    if (self.sharedFavorites) {
        return [self.sharedFavorites indexOfObject:identifier] != NSNotFound;
    }
    return NO;
}

#pragma mark - Internal Helpers
+(NSArray *)favoritesFromPrefs {
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    if (!favorites) {
        favorites = @[];
    }
    return favorites;
}

+(void) saveToPrefs:(NSArray*)favorites {
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
