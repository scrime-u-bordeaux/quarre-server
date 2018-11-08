import QtQuick 2.0
import WPN114 1.0 as WPN114
import ".."

Item
{
    id: root
    property alias scenario: scenario
    property alias rooms: wpn214_rooms
    property var fade_target: woodpath.jomon

    signal end();

    WPN114.TimeNode
    {
        id:         scenario
        exposePath: "/wpn214/scenario"
        source:     audio_stream
        duration:   -1

        InteractionExecutor
        {
            id:         interaction_ending_ex
            target:     interaction_ending
            countdown:  sec( 10 )
            length:     min( 4.30 )

            onStart:
            {
                wpn214_rooms.active = true;
                wpn214_rooms.level = 1;
                sampler.play();
                client_manager.notifyScene("wpn214")
            }
        }

        WPN114.Automation
        {
            after: interaction_ending_ex;
            target: fade_target.rooms
            property: "level"
            duration: sec( 10 )

            from: fade_target.rooms.level
            to: 0;

            onEnd:
            {
                fade_target.rooms.active = false
                wpn214_rooms.active = false
                scenario.end();
                root.end();
            }
        }
    }

    Interaction //----------------------------------------------------- INTERACTION
    {
        id: interaction_ending

        title: "Fin, WPN214"
        path:   "/wpn214/interactions/wpn214"

        module: "quarre/WPN214.qml"
        broadcast: true
        description: "Merci pour votre participation"
    }

    WPN114.Rooms
    {
        id: wpn214_rooms
        active: false
        parentStream: audio_stream
        setup: rooms_setup
        exposePath: "/wpn214/rooms"

        WPN114.StereoSource //----------------------------------------- SAMPLER
        {
            fixed: true
            diffuse: 0.2
            xspread: 0.25
            y: 0.75

            exposePath: "/wpn214/sampler/source"

            WPN114.StreamSampler { id: sampler
                dBlevel: -3
                exposePath: "/wpn214/sampler"
                path: "audio/wpn214/wpn214.wav" }
        }
    }
}
