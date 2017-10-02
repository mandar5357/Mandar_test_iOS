//
//  DatabaseManager.h
//  
//
//  Created by Admin on 16/01/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"


@class DBColumnFilter;
@class AppDelegate;
@class FMResultSet;
@class FMDatabaseQueue;

@interface DatabaseManager : NSObject {

}

+ (id)sharedInstance;

@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSString *appSupportPathSDir;
@property (nonatomic,strong) NSString *databasePath;
-(void)initializeResources;
@end


