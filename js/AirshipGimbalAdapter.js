// @flow
'use strict';

import {
  NativeModules
} from 'react-native';

import AirshipGimbalEventEmitter from './AirshipGimbalEventEmitter.js'

const AirshipGimbalAdapterModule = NativeModules.AirshipGimbalAdapterModule;
const EventEmitter = new AirshipGimbalEventEmitter();

const REGION_ENTER_EVENT = "com.urbanairship.gimbal.visit_enter";
const REGION_EXIT_EVENT = "com.urbanairship.gimbal.visit_exit";


/**
 * Fired when a user enters a region.
 *
 * @event AirshipGimbalAdapter#regionEnter
 * @type {object}
 * @param {object} identifier The visit's ID.
 * @param {number} dwellTime The dwell time in seconds.
 * @param {string} arrivalTime The arrival time as an ISO 8601 timestamp.
 * @param {string} departureTime The departure time as an ISO 8601 timestamp.
 * @param {object} place The place.
 * @param {string} place.identifier The place's ID.
 * @param {string} place.name The place's name.
 * @param {object} place.attributes The place's attributes.
 * @param {boolean} isForeground Will always be true if the user taps the main notification. Otherwise its defined by the notification action button.
 */

 /**
 * Fired when a user exits a region.
 *
 * @event AirshipGimbalAdapter#regionExit
 * @type {object}
 * @param {object} identifier The visit's ID.
 * @param {number} dwellTime The dwell time in seconds.
 * @param {string} arrivalTime The arrival time as an ISO 8601 timestamp.
 * @param {string} departureTime The departure time as an ISO 8601 timestamp.
 * @param {object} place The place.
 * @param {string} place.identifier The place's ID.
 * @param {string} place.name The place's name.
 * @param {object} place.attributes The place's attributes.
 * @param {boolean} isForeground Will always be true if the user taps the main notification. Otherwise its defined by the notification action button.
 */


/**
 * @private
 */
function convertEventEnum(type: AirshipGimbalEventName): ?string {
  if (type === 'regionEnter') {
    return REGION_ENTER_EVENT;
  } else if (type === 'regionExit') {
    return REGION_EXIT_EVENT;
  }
  throw new Error("Invalid event name: " + type);
}

export type AirshipGimbalEventName = $Enum<{
  visitEnter: string,
  visitExit: string
}>;

/**
 * Airship Gimbal Adapter.
 */
class AirshipGimbalAdapter {

  /**
   * Starts the adapter.
   * @param {string} apiKey The Gimbal API key.
   * @return {Promise.Object} A promise with the result.
   */
  static start(apiKey: string):  Promise<boolean> {
    return AirshipGimbalAdapterModule.start(apiKey);
  }

  /**
   * Stops the Gimbal Adapter.
   */
  static stop() {
    AirshipGimbalAdapterModule.stop();
  }

  /**
   * Checks if the adapter is started.
   * @return {Promise.Object} A promise with the result.
   */
  static isStarted(): Promise<boolean> {
    return AirshipGimbalAdapterModule.isStarted();
  }

  /**
   * Adds a listener for an Airship Gimbal event.
   *
   * @param {string} eventName The event name. Either regionEnter or regionExit.
   * @param {Function} listener The event listener.
   * @return {EmitterSubscription} An emitter subscription.
   */
  static addListener(eventName: AirshipGimbalEventName, listener: Function): EmitterSubscription {
    var name = convertEventEnum(eventName);
    return EventEmitter.addListener(name, listener);
  }

  /**
   * Adds a listener for an Airship Gimbal event.
   *
   * @param {string} eventName The event name. Either regionEnter or regionExit.
   * @param {Function} listener The event listener.
   */
  static removeListener(eventName: AirshipEventName, listener: Function) {
    var name = convertEventEnum(eventName);
    EventEmitter.removeListener(name, listener);
  }

}

module.exports = AirshipGimbalAdapter;
