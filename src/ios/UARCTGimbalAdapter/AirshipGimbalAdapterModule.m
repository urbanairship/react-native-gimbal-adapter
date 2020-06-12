/* Copyright Airship and Contributors */

#import "AirshipGimbalAdapterModule.h"
#import "UAGimbalAdapter.h"
#import "UARCTGimbalEventEmitter.h"
#import "UARCTGimbalVisitEvent.h"
#import <Gimbal/Gimbal.h>

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

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

#pragma mark -
#pragma mark Module methods

RCT_EXPORT_METHOD(addListener:(NSString *)eventName) {
    [[UARCTGimbalEventEmitter shared] addListener:eventName];
}

RCT_EXPORT_METHOD(removeListeners:(NSInteger)count) {
    [[UARCTGimbalEventEmitter shared] removeListeners:count];
}

RCT_EXPORT_METHOD(setGimbalApiKey:(NSString *)gimbalApiKey) {
    [Gimbal setAPIKey:gimbalApiKey options:nil];
}

RCT_REMAP_METHOD(start,
                 start_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {

    [[UAGimbalAdapter shared] start];
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

RCT_REMAP_METHOD(getGdprConsentRequirement,
                 getGdprConsentRequirement_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    GDPRConsentRequirement requirement = [GMBLPrivacyManager gdprConsentRequirement];
    resolve([self convertConsentRequirement:requirement]);
}

RCT_REMAP_METHOD(getUserConsent,
                 getUserConsent_type:(NSString *)type
                 getUserConsent_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    GMBLConsentState state = [GMBLPrivacyManager userConsentFor:[self convertConsentTypeString:type]];

    resolve([self convertConsentState:state]);
}

RCT_EXPORT_METHOD(setUserConsent:(NSString *)type state:(NSString *)state) {
    [GMBLPrivacyManager setUserConsentFor:[self convertConsentTypeString:type]
                                  toState:[self convertConsentStateString:state]];
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

#pragma mark -
#pragma mark Converters


- (GMBLConsentType)convertConsentTypeString:(NSString *)consentType {
    if ([consentType isEqualToString:@"places"]) {
        return GMBLPlacesConsent;
    }
    return 0;
}

- (GMBLConsentState)convertConsentStateString:(NSString *)consentState {
    if ([consentState isEqualToString:@"granted"]) {
        return GMBLConsentGranted;
    } else if ([consentState isEqualToString:@"refused"]) {
        return GMBLConsentRefused;
    } else {
        return GMBLConsentUnknown;
    }
}

- (NSString *)convertConsentState:(GMBLConsentState)consentState {
    switch (consentState) {
        case GMBLConsentGranted:
            return @"granted";
        case GMBLConsentRefused:
            return @"refused";
        case GMBLConsentUnknown:
            return @"unknown";
        default:
            return nil;

    }
}

- (NSString *)convertConsentRequirement:(GDPRConsentRequirement)consentRequirement {
    switch (consentRequirement) {
        case GMBLGDPRConsentRequired:
            return @"required";
        case GMBLGDPRConsentNotRequired:
            return @"notRequired";
        case GMBLGDPRConsentRequirementUnknown:
            return @"unknown";
        default:
            return nil;
    }
}

@end
