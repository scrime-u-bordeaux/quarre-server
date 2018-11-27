import QtQuick 2.0
import WPN114 1.0 as WPN114
import ".."

Scene
{
    id: root

    notify: false
    audio: false

    property alias cendres: cendres
    Cendres { id: cendres; path: root.fmt("cendres")}

    scenario: WPN114.TimeNode
    {
        source: audiostream
        parentNode: parent.scenario
        duration: WPN114.TimeNode.Infinite
        onStart: cendres.start()
    }
}