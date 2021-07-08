//
//  CXDataTrackerModel.h
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import <Foundation/Foundation.h>

@interface CXDataTrackerModel : NSObject

@property (nonatomic, assign) NSInteger dbId;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *params; // json string

- (NSDictionary<NSString *, id> *)toDictionary;

@end
