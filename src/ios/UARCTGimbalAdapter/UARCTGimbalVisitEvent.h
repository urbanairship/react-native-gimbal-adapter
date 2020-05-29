#import <Foundation/Foundation.h>
#import "UARCTGimbalEventEmitter.h"
#import <Gimbal/Gimbal.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Gimbal visit events.
 */
@interface UARCTGimbalVisitEvent : NSObject<UARCTGimbalEvent>

/**
 * Creates an enter visit event.
 * @param visit The visit.
 * @return A react-native event.
 */
+ (instancetype)enterEventWithVisit:(GMBLVisit *)visit;

/**
 * Creates an exit visit event.
 * @param visit The visit.
 * @return A react-native event.
 */
+ (instancetype)exitEventWithVisit:(GMBLVisit *)visit;

@end

NS_ASSUME_NONNULL_END
