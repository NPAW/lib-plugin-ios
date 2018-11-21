//
//  YBAppDatabase.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 16/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBAppDatabase.h"
#import "YBEventQueries.h"
#import "YBEvent.h"
#import "YBLog.h"

#import <sqlite3.h>

@interface YBAppDatabase()

@property (nonatomic,strong) NSString* filename;
@property sqlite3* database;
@property BOOL isDbOpened;
@end

@implementation YBAppDatabase

@synthesize database;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] initWithDatabaseFilename:@"youbora-offline.db"];
        
    });
    return sharedInstance;
}

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        [self createDatabaseWithFileName: dbFilename];
        self.filename = dbFilename;
    }
    return self;
}

- (BOOL) createDatabaseWithFileName: (NSString*) filename{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    NSString *writableDBPath = [self writableDBPathWithName:filename];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return success;
    
    // construct database from external ud.sql
 
    if(sqlite3_open_v2([writableDBPath UTF8String], &database, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX|SQLITE_OPEN_CREATE, NULL) == SQLITE_OK)
    {
        sqlite3_exec(database, [YouboraEventCreateTable UTF8String], NULL, NULL, NULL);
        sqlite3_close_v2(database);
    }
    return success;
}

- (NSString*) writableDBPathWithName:(NSString*) dbName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:dbName];
}

- (NSNumber*) insertEvent:(YBEvent*) event{
    
    if([self openDB]){
        sqlite3_stmt    *statement;
        
        NSString * timestamp = [NSString stringWithFormat:@"%.0f", round(CFAbsoluteTimeGetCurrent()*1000)];
        
        // preparing a query compiles the query so it can be re-used.
        sqlite3_prepare_v2(database, [YouboraEventCreate UTF8String], -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [event.jsonEvents UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_double(statement, 2, [timestamp doubleValue]);
        sqlite3_bind_int64(statement, 3, [event.offlineId intValue]);
        
        // process result
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            [YBLog error:@"SQLite database error: %s",sqlite3_errmsg(database)];
        }
        
        long lastId = (long)sqlite3_last_insert_rowid(database);
        
        sqlite3_finalize(statement);
        [self closeDB];
        return [NSNumber numberWithLong:lastId];
    }
    [self closeDB];
    return @(-1);
    
}

- (NSArray*)allEvents{
    
    NSMutableArray<YBEvent*> *events = [[NSMutableArray alloc] init];
    
    if([self openDB])
    {
        const char *sqlStatement = [YouboraEventGetAll UTF8String];
        
        sqlite3_stmt *compiledStatement;
        NSInteger result = sqlite3_prepare_v2(database,sqlStatement, -1, &compiledStatement, NULL);

        if(result == SQLITE_OK)
        {
            YBEvent* event = nil;
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                event = [[YBEvent alloc] init];
                event.id = sqlite3_column_int(compiledStatement, 0);
                event.jsonEvents = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(compiledStatement, 1)];
                event.dateUpdate = [NSNumber numberWithDouble:sqlite3_column_double(compiledStatement, 2)];
                event.offlineId = [NSNumber numberWithDouble:sqlite3_column_int(compiledStatement, 3)];
                
                [events addObject:event];
            }
            sqlite3_reset(compiledStatement);
        }
        else
        {
            [YBLog error:@"Prepare-error #%li: %s", (long)result, sqlite3_errmsg(database)];
        }
        sqlite3_finalize(compiledStatement);
    }
    
    [self closeDB];
    
    return [events copy];
}

- (NSNumber*) lastId{
    if([self openDB]){
        const char *sqlStatement = [YouboraEventGetLastId UTF8String];
        
        sqlite3_stmt *compiledStatement;
        NSInteger result = sqlite3_prepare_v2(database,sqlStatement, -1, &compiledStatement, NULL);
        
        if(result == SQLITE_OK){
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSNumber *eventId = @(sqlite3_column_int(compiledStatement, 0));
                sqlite3_finalize(compiledStatement);
                [self closeDB];
                return eventId;
            }
            sqlite3_reset(compiledStatement);
        }
        else
        {
            [YBLog error:@"Prepare-error #%li: %s", (long)result, sqlite3_errmsg(database)];
        }
    }
    return @(0);
}

- (NSArray*)eventsWithOfflineId:(NSNumber *)offlineId{
    
    NSMutableArray<YBEvent*> *events = [[NSMutableArray alloc] init];
    
    if([self openDB])
    {
        const char *sqlStatement = [[NSString stringWithFormat:YouboraEventGetByOfflineId,[offlineId stringValue]] UTF8String];
        
        sqlite3_stmt *compiledStatement;
        NSInteger result = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
        if(result == SQLITE_OK)
        {
            sqlite3_bind_int(compiledStatement,0, [offlineId intValue]);
            YBEvent* event = nil;
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                event = [[YBEvent alloc] init];
                event.id = sqlite3_column_int(compiledStatement, 0);
                event.jsonEvents = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(compiledStatement, 1)];
                event.dateUpdate = [NSNumber numberWithDouble:sqlite3_column_double(compiledStatement, 2)];
                event.offlineId = [NSNumber numberWithDouble:sqlite3_column_int(compiledStatement, 3)];
                
                [events addObject:event];
            }
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
        }
        else
        {
            [YBLog error:@"Prepare-error #%li: %s", (long)result, sqlite3_errmsg(database)];
        }
    }
    
    [self closeDB];
    
    return [events copy];
}

- (NSNumber*) firstId{
    if([self openDB]){
        const char *sqlStatement = [YouboraEventGetFirstId UTF8String];
        
        sqlite3_stmt *compiledStatement;
        NSInteger result = sqlite3_prepare_v2(database,sqlStatement, -1, &compiledStatement, NULL);
        
        if(result == SQLITE_OK){
            while (sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSNumber *eventId = @(sqlite3_column_int(compiledStatement, 0));
                sqlite3_finalize(compiledStatement);
                [self closeDB];
                return eventId;
            }
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
        }
    }
    return @(0);
}

- (void) removeEventsWithId:(NSNumber*) offlineId{
    if([self openDB]){
        sqlite3_stmt    *statement;
        
        // preparing a query compiles the query so it can be re-used.
        sqlite3_prepare_v2(database, [[NSString stringWithFormat:YouboraEventDeleteEventsByOfflineId, [offlineId stringValue]] UTF8String], -1, &statement, NULL);
        
        // process result
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            [YBLog error:@"SQLite database error: %s",sqlite3_errmsg(database)];
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    [self closeDB];
}

- (bool) openDB{
    //sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
    sqlite3_initialize();
    if (self.isDbOpened == false) {
        if (sqlite3_open_v2([[self writableDBPathWithName:self.filename] UTF8String], &database, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK) {
            self.isDbOpened = true;
        } else {
            [YBLog error:@"SQLite database error: %s",sqlite3_errmsg(database)];
        }
    }
    return self.isDbOpened;
}

- (void) closeDB{
    //Removed for now since the db connection is never closed
    /*sqlite3_close(database);
    sqlite3_shutdown();*/
}

@end
