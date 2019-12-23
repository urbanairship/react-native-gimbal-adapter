# Urban Airship React Native

A React Native module for the Urban Airship Gimbal Adapter.

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

```
import {
  AirshipGimbalAdapter,
  UACustomEvent,
} from 'urbanairship-gimbal-adapter-react-native'

...

export default class Sample extends Component {

  constructor(props) {
    super(props);
    AirshipGimbalAdapter.start(GIMBAL_API_KEY);
  }

  ...
}
```

