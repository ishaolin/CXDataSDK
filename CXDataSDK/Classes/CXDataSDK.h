//
//  CXDataSDK.h
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataSDKDefines.h"

@interface CXDataSDK : NSObject

@property (class, nonatomic) CXDataSDKMode mode; // 默认：CXDataSDKModeUploadDataCache

+ (void)registerAppKey:(NSString *)appKey
               channel:(NSString *)channel
                apiURL:(NSString *)apiURL // 接口的url
         locationBlock:(CXDataSDKLocationDataBlock)locationBlock
       customDataBlock:(CXDataSDKCustomDataBlock)customDataBlock // 放在上报服务器的通用参数中
        extraDataBlock:(CXDataSDKExtraDataBlock)extraDataBlock; // 会放到每一个event的参数中

+ (void)setDisableBlock:(CXDataSDKEventDisableBlock)disableBlock;
+ (void)setRecordBlock:(CXDataSDKEventRecordBlock)recordBlock;

+ (void)record:(NSString *)eventId;

+ (void)record:(NSString *)eventId params:(NSDictionary<NSString *, id> *)params;

+ (NSDictionary<NSString *, id> *)h5CommonParams;

+ (void)flushUpload;

@end
