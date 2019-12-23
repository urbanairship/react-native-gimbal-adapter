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
 } from 'urbanairship-gimbal-adapter-react-native'

import React, {
  Component,
} from 'react';

import {
  StyleSheet,
  Text,
  View,
  AppRegistry,
  Image,
  Switch,
  Button,
  FlatList,
  TouchableOpacity,
  TextInput,
  Alert,
  ScrollView,
  Dimensions,
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
  stackRight: {
    flex: 1,
    flexDirection:'column',
    alignItems: 'flex-start',
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
  miniCellContainer: {
    flex: 0,
    flexDirection:'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#E0A500',
    marginRight: 10,
    marginLeft: 10,
  },
  managerCell: {
    flex:0,
    flexDirection:'row',
    padding:10
  },
  channel: {
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
  instructions: {
    fontSize: 11,
    marginTop: 40,
    textAlign: 'center',
    color: '#0d6a83',
    marginBottom: 5,
  },
  textInput: {
    flex:1,
    color:'#0d6a83',
    alignSelf: 'flex-start',
    width: 100,
    flexDirection:'row',
    height: 35,
    borderColor:'white',
    borderWidth: 1,
  },
  inputButton: {
    width: 150,
    height: 35,
  },
  circle: {
    width: 20,
    height: 20,
    borderRadius: 20/2,
    backgroundColor: '#0d6a83'
  },
  dash: {
   backgroundColor: 'white',
   height: 2,
   width: 10,
   position: 'absolute',
   left: 5,
   top: 8.5,
 },
});

export default class AirshipSample extends Component {
  constructor(props) {
    super(props);

    this.state = {
      channelId: "",
      isStarted: false,
    }

    this.handleIsStarted = this.handleIsStarted.bind(this);
    this.handleStartAdapter = this.handleStartAdapter.bind(this);
  }

  handleNotificationsEnabled(enabled) {
    UrbanAirship.setUserNotificationsEnabled(enabled)
    this.setState({notificationsEnabled:enabled});
  }

  handleLocationEnabled(enabled) {
    UrbanAirship.setLocationEnabled(enabled)
    this.setState({locationEnabled:enabled});
  }

  handleIsStarted () {
    UrbanAirship.getNamedUser().then((data) => {
         this.setState({
           namedUser: data,
         });
    });
  }

  handleNamedUserSet(text) {
    UrbanAirship.setNamedUser(text)
    this.handleUpdateNamedUser();
    this.setState({namedUserText:""})
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


  componentDidMount() {
    AirshipGimbalAdapter.isStarted().then ((started) => {
      this.setState({isStarted:started})
    })

    UrbanAirship.getChannelId().then((channelId) => {
      this.setState({channelId:channelId})
    });

    UrbanAirship.addListener("registration", (event) => {
      console.log('registration:', JSON.stringify(event));
      this.state.channelId = event.channelId;
      this.setState(this.state);
    });

  }

  render() {

    let channelcell = null
    if (this.state.channelId) {
      channelcell = <ChannelCell channelId={this.state.channelId}/>;
    }

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
              {channelcell}
          </View>
        </ScrollView>
    </View>

    );
  }
}

class ChannelCell extends Component {
  render() {
    return (
      <Text style={styles.channel}>
        Channel ID {'\n'}
        {this.props.channelId}
      </Text>
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