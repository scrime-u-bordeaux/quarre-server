import QtQuick 2.0
import WPN114 1.0 as WPN114

Item
{
    id: root
    property int idkey: 0

    property QuarreClient owner;

    property string title: ""
    property string description: ""
    property int length: 0
    property int countdown: 0
    property string module: ""
    property string path: ""
    property bool broadcast: false
    property var mappings

    function end()
    {

    }

    WPN114.Node on title        { path: "/interactions/"+root.path+"/title" }
    WPN114.Node on description  { path: "/interactions/"+root.path+"/description" }
    WPN114.Node on length       { path: "/interactions/"+root.path+"/length" }
    WPN114.Node on countdown    { path: "/interactions/"+root.path+"/countdown" }
    WPN114.Node on module       { path: "/interactions/"+root.path+"/module" }
    WPN114.Node on broadcast    { path: "/interactions/"+root.path+"/broadcast" }

    WPN114.Node
    {
        path: "/interactions/"+root.path+"/notify"
        type: WPN114.Type.Impulse

        onValueReceived: ;// incoming interaction
    }

    WPN114.Node
    {
        path: "/interactions/"+root.path+"/begin"
        type: WPN114.Type.Impulse

        onValueReceived: ;// trigger interaction
    }

    WPN114.Node
    {
        path: "/interactions/"+root.path+"/end"
        type: WPN114.Type.Impulse

        onValueReceived: ;// end interaction
    }
}
