//
//  CXDataUploader.h
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import <Foundation/Foundation.h>

@interface CXDataUploader : NSObject

+ (instancetype)sharedUploader;

- (void)startTimeUploader;
- (void)stopTimeUploader;

- (void)record:(NSString *)_id params:(NSDictionary<NSString *, id> *)params;

- (void)flushUpload;

@end
