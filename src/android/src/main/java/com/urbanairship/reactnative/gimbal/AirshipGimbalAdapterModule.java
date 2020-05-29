/* Copyright Urban Airship and Contributors */

package com.urbanairship.reactnative.gimbal;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.gimbal.android.Visit;
import com.urbanairship.analytics.location.RegionEvent;
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
    public AirshipGimbalAdapterModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public void initialize() {
        super.initialize();
        EventEmitter.shared().attachReactContext(getReactApplicationContext());

        GimbalAdapter.shared(getReactApplicationContext()).addListener(new GimbalAdapter.Listener() {
            @Override
            public void onRegionEntered(@NonNull RegionEvent regionEvent, @NonNull Visit visit) {
                EventEmitter.shared().sendEvent(VisitEvent.enterEvent(visit));
            }

            @Override
            public void onRegionExited(@NonNull RegionEvent regionEvent, @NonNull Visit visit) {
                EventEmitter.shared().sendEvent(VisitEvent.exitEvent(visit));
            }
        });
    }

    /**
     * Called when a new listener is added for a specified event name.
     *
     * @param eventName The event name.
     */
    @ReactMethod
    public void addAndroidListener(String eventName) {
        EventEmitter.shared().addAndroidListener(eventName);
    }

    /**
     * Called when listeners are removed.
     *
     * @param count The count of listeners.
     */
    @ReactMethod
    public void removeAndroidListeners(int count) {
        EventEmitter.shared().removeAndroidListeners(count);
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
