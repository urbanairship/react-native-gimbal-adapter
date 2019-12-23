/* Copyright Urban Airship and Contributors */

package com.urbanairship.reactnative.gimbal;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.urbanairship.gimbal.GimbalAdapter;


/**
 * React module for Urban Airship Gimbal Bridge.
 */
public class AirshipGimbalAdapterModule extends ReactContextBaseJavaModule {

    /**
     * Default constructor.
     *
     * @param reactContext The react context.
     */
    public UrbanAirshipReactGimbalBridge(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public void initialize() {
        super.initialize();
    }

    @Override
    public String getName() {
        return "AirshipGimbalAdapterModule";
    }

    @ReactMethod
    public void isStarted(Promise promise) {
        promise.resolve(GimbalAdapter.shared(getReactApplicationContext()).isStarted());
    }

    @ReactMethod
    public void start(String apiKey, final Promise promise) {
        GimbalAdapter.shared(getReactApplicationContext()).startWithPermissionPrompt(apiKey, new GimbalAdapter.PermissionResultCallback() {
            @Override
            public void onResult(boolean started) {
                promise.resolve(started);
            }
        });
    }

    @ReactMethod
    public void stop() {
        GimbalAdapter.shared(getReactApplicationContext()).stop();
    }
}
