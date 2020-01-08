/* Copyright 2017 Urban Airship and Contributors */

#import "UAGimbalAdapter.h"

#import <Gimbal/Gimbal.h>

#if __has_include("AirshipLib.h")
#import "AirshipLib.h"
#else
@import AirshipKit;
#endif


@interface UAGimbalAdapter() <GMBLPlaceManagerDelegate>
@property (nonatomic, strong) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLDeviceAttributesManager * deviceAttributesManager;
@end

NSString *const GimbalSource = @"Gimbal";

// NSUserDefault Keys
NSString *const GimbalAlertViewKey = @"gmbl_hide_bt_power_alert_view";
NSString *const GimbalAdapterStarted = @"com.urbanairship.gimbal.started";

NSString * const UAAirshipReadyNotification = @"com.urbanairship.airship_ready";

@implementation UAGimbalAdapter

static id _sharedObject = nil;

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:[UAGimbalAdapter class]
                                             selector:@selector(handleAirshipReady)
                                                 name:UAAirshipReadyNotification
                                               object:nil];
}

+ (void)handleAirshipReady {
    [[NSNotificationCenter defaultCenter] removeObserver:[UAGimbalAdapter class]
                                                    name:UAAirshipReadyNotification
                                                  object:nil];

    [[UAGimbalAdapter shared] updateDeviceAttributes];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.placeManager = [[GMBLPlaceManager alloc] init];
        self.placeManager.delegate = self;
        self.deviceAttributesManager = [[GMBLDeviceAttributesManager alloc] init];

        // Hide the power alert by default
        if (![[NSUserDefaults standardUserDefaults] valueForKey:GimbalAlertViewKey]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GimbalAlertViewKey];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateDeviceAttributes)
                                                     name:UAChannelCreatedEvent
                                                   object:nil];
    }

    return self;
}

- (void)dealloc {
    self.placeManager.delegate = nil;
}

- (BOOL)isBluetoothPoweredOffAlertEnabled {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:GimbalAlertViewKey];
}

- (void)setBluetoothPoweredOffAlertEnabled:(BOOL)bluetoothPoweredOffAlertEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:!bluetoothPoweredOffAlertEnabled
                                            forKey:GimbalAlertViewKey];
}

- (void)startWithGimbalAPIKey:(NSString *)gimbalAPIKey {
    [Gimbal setAPIKey:gimbalAPIKey options:nil];
    [Gimbal start];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GimbalAdapterStarted];

    [self updateDeviceAttributes];
    UA_LDEBUG(@"Started Gimbal Adapter. Gimbal application instance identifier: %@", [Gimbal applicationInstanceIdentifier]);
}

- (void)updateDeviceAttributes {
    NSMutableDictionary *deviceAttributes = [NSMutableDictionary dictionary];

    if ([self.deviceAttributesManager getDeviceAttributes].count) {
        [deviceAttributes addEntriesFromDictionary:[self.deviceAttributesManager getDeviceAttributes]];
    }

    [deviceAttributes setValue:[UAirship namedUser].identifier forKey:@"ua.nameduser.id"];
    [deviceAttributes setValue:[UAirship channel].identifier forKey:@"ua.channel.id"];

    if (deviceAttributes.count) {
        [self.deviceAttributesManager setDeviceAttributes:deviceAttributes];
        UA_LDEBUG(@"Set Gimbal Device Attributes: %@", [deviceAttributes description]);
    }

    UAAssociatedIdentifiers *identifiers = [[UAirship shared].analytics currentAssociatedDeviceIdentifiers];
    [identifiers setIdentifier:[Gimbal applicationInstanceIdentifier] forKey:@"com.urbanairship.gimbal.aii"];
    [[UAirship shared].analytics associateDeviceIdentifiers:identifiers];
}

- (void)stop {
    [Gimbal stop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GimbalAdapterStarted];
    UA_LDEBUG(@"Stopped Gimbal Adapter.");
}

- (BOOL)isStarted {
    return [[NSUserDefaults standardUserDefaults] boolForKey:GimbalAdapterStarted] && [Gimbal isStarted];
}

#pragma mark Gimbal place callbacks

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit {
    UA_LDEBUG(@"Entered a Gimbal Place: %@ on the following date: %@", visit.place.name, visit.arrivalDate);
    UARegionEvent *regionEvent = [UARegionEvent regionEventWithRegionID:visit.place.identifier
                                                                 source:GimbalSource
                                                          boundaryEvent:UABoundaryEventEnter];

    [[UAirship shared].analytics addEvent:regionEvent];

    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didBeginVisit:)]) {
        [strongDelegate placeManager:manager didBeginVisit:visit];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    if (!self.isStarted) {
        return;
    }

    UA_LDEBUG(@"Exited a Gimbal Place: %@ Entrance date:%@ Exit Date:%@", visit.place.name, visit.arrivalDate, visit.departureDate);
    UARegionEvent *regionEvent = [UARegionEvent regionEventWithRegionID:visit.place.identifier
                                                                 source:GimbalSource
                                                          boundaryEvent:UABoundaryEventExit];
    [[UAirship shared].analytics addEvent:regionEvent];

    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didEndVisit:)]) {
        [strongDelegate placeManager:manager didEndVisit:visit];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit withDelay:(NSTimeInterval)delayTime {
    if (!self.isStarted) {
        return;
    }

    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didBeginVisit:withDelay:)]) {
        [strongDelegate placeManager:manager didBeginVisit:visit withDelay:delayTime];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting forVisits:(NSArray *)visits {
    if (!self.isStarted) {
        return;
    }
    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didReceiveBeaconSighting:forVisits:)]) {
        [strongDelegate placeManager:manager didReceiveBeaconSighting:sighting forVisits:visits];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didDetectLocation:(CLLocation *)location {
    if (!self.isStarted) {
        return;
    }
    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didDetectLocation:)]) {
        [strongDelegate placeManager:manager didDetectLocation:location];
    }
}

@end
