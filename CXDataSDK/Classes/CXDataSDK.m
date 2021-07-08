//
//  CXDataSDK.m
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataSDK.h"
#import "CXDataTrackerUtils.h"
#import "CXDataSDKManager.h"
#import "CXDataUploader.h"
#import "CXDataParams.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXDataSDK

+ (void)registerAppKey:(NSString *)appKey
               channel:(NSString *)channel
                apiURL:(NSString *)apiURL
         locationBlock:(CXDataSDKLocationDataBlock)locationBlock
       customDataBlock:(CXDataSDKCustomDataBlock)customDataBlock
        extraDataBlock:(CXDataSDKExtraDataBlock)extraDataBlock{
    [CXDataTrackerUtils createTable];
    
    [[CXDataSDKManager sharedManager] registerAppKey:appKey
                                             channel:channel
                                              apiURL:apiURL
                                       locationBlock:locationBlock
                                     customDataBlock:customDataBlock
                                      extraDataBlock:extraDataBlock];
}

+ (void)setDisableBlock:(CXDataSDKEventDisableBlock)disableBlock{
    [[CXDataSDKManager sharedManager] setDisableBlock:disableBlock];
}

+ (void)setRecordBlock:(CXDataSDKEventRecordBlock)recordBlock{
    [[CXDataSDKManager sharedManager] setRecordBlock:recordBlock];
}

+ (void)setMode:(CXDataSDKMode)mode{
    [CXDataSDKManager sharedManager].mode = mode;
    
    if(mode == CXDataSDKModeUploadDataCache){
        [[CXDataUploader sharedUploader] startTimeUploader];
    }else{
        [[CXDataUploader sharedUploader] stopTimeUploader];
    }
}

+ (CXDataSDKMode)mode{
    return [CXDataSDKManager sharedManager].mode;
}

+ (void)record:(NSString *)eventId{
    [self record:eventId params:nil];
}

+ (void)record:(NSString *)eventId params:(NSDictionary<NSString *, id> *)params{
    if(!eventId){
        return;
    }
    
    if(![CXDataSDKManager sharedManager].registered){
        LOG_FATEL(@"CXDataSDK app key unregistered.");
        return;
    }
    
    if([[CXDataSDKManager sharedManager] disableEvent:eventId]){
        return;
    }
    
    NSDictionary<NSString *, id> *merged = nil;
    NSDictionary<NSString *, id> *extraData = [[CXDataSDKManager sharedManager] extraData];
    if(params){
        NSMutableDictionary<NSString *, id> *data = [NSMutableDictionary dictionary];
        [data addEntriesFromDictionary:params];
        if(extraData){
            [data addEntriesFromDictionary:extraData];
        }
        merged = [data copy];
    }else{
        merged = extraData;
    }
    
    [CXDispatchHandler asyncOnMainQueue:^{
        [[CXDataUploader sharedUploader] record:eventId params:merged];
    }];
}

+ (NSDictionary<NSString *, id> *)h5CommonParams{
    return [CXDataParams h5CommonParams];
}

+ (void)flushUpload{
    [CXDispatchHandler asyncOnMainQueue:^{
        [[CXDataUploader sharedUploader] flushUpload];
    }];
}

@end
