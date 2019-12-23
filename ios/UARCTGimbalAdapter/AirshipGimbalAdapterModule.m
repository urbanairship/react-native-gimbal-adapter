/* Copyright Airship and Contributors */

#import "AirshipGimbalAdapterModule.h"
#import "UAGimbalAdapter.h"

@interface AirshipGimbalAdapterModule()
@property (nonatomic, weak) RCTBridge *bridge;
@end

@implementation AirshipGimbalAdapterModule

#pragma mark -
#pragma mark Module setup

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}


#pragma mark -
#pragma mark Module methods

RCT_REMAP_METHOD(start,
                 apiKey:(NSString *)apiKey
                 start_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {

    [[UAGimbalAdapter shared] startWithGimbalAPIKey:apiKey];
    // TODO resolve reject based on the prompt
    resolve(@(YES));
}


RCT_EXPORT_METHOD(stop) {
    [[UAGimbalAdapter shared] stop];
}

RCT_REMAP_METHOD(isStarted,
                 isStarted_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(@([UAGimbalAdapter shared].isStarted));
}

@end
