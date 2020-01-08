// @flow
'use strict';

import {
  NativeModules,
  NativeEventEmitter,
  Platform
} from 'react-native';

const AirshipGimbalAdapterModule = NativeModules.AirshipGimbalAdapterModule;

class AirshipGimbalEventEmitter extends NativeEventEmitter {

  constructor() {
    super(AirshipGimbalAdapterModule);
  }

  addListener(eventType: string, listener: Function, context: ?Object): EmitterSubscription {
    if (Platform.OS === 'android') {
      AirshipGimbalAdapterModule.addAndroidListener(eventType);
    }
    return super.addListener(eventType, listener, context);
  }

  removeAllListeners(eventType: string) {
    if (Platform.OS === 'android') {
      const count = this.listeners(eventType).length;
      AirshipGimbalAdapterModule.removeAndroidListeners(count);
    }

    super.removeAllListeners(eventType);
  }

  removeSubscription(subscription: EmitterSubscription) {
    if (Platform.OS === 'android') {
      AirshipGimbalAdapterModule.removeAndroidListeners(1);
    }
    super.removeSubscription(subscription);
  }
}

module.exports = AirshipGimbalAdapterModule;