// @flow
'use strict';

import {
  NativeModules
} from 'react-native';

const AirshipGimbalAdapterModule = NativeModules.AirshipGimbalAdapterModule;

/**
 * Airship Gimbal Adapter.
 */
class AirshipGimbalAdapter {
  static start(apiKey: string):  Promise<boolean> {
    return AirshipGimbalAdapterModule.start(apiKey);
  }

  static stop() {
    AirshipGimbalAdapterModule.stop();
  }

  static isStarted(): Promise<boolean> {
    return AirshipGimbalAdapterModule.isStarted();
  }
}

module.exports = AirshipGimbalAdapter;
