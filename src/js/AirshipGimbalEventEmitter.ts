import {
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
  Platform,
} from "react-native";

const { AirshipGimbalAdapterModule } = NativeModules;

/**
 * @ignore
 */
export default class AirshipGimbalEventEmitter extends NativeEventEmitter {
  constructor() {
    super(AirshipGimbalAdapterModule);
  }

  addListener(
    eventType: string,
    listener: Function,
    context?: Object
  ): EmitterSubscription {
    if (Platform.OS === "android") {
      AirshipGimbalAdapterModule.addAndroidListener(eventType);
    }
    // @ts-ignore
    return super.addListener(eventType, listener, context);
  }

  removeAllListeners(eventType: string) {
    if (Platform.OS === "android") {
      // @ts-ignore
      const count = this.listeners(eventType).length;
      AirshipGimbalAdapterModule.removeAndroidListeners(count);
    }

    super.removeAllListeners(eventType);
  }

  removeSubscription(subscription: EmitterSubscription) {
    if (Platform.OS === "android") {
      AirshipGimbalAdapterModule.removeAndroidListeners(1);
    }
    super.removeSubscription(subscription);
  }
}
