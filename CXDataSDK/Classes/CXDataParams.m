//
//  CXDataParams.m
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataParams.h"
#import "CXDataSDKManager.h"
#import <CXNetSDK/CXNetSDK.h>
#import <CXUIKit/CXUIKit.h>
#import <AdSupport/AdSupport.h>

@implementation CXDataParams

+ (NSMutableDictionary<NSString *, id> *)commonParamsWithSource:(NSString *)source
                                                     SDKVersion:(NSString *)SDKVersion{
    NSMutableDictionary<NSString *, id> *commonParams = [NSMutableDictionary dictionary];
    [commonParams cx_setObject:[CXDataSDKManager sharedManager].appKey forKey:@"app_key"];
    [commonParams cx_setObject:[CXDataSDKManager sharedManager].channel forKey:@"channel_id"];
    
    CLLocation *location = [[CXDataSDKManager sharedManager] location];
    if(location){
        [commonParams cx_setObject:@(location.coordinate.latitude) forKey:@"lat"];
        [commonParams cx_setObject:@(location.coordinate.longitude) forKey:@"lng"];
    }
    
    NSDictionary<NSString *, id> *customData = [[CXDataSDKManager sharedManager] customData];
    if(customData){
        [commonParams addEntriesFromDictionary:customData];
    }
    
    [commonParams cx_setObject:[CXNetworkReachabilityManager networkReachabilityStatusString] forKey:@"net_type"];
    [commonParams cx_setObject:[AFNetworkReachabilityManager sharedManager].carrier forKey:@"carrier"];
    [commonParams cx_setObject:[UIDevice currentDevice].cx_hardwareString forKey:@"model"];
    [commonParams cx_setObject:[UIDevice currentDevice].systemName forKey:@"os"];
    [commonParams cx_setObject:[UIDevice currentDevice].systemVersion forKey:@"system_version"];
    [commonParams cx_setObject:[UIDevice currentDevice].cx_identifier forKey:@"imei"];
    [commonParams cx_setObject:[UIDevice currentDevice].cx_platform forKey:@"platform"];
    [commonParams cx_setObject:[UIDevice currentDevice].cx_jailbreak forKey:@"jail_break"];
    [commonParams cx_setObject:[UIDevice currentDevice].cx_resolution forKey:@"scale"];
    
    [commonParams cx_setObject:[NSBundle mainBundle].cx_buildVersion forKey:@"build_code"];
    [commonParams cx_setObject:[NSBundle mainBundle].cx_appVersion forKey:@"app_version"];
    [commonParams cx_setObject:[NSBundle mainBundle].cx_appId forKey:@"package_name"];
    [commonParams cx_setObject:@([NSDate cx_timeStampForMillisecond]) forKey:@"upload_time"];
    
    NSString *idfa = @"";
    if([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled){
        idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    }
    [commonParams cx_setObject:idfa forKey:@"idfa"];
    [commonParams cx_setObject:source forKey:@"data_sources"];
    [commonParams cx_setObject:SDKVersion forKey:@"sdk_version"];
    
    return commonParams;
}

+ (NSMutableDictionary<NSString *, id> *)commonParams{
    return [self commonParamsWithSource:@"native" SDKVersion:CXDataSDKVersion];
}

+ (NSDictionary<NSString *, id> *)h5CommonParams{
    return [[self commonParamsWithSource:@"H5" SDKVersion:nil] copy];
}

@end
