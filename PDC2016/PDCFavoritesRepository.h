//
//  PDCFavoritesRepository.h
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCFavoritesRepository : NSObject

+(instancetype)sharedRepository;

-(void)toggleFavorited:(NSNumber *)identifier;
-(NSArray *)listOfFavorites;

@end
