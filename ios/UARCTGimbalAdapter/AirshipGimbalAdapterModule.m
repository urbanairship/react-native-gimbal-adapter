/* Copyright Airship and Contributors */

#import "AirshipGimbalAdapterModule.h"
#import "UAGimbalAdapter.h"
#import "UARCTGimbalEventEmitter.h"
#import "UARCTGimbalVisitEvent.h"

@interface AirshipGimbalAdapterModule() <GMBLPlaceManagerDelegate>

@end

@implementation AirshipGimbalAdapterModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UAGimbalAdapter shared].delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark Module setup

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)setBridge:(RCTBridge *)bridge {
    [UARCTGimbalEventEmitter shared].bridge = bridge;
}

- (RCTBridge *)bridge {
    return [UARCTGimbalEventEmitter shared].bridge;
}


#pragma mark -
#pragma mark Module methods

RCT_EXPORT_METHOD(addListener:(NSString *)eventName) {
    [[UARCTGimbalEventEmitter shared] addListener:eventName];
}

RCT_EXPORT_METHOD(removeListeners:(NSInteger)count) {
    [[UARCTGimbalEventEmitter shared] removeListeners:count];
}

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


#pragma mark -
#pragma mark GMBLPlaceManagerDelegate

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit {
    UARCTGimbalVisitEvent *event = [UARCTGimbalVisitEvent enterEventWithVisit:visit];
    [[UARCTGimbalEventEmitter shared] sendEvent:event];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    UARCTGimbalVisitEvent *event = [UARCTGimbalVisitEvent exitEventWithVisit:visit];
    [[UARCTGimbalEventEmitter shared] sendEvent:event];
}


@end
