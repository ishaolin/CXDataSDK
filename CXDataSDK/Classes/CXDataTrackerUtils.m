//
//  CXDataTrackerUtils.m
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataTrackerUtils.h"
#import <CXDatabaseSDK/CXDatabaseSDK.h>

@implementation CXDataTrackerUtils

+ (void)createTable{
    CX_CREATE_TABLE(@"CREATE TABLE IF NOT EXISTS T_TRACKER_DATA ([ID] INTEGER PRIMARY KEY AUTOINCREMENT, [EVENT_ID] VARCHAR(64) NOT NULL, TIME INTEGER NOT NULL, PARAMS TEXT NOT NULL);");
}

+ (NSArray<CXDataTrackerModel *> *)old30DataTrackerModels{
    NSString *sql = @"SELECT ID, EVENT_ID, TIME, PARAMS FROM T_TRACKER_DATA ORDER BY ID ASC LIMIT 30 OFFSET 0;";
    NSMutableArray<CXDataTrackerModel *> *dataTrackerModels = [NSMutableArray array];
    [CXDatabaseUtils executeQuery:sql arguments:nil handler:^(FMResultSet *rs) {
        while([rs next]){
            CXDataTrackerModel *dataTrackerModel = [[CXDataTrackerModel alloc] init];
            dataTrackerModel.dbId = [rs longForColumn:@"ID"];
            dataTrackerModel.eventId = [rs stringForColumn:@"EVENT_ID"];
            dataTrackerModel.time = [rs longForColumn:@"TIME"];
            dataTrackerModel.params = [rs stringForColumn:@"PARAMS"];
            [dataTrackerModels addObject:dataTrackerModel];
        }
    }];
    
    return [dataTrackerModels copy];
}

+ (NSInteger)allDataTrackerModelCount{
    NSString *sql = @"SELECT COUNT(ID) AS COUNT FROM T_TRACKER_DATA;";
    __block NSInteger count = 0;
    [CXDatabaseUtils executeQuery:sql arguments:nil handler:^(FMResultSet *rs) {
        if([rs next]){
            count = [rs longForColumn:@"COUNT"];
        }
    }];
    
    return count;
}

+ (void)addDataTrackerModel:(CXDataTrackerModel *)dataTrackerModel{
    if(!dataTrackerModel){
        return;
    }
    NSString *sql = @"INSERT INTO T_TRACKER_DATA (EVENT_ID, TIME, PARAMS) VALUES(?, ?, ?);";
    [CXDatabaseUtils executeUpdate:sql
                         arguments:@[dataTrackerModel.eventId,
                                     @(dataTrackerModel.time),
                                     dataTrackerModel.params ?: @""]
                           handler:nil];
}

+ (void)deleteDataTrackerModels:(NSArray<CXDataTrackerModel *> *)dataTrackerModels{
    if(!dataTrackerModels || dataTrackerModels.count == 0){
        return;
    }
    
    __block NSInteger maxDbId = 0;
    [dataTrackerModels enumerateObjectsUsingBlock:^(CXDataTrackerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.dbId > maxDbId){
            maxDbId = obj.dbId;
        }
    }];
    
    NSString *sql = @"DELETE FROM T_TRACKER_DATA WHERE ID <= ?;";
    [CXDatabaseUtils executeUpdate:sql arguments:@[@(maxDbId)] handler:nil];
}

@end
