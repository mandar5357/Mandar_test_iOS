//
//  DatabaseManager+SearchLocation.m
//  MediPock
//
//  Created by Sphinx Solution Pvt Ltd on 30/09/15.
//  Copyright (c) 2015 Sphinx. All rights reserved.
//

#import "DatabaseManager+SearchLocation.h"
#import "NSObject+SimpleJson.h"
#import "Place.h"

@implementation DatabaseManager (SearchLocation)

- (void)clearLocationSearchData {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @autoreleasepool {
            *rollback = ![db executeUpdate:@"delete from search_location"];
        }
    }];
}

- (NSArray *)getLocationListWithFavorite:(BOOL)favorite
{
    __block NSMutableArray *arr = [[NSMutableArray alloc] init] ;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs;
        
        if(favorite)
            rs = [db executeQuery:@"SELECT * FROM search_location where is_favorite=1 order by local_location_id desc"];
        else
            rs = [db executeQuery:@"SELECT * FROM search_location order by local_location_id desc"];
        
        while ([rs next]) {
            Place *obj =[Place new];
            obj.local_location_id=[rs intForColumn:@"local_location_id"];
            obj.place_id=[rs stringForColumn:@"place_id"];
            obj.name=[rs stringForColumn:@"name"];
            obj.cityName=[rs stringForColumn:@"city_name"];
            obj.lat=[rs stringForColumn:@"lat"];
            obj.lng=[rs stringForColumn:@"lng"];

            obj.is_favorite=[rs boolForColumn:@"is_favorite"];
            
            [arr addObject:obj];
        }
        [rs close];
    }];
    
    return [NSArray arrayWithArray:arr];
}


- (void)insertLocationSearchData:(Place *)term {
    __block Place *weakTerm = term;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs;
        BOOL record_found=NO;
        rs = [db executeQuery:@"SELECT place_id FROM search_location where place_id=?",term.place_id];
        if ([rs next]) {
            record_found=YES;
        }
        if(!record_found)//insert if record not presnt
        {
            [db executeUpdate:@"insert into search_location(place_id,name,city_name,lat,lng,is_favorite) values(?,?,?,?,?,?)", weakTerm.place_id,weakTerm.name, weakTerm.cityName,weakTerm.lat,weakTerm.lng,@(weakTerm.is_favorite)];
        }
    }];
}

-(void)setPlaceAsFavorite:(BOOL)favorite place:(Place*)obj
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"update  search_location set is_favorite=? where local_location_id=?",@(favorite),@(obj.local_location_id)];
    }];

}
@end
