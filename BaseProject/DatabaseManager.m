//
//  DatabaseManager.m
//  
//
//  Created by Admin on 16/01/13.
//
//

#import "DatabaseManager.h"

#import "Constants.h"

#import "Utility.h"
@implementation DatabaseManager


#pragma mark -  Singleton Methods
+(void)initialize
{
    if(self == [DatabaseManager class]) {
       // UIAppDelegate.isFromLogin=[DatabaseUpdateManager doDatabaseUpgrade];
    }
}

+ (DatabaseManager *)sharedInstance {
    static DatabaseManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

#pragma mark - init Method
- (id)init {
    
    self = [super init];
    if (self) {
        
        [self initializeResources];
 
    }
    return self;
}

#pragma mark - LifeCycle of DataBase Operations

-(void)initializeResources
{
    
    NSArray *appSupportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    self.appSupportPathSDir = [appSupportPaths objectAtIndex:0];
    self.databasePath = [ self.appSupportPathSDir stringByAppendingPathComponent:DATABASE_NAME];

    SSLog(@"self.databasePath %@",self.databasePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath])
    {
         self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
    }
    else
    {
        
        [DatabaseManager createDb];
    }
    
}


+(NSError*)createDb
{
    NSString* databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    
    NSArray *appSupportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportPathSDir = [appSupportPaths objectAtIndex:0];
    NSString * _databasePath = [appSupportPathSDir stringByAppendingPathComponent:DATABASE_NAME];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:databasePathFromApp toPath:_databasePath error:&error];
    [AppManager addSkipBackupAttributeToItemAtPath:_databasePath];
    return error;
}

#pragma mark -  Dealloc Method
- (void)dealloc {
    [self.dbQueue close];
    self.dbQueue = nil;
}
@end
