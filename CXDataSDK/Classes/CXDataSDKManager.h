//
//  CXDataSDKManager.h
//  Pods
//
//  Created by wshaolin on 2018/5/18.
//

#import "CXDataSDKDefines.h"

@interface CXDataSDKManager : NSObject

@property (nonatomic, copy, readonly) NSString *appKey;
@property (nonatomic, copy, readonly) NSString *channel;
@property (nonatomic, copy, readonly) NSString *apiURL;
@property (nonatomic, assign, readonly) BOOL registered;

@property (nonatomic, assign) CXDataSDKMode mode;

+ (instancetype)sharedManager;

- (void)registerAppKey:(NSString *)appKey
               channel:(NSString *)channel
                apiURL:(NSString *)apiURL
         locationBlock:(CXDataSDKLocationDataBlock)locationBlock
       customDataBlock:(CXDataSDKCustomDataBlock)customDataBlock
        extraDataBlock:(CXDataSDKExtraDataBlock)extraDataBlock;

- (void)setDisableBlock:(CXDataSDKEventDisableBlock)disableBlock;
- (void)setRecordBlock:(CXDataSDKEventRecordBlock)recordBlock;

- (CLLocation *)location;
- (NSDictionary<NSString *, id> *)customData;
- (NSDictionary<NSString *, id> *)extraData;
- (BOOL)disableEvent:(NSString *)eventId;
- (void)didRecordEvent:(NSString *)eventId params:(NSDictionary<NSString *, id> *)params;

@end
