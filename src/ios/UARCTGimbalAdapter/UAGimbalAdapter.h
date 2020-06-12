/* Copyright 2017 Urban Airship and Contributors */

#import <Foundation/Foundation.h>
#import <Gimbal/Gimbal.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * GimbalAdapter interfaces Gimbal SDK functionality with Urban Airship services.
 */
@interface UAGimbalAdapter : NSObject

/**
 * Returns true if the adapter is started, otherwise false.
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;

/**
 * Enables alert when Bluetooth is powered off. Defaults to NO.
 */
@property (nonatomic, assign, getter=isBluetoothPoweredOffAlertEnabled) BOOL bluetoothPoweredOffAlertEnabled;

/**
 * Receives forwarded callbacks from the GMBLPlaceManagerDelegate
 */
@property (nonatomic, weak) id<GMBLPlaceManagerDelegate> delegate;

@property (nonatomic, copy, nullable) NSString *gimbalApiKey;

/**
 * Returns the shared `GimbalAdapter` instance.
 *
 * @return The shared `GimbalAdapter` instance.
 */
+ (instancetype)shared;

/**
 * Starts the adapter.
 */
- (void)start;

/**
 * Stops the adapter.
 */
- (void)stop;


@end

NS_ASSUME_NONNULL_END
