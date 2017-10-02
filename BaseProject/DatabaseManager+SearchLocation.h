//
//  DatabaseManager+SearchLocation.h
//  MediPock
//
//  Created by Sphinx Solution Pvt Ltd on 30/09/15.
//  Copyright (c) 2015 Sphinx. All rights reserved.
//

#import "DatabaseManager.h"
@class Place;
@interface DatabaseManager (SearchLocation)

- (void)clearLocationSearchData;
- (NSArray *)getLocationListWithFavorite:(BOOL)favorite;
- (void)insertLocationSearchData:(Place *)term;
-(void)setPlaceAsFavorite:(BOOL)favorite place:(Place*)obj;
@end
