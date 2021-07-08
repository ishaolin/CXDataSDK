//
//  CXDataUploader.m
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataUploader.h"
#import "CXDataSDKManager.h"
#import "CXDataTrackerUtils.h"
#import <CXFoundation/CXFoundation.h>
#import "CXDataParams.h"
#import <AFNetworking/AFNetworking.h>

#define CXDataUploaderUploadDataCount 20
#define CXDataUploaderUploadDataTimeInterval 60.0

@interface CXDataUploader () {
    NSTimer *_uploadTimer;
    NSTimeInterval _timeInterval;
    
    AFHTTPSessionManager *_sessionManager;
    BOOL _uploading;
}

@end

@implementation CXDataUploader

+ (instancetype)sharedUploader{
    static CXDataUploader *_sharedUploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUploader = [[self alloc] init];
    });
    
    return _sharedUploader;
}

- (instancetype)init{
    if(self = [super init]){
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 3;
        
        if([CXDataSDKManager sharedManager].mode == CXDataSDKModeUploadDataCache){
            [self startTimeUploader];
        }
    }
    
    return self;
}

- (void)startTimeUploader{
    if(_uploadTimer){
        return;
    }
    
    _timeInterval = 0;
    _uploadTimer = [NSTimer timerWithTimeInterval:1.0
                                           target:self
                                         selector:@selector(handleUploadTimer:)
                                         userInfo:nil
                                          repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_uploadTimer forMode:NSDefaultRunLoopMode];
    [_uploadTimer fire];
}

- (void)stopTimeUploader{
    if(_uploadTimer.isValid){
        [_uploadTimer invalidate];
    }
    
    _timeInterval = 0;
    _uploadTimer = nil;
}

- (void)handleUploadTimer:(NSTimer *)uploadTimer{
    _timeInterval += 1.0;
    
    if(_timeInterval < CXDataUploaderUploadDataTimeInterval){
        return;
    }
    
    [self uploadTrackDataToServer];
}

- (void)record:(NSString *)eventId params:(NSDictionary<NSString *, id> *)params{
    CXDataTrackerModel *dataTrackerModel = [[CXDataTrackerModel alloc] init];
    dataTrackerModel.eventId = eventId;
    dataTrackerModel.time = [NSDate cx_timeStampForMillisecond];
    dataTrackerModel.params = [NSJSONSerialization cx_stringWithJSONObject:params];
    
    if(_uploading){
        [CXDataTrackerUtils addDataTrackerModel:dataTrackerModel];
    }else{
        if([CXDataSDKManager sharedManager].mode == CXDataSDKModeUploadDataCache){
            [CXDataTrackerUtils addDataTrackerModel:dataTrackerModel];
            NSInteger count = [CXDataTrackerUtils allDataTrackerModelCount];
            if(count >= CXDataUploaderUploadDataCount){
                [self uploadTrackDataToServer];
            }
        }else{
            [CXDataTrackerUtils addDataTrackerModel:dataTrackerModel];
            [self uploadTrackDataToServer];
        }
    }
    
    [[CXDataSDKManager sharedManager] didRecordEvent:eventId params:params];
}

- (void)uploadTrackDataToServer{
    _timeInterval = 0;
    
    NSArray<CXDataTrackerModel *> *dataTrackerModels = [CXDataTrackerUtils old30DataTrackerModels];
    if(dataTrackerModels.count == 0){
        return;
    }
    
    NSMutableArray<NSDictionary *> *infoList = [NSMutableArray array];
    [dataTrackerModels enumerateObjectsUsingBlock:^(CXDataTrackerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [infoList addObject:[obj toDictionary]];
    }];
    
    NSMutableDictionary<NSString *, id> *data = [CXDataParams commonParams];
    data[@"info_list"] = [infoList copy];
    
    _uploading = YES;
    [_sessionManager POST:[CXDataSDKManager sharedManager].apiURL
               parameters:data
                  headers:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary<NSString *, id> *responseData = [NSJSONSerialization cx_deserializeJSONToDictionary:responseObject];
        NSNumber *code = [responseData cx_numberForKey:@"code"];
        if(code != nil && code.integerValue == 0){
            if([CXDataSDKManager sharedManager].mode == CXDataSDKModeDebug){
                LOG_INFO(@"[data_sdk]上报数据成功：%@", data);
            }
            
            [CXDataTrackerUtils deleteDataTrackerModels:dataTrackerModels];
            if(dataTrackerModels.count > CXDataUploaderUploadDataCount){
                [self uploadTrackDataToServer];
            }
        }else{
            LOG_INFO(@"[data_sdk]上报数据失败：%@", responseData);
        }
        
        self->_uploading = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LOG_INFO(@"[data_sdk]上报数据失败：%@", error);
        self->_uploading = NO;
    }];
}

- (void)flushUpload{
    if(_uploading){
        return;
    }
    
    [self uploadTrackDataToServer];
}

@end
