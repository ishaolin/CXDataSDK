//
//  CXDataTrackerUtils.h
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataTrackerModel.h"

@interface CXDataTrackerUtils : NSObject

+ (void)createTable;

// 旧的30条数据
+ (NSArray<CXDataTrackerModel *> *)old30DataTrackerModels;

+ (NSInteger)allDataTrackerModelCount;

+ (void)addDataTrackerModel:(CXDataTrackerModel *)dataTrackerModel;

+ (void)deleteDataTrackerModels:(NSArray<CXDataTrackerModel *> *)dataTrackerModels;

@end
