//
//  CXDataSDKManager.m
//  Pods
//
//  Created by wshaolin on 2018/5/18.
//

#import "CXDataSDKManager.h"

@interface CXDataSDKManager () {
    
}

@property (nonatomic, copy) CXDataSDKLocationDataBlock locationBlock;
@property (nonatomic, copy) CXDataSDKCustomDataBlock customDataBlock;
@property (nonatomic, copy) CXDataSDKExtraDataBlock extraDataBlock;
@property (nonatomic, copy) CXDataSDKEventDisableBlock disableBlock;
@property (nonatomic, copy) CXDataSDKEventRecordBlock recordBlock;

@end

@implementation CXDataSDKManager

+ (instancetype)sharedManager{
    static CXDataSDKManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init{
    if(self = [super init]){
        _mode = CXDataSDKModeUploadDataCache;
    }
    
    return self;
}

- (void)registerAppKey:(NSString *)appKey
               channel:(NSString *)channel
                apiURL:(NSString *)apiURL
         locationBlock:(CXDataSDKLocationDataBlock)locationBlock
       customDataBlock:(CXDataSDKCustomDataBlock)customDataBlock
        extraDataBlock:(CXDataSDKExtraDataBlock)extraDataBlock{
    _registered = YES;
    _appKey = appKey;
    _channel = channel;
    _apiURL = apiURL;
    
    self.locationBlock = locationBlock;
    self.customDataBlock = customDataBlock;
    self.extraDataBlock = extraDataBlock;
}

- (void)setDisableBlock:(CXDataSDKEventDisableBlock)disableBlock{
    self.disableBlock = disableBlock;
}

- (void)setRecordBlock:(CXDataSDKEventRecordBlock)recordBlock{
    self.recordBlock = recordBlock;
}

- (CLLocation *)location{
    if(self.locationBlock){
        return self.locationBlock();
    }
    
    return nil;
}

- (NSDictionary<NSString *, id> *)customData{
    if(self.customDataBlock){
        return self.customDataBlock();
    }
    
    return nil;
}

- (NSDictionary<NSString *,id> *)extraData{
    if(self.extraDataBlock){
        return self.extraDataBlock();
    }
    
    return nil;
}

- (BOOL)disableEvent:(NSString *)eventId{
    if(self.disableBlock){
        return self.disableBlock(eventId);
    }
    
    return NO;
}

- (void)didRecordEvent:(NSString *)eventId params:(NSDictionary<NSString *,id> *)params{
    if(self.recordBlock){
        self.recordBlock(eventId, params);
    }
}

@end
