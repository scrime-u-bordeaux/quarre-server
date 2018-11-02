import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import WPN114 1.0 as WPN114

import "scenes"
import "views"

// TODO: Pink Noise setup testing module
// TODO: Mixing module for every scene (including forks)
// TODO: Spatialization for every scene
// TODO: volume and spatialization presets
// TODO: FLAC audio

Rectangle
{
    id: application
    objectName: "quarre-root"

    visible: true
    width: 640
    height: 480

    WPN114.FolderNode //------------------------------------------------------------- NETSERVER
    {
        device: module_server
        recursive: true
        folderPath: "/Users/pchd/Repositories/quarre-server/resources/qml/modules"
        path: "/modules"
        filters: ["*.qml"]
    }

    WPN114.OSCQueryServer
    {
        id: module_server
        name: "quarre-modules"
        tcpPort: 8576
        udpPort: 4132
    }

    WPN114.OSCQueryServer
    {
        id: query_server
        singleDevice: true
        name: "quarre-server"
        tcpPort: 5678
        udpPort: 1234       

        Component.onCompleted:
            mainview.tree.model = query_server.nodeTree()
    }

    WPN114.AudioStream //------------------------------------------------------------- AUDIO
    {
        id:             audio_stream

        outDevice:      "Scarlett 18i20 USB"
        numOutputs:     2

//        outDevice:      "Soundflower (64ch)"
//        numOutputs:     8

        sampleRate:     44100
        blockSize:      512
        active:         false

        inserts: WPN114.PeakRMS { id: vu_master; onPeak: mainview.processPeak(value) }

        Component.onCompleted:
        {
            scenario.initialize();
        }

        onActiveChanged:
        {
            if ( active ) start();
            else stop();
        }

        WPN114.Node on dBlevel { path: "/global/audio/master/dBlevel" }
        WPN114.Node on active { path: "/global/audio/master/active" }
        WPN114.Node on mute { path: "/global/audio/master/muted" }
    }

    WPN114.RoomSetup // octophonic ring setup for quarrè-angoulême
    {
        id: rooms_setup;        
//        WPN114.SpeakerRing { nspeakers: 8; offset: Math.PI/8; influence: 0.55 }
        WPN114.SpeakerPair { xspread: 0.25; y: 0.5; influence: 0.5 }
    }

    ClientManager   { id: client_manager; maxClients: 4 }
    Functions       { id: functions }
    Scenario        { id: scenario }
    MainView        { id: mainview }

}
