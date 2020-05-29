package com.urbanairship.reactnative.gimbal;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.gimbal.android.Visit;
import com.urbanairship.util.DateUtils;

public class VisitEvent implements Event {
    private static final String EXIT_EVENT_NAME = "com.urbanairship.gimbal.region_exit";
    private static final String ENTER_EVENT_NAME = "com.urbanairship.gimbal.region_enter";

    private static final String PLACE_IDENTIFIER_KEY = "identifier";
    private static final String PLACE_NAME_KEY = "name";
    private static final String PLACE_ATTRIBUTES_KEY = "attributes";

    private static final String VISIT_ARRIVAL_TIME_KEY = "arrivalTime";
    private static final String VISIT_DEPARTURE_TIME_KEY = "departureTime";
    private static final String VISIT_DWELL_TIME_KEY = "dwellTime";
    private static final String VISIT_PLACE_KEY = "place";
    private static final String VISIT_IDENTIFIER_KEY = "identifier";

    private final Visit visit;
    private final String eventName;

    private VisitEvent(@NonNull Visit visit, @NonNull String eventName) {
        this.visit = visit;
        this.eventName = eventName;
    }


    public static VisitEvent enterEvent(@NonNull Visit visit) {
        return new VisitEvent(visit, ENTER_EVENT_NAME);
    }

    public static VisitEvent exitEvent(@NonNull Visit visit) {
        return new VisitEvent(visit, EXIT_EVENT_NAME);
    }

    @NonNull
    @Override
    public String getName() {
        return eventName;
    }

    @NonNull
    @Override
    public WritableMap getBody() {
        WritableMap visitMap = Arguments.createMap();

        if (visit.getArrivalTimeInMillis() > 0) {
            visitMap.putString(VISIT_ARRIVAL_TIME_KEY, DateUtils.createIso8601TimeStamp(visit.getArrivalTimeInMillis()));
        }

        if (visit.getDepartureTimeInMillis() > 0) {
            visitMap.putString(VISIT_DEPARTURE_TIME_KEY, DateUtils.createIso8601TimeStamp(visit.getDepartureTimeInMillis()));
        }

        visitMap.putDouble(VISIT_DWELL_TIME_KEY, visit.getDwellTimeInMillis() / 1000.0);
        visitMap.putString(VISIT_IDENTIFIER_KEY, visit.getVisitID());

        if (visit.getPlace() != null) {
            WritableMap placeMap = Arguments.createMap();
            placeMap.putString(PLACE_IDENTIFIER_KEY, visit.getPlace().getIdentifier());
            placeMap.putString(PLACE_NAME_KEY, visit.getPlace().getName());


            if (visit.getPlace().getAttributes() != null) {
                WritableMap attributesMap = Arguments.createMap();
                for (String key : visit.getPlace().getAttributes().getAllKeys()) {
                    attributesMap.putString(key, visit.getPlace().getAttributes().getValue(key));
                }

                placeMap.putMap(PLACE_ATTRIBUTES_KEY, attributesMap);
            }

            visitMap.putMap(VISIT_PLACE_KEY, placeMap);
        }

        return visitMap;
    }
}
