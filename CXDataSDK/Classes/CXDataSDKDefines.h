//
//  CXDataSDKDefines.h
//  Pods
//
//  Created by wshaolin on 2018/5/18.
//

#ifndef CXDataSDKDefines_h
#define CXDataSDKDefines_h

#import <CoreLocation/CoreLocation.h>

typedef CLLocation *(^CXDataSDKLocationDataBlock)(void);
typedef NSDictionary<NSString *, id> *(^CXDataSDKCustomDataBlock)(void);
typedef NSDictionary<NSString *, id> *(^CXDataSDKExtraDataBlock)(void);
typedef BOOL(^CXDataSDKEventDisableBlock)(NSString *eventId);
typedef BOOL(^CXDataSDKEventRecordBlock)(NSString *eventId, NSDictionary<NSString *, id> * params);

typedef NS_ENUM(NSInteger, CXDataSDKMode) {
    CXDataSDKModeDebug, // debug
    CXDataSDKModeUploadDataRealTime, // 数据实时上报
    CXDataSDKModeUploadDataCache // 累计数据达20条上报一次或者间隔上一次上报时间大于1分钟
};

#define CXDataSDKVersion_1_0    @"1.0"
#define CXDataSDKVersion        CXDataSDKVersion_1_0

#endif /* CXDataSDKDefines_h */
