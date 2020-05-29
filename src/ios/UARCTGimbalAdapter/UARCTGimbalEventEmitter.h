/* Copyright Urban Airship and Contributors */

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

@protocol UARCTGimbalEvent <NSObject>
@property (nonatomic, readonly) NSString *eventName;
@property (nonatomic, readonly) id eventBody;
@end


/**
 * Listeners for Urban Airship events and emits them to the JS layer.
 */
@interface UARCTGimbalEventEmitter : NSObject

/**
 * The RCTBridge. Assigned by `UrbanAirshipReactModule`.
 */
@property (nonatomic, weak) RCTBridge *bridge;

/**
 * Returns the shared instance.
 * @returns the shared event emitter instance.
 */
+ (instancetype)shared;

/**
 * Adds an event listener.
 * @param eventName The event name.
 */
- (void)addListener:(NSString *)eventName;

/**
 * Removes event listeners.
 * @param count The count of event listeners being removed.
 */
- (void)removeListeners:(NSInteger)count;

/**
 * Sends an event.
 * @param event The event.
 */
- (void)sendEvent:(id<UARCTGimbalEvent>)event;

@end
