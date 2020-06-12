# Airship React Native development

A React Native module for the Airship Gimbal Adapter.

### Issues

Please visit https://support.urbanairship.com/ for any issues integrating or using this module.

### Requirements:
 - Xcode 11+
 - iOS: Deployment target 11.0+
 - Android: minSdkVersion 16+, compileSdkVersion 29+
 - React Native >= 0.60.0
 - React Native cli >= 2.0.1

## Install

```
# using yarn
yarn add urbanairship-gimbal-adapter-react-native

# using npm
npm install urbanairship-gimbal-adapter-react-native --save
```

## iOS Setup

1) Install pods
```
cd ios && pod install
```

2) Create a plist `AirshipConfig.plist` and include it in your application’s target:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>developmentAppKey</key>
  <string>Your Development App Key</string>
  <key>developmentAppSecret</key>
  <string>Your Development App Secret</string>
  <key>productionAppKey</key>
  <string>Your Production App Key</string>
  <key>productionAppSecret</key>
  <string>Your Production App Secret</string>
</dict>
</plist>
```

## Android Setup

1) Create the `airshipconfig.properties` file in the application's `app/src/main/assets`:
```
developmentAppKey = Your Development App Key
developmentAppSecret = Your Development App Secret

productionAppKey = Your Production App Key
productionAppSecret = Your Production Secret

# Notification customization
notificationIcon = ic_notification
notificationAccentColor = #ff0000
```

## Starting the adapter

In order to start the adapter, your app will need to call `start` with the app's Gimbal API Key:

```
import {
  AirshipGimbalAdapter,
  ConsentType,
  ConsentState,
  ConsentRequirement,
  RegionEventType
 } from 'urbanairship-gimbal-adapter-react-native'

...

AirshipGimbalAdapter.setGimbalApiKey(<YOUR_GIMBAL_API_KEY>)
AirshipGimbalAdapter.start()
```

## Listening for events

Region enter/exits will automatically generate Airship events that can trigger Automation and Journeys. You can also listen for events directly by adding a listener to the `AirshipGimbalAdapter`:

```
    AirshipGimbalAdapter.addListener(RegionEventType.Enter, (event) => {
      console.log('regionEnter:', JSON.stringify(event))
    })

    AirshipGimbalAdapter.addListener(RegionEventType.Exit, (event) => {
      console.log('regionExit:', JSON.stringify(event))
    })
```

## GDPR

The adapter exposes Gimbal's GDPR APIs:


Check if GDPR consent is required:
```
    AirshipGimbalAdapter.getGdprConsentRequirement().then ((requirement) => {
      console.log('GDPR consent required:', requirement)
    })
```

Setting consent:
```
    AirshipGimbalAdapter.setUserConsent(ConsentType.Places, ConsentState.Granted)

    AirshipGimbalAdapter.getUserConsent(ConsentType.Places, (state) => {
      console.log('places consent:', state)
    })
```
