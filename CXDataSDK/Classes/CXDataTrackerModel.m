//
//  CXDataTrackerModel.m
//  Pods
//
//  Created by wshaolin on 2018/5/17.
//

#import "CXDataTrackerModel.h"

@implementation CXDataTrackerModel

- (NSDictionary<NSString *, id> *)toDictionary{
    return @{@"id" : _eventId,
             @"time" : @(_time),
             @"params" : _params ?: @""};
}

@end
