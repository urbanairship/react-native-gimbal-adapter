/**
 * Sample React Native App
 * @flow
 */
'use strict';

import {
 UrbanAirship,
} from 'urbanairship-react-native'

import {
  AirshipGimbalAdapter,
  ConsentType,
  ConsentState,
  ConsentRequirement,
  RegionEventType
 } from 'urbanairship-gimbal-adapter-react-native'

import React, {
  Component,
} from 'react';

import {
  StyleSheet,
  Text,
  View,
  Image,
  Switch,
  ScrollView,
} from 'react-native';

const GIMBAL_API_KEY = "NEAT"

const styles = StyleSheet.create({
  backgroundContainer: {
    flex: 1,
    flexDirection:'column',
    backgroundColor: '#E0A500',
  },
  contentContainer: {
    paddingVertical: 20,
    alignItems: 'center',
    backgroundColor: '#E0A500',
  },
  cellContainer: {
    flex: 0,
    flexDirection:'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#E0A500',
    marginTop: 15,
    marginRight: 10,
    marginLeft: 10,
    marginBottom: 10,
  },
  text: {
    fontSize: 16,
    color: '#0d6a83',
    textAlign: 'center',
    padding: 10,
  },
  rowLabel: {
    flexDirection:'row',
    color: '#0d6a83',
    fontSize: 16,
    marginRight: 10
  },
});

export default class AirshipSample extends Component {
  constructor(props) {
    super(props);


    AirshipGimbalAdapter.setGimbalApiKey(GIMBAL_API_KEY)

    this.state = {
      channelId: "",
      isStarted: false,
    }

    this.handleStartAdapter = this.handleStartAdapter.bind(this);
    this.handlePlacesConsent = this.handlePlacesConsent.bind(this);

  }

  handleStartAdapter(enabled) {
    if (enabled) {
      AirshipGimbalAdapter.start(GIMBAL_API_KEY).then((started) => {
        this.setState({
          isStarted: started,
        });
      });
    } else {
      AirshipGimbalAdapter.stop()
      this.setState({
        isStarted: false,
      });
    }
  }

  handlePlacesConsent(enabled) {
    if (enabled) {
      AirshipGimbalAdapter.setUserConsent(ConsentType.Places, ConsentState.Granted)
    } else {
      AirshipGimbalAdapter.setUserConsent(ConsentType.Places, ConsentState.Refused)
    }

    AirshipGimbalAdapter.getUserConsent(ConsentType.Places).then ((consent) => {
      this.setState({placesConsent: consent})
    })
  }

  componentDidMount() {
    AirshipGimbalAdapter.isStarted().then ((started) => {
      this.setState({isStarted:started})
    })

    AirshipGimbalAdapter.getGdprConsentRequirement().then ((requirement) => {
      this.setState({gdprRequirement: requirement })
    })

    AirshipGimbalAdapter.getUserConsent("places").then ((consent) => {
      this.setState({placesConsent: consent})
    })

    UrbanAirship.getChannelId().then((channelId) => {
      this.setState({channelId:channelId})
    });

    UrbanAirship.addListener("registration", (event) => {
      console.log('registration:', JSON.stringify(event));
      this.state.channelId = event.channelId;
      this.setState(this.state);
    });

    AirshipGimbalAdapter.addListener(RegionEventType.Enter, (event) => {
      console.log('region enter:', JSON.stringify(event));
    });

    AirshipGimbalAdapter.addListener(RegionEventType.Exit, (event) => {
      console.log('region exit:', JSON.stringify(event));
    });

  }

  render() {

    return (
      <View style={styles.backgroundContainer}>
        <ScrollView contentContainerStyle={styles.contentContainer}>
          <Image
            style={{width: 300, height: 38, marginTop:50, alignItems:'center'}}
            source={require('./img/urban-airship-sidebyside.png')}
          />
          <View style={{height:75}}>
            </View>
              <EnableGimbalAdapter
                isStarted={this.state.isStarted}
                handleStartAdapter={this.handleStartAdapter}
              />
            <View>
            <Text style={styles.text}>
              Airship Channel ID {'\n'} {this.state.channelId}
          </Text>
          </View>

          <View style={{height:75}}>
            </View>
              <PlacesConsentAdapter
                placesConsent={this.state.placesConsent}
                handlePlacesConsent={this.handlePlacesConsent}
              />
            <View>
            <Text style={styles.text}>
              GDPR Consent Requirement {this.state.gdprRequirement}
            </Text>
            <Text style={styles.text}>
              Places Consent {this.state.placesConsent}
            </Text>
          </View>
        </ScrollView>
    </View>

    );
  }
}

class EnableGimbalAdapter extends Component {
  render() {
    return (
      <View style={styles.cellContainer}>
        <Text style={styles.rowLabel}>
          Enable Gimbal Adapter
        </Text>
        <Switch
          trackColor={{true: "#0d6a83", false: null}}
          onValueChange={(value) => this.props.handleStartAdapter(value)}
          value={this.props.isStarted}
        />
      </View>
    );
  }
}

class PlacesConsentAdapter extends Component {
  render() {
    return (
      <View style={styles.cellContainer}>
        <Text style={styles.rowLabel}>
          Consent to Gimbal Places
        </Text>
        <Switch
          trackColor={{true: "#0d6a83", false: null}}
          onValueChange={(value) => this.props.handlePlacesConsent(value)}
          value={this.props.placesConsent == ConsentState.Granted}
        />
      </View>
    );
  }
}