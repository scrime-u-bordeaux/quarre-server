import QtQuick 2.0
import WPN114 1.0 as WPN114

Item
{
    property alias reverb:      reverb
    property alias amplitube:   amplitube
    property alias rooms:       effects_rooms

    WPN114.Rooms
    {
        id: effects_rooms
        active: true
        parentStream: audio_stream
        setup: rooms_setup
        exposePath: "/effects/rooms"

        WPN114.StereoSource //----------------------------------------------------- ALTIVERB
        {
            xspread: 0.25
            diffuse: 0.55
            y: 0.5

            exposePath: "/effects/reverb/source"

            WPN114.Convolver
            {                
                id: reverb
                active: true
                irPath: "/Users/pchd/Desktop/IRS/921.wav"
                exposePath: "/effects/reverb"
            }
        }

        WPN114.StereoSource //----------------------------------------------------- AMPLITUBE
        {
            xspread: 0.25
            diffuse: 0.55
            y: 0.5

            exposePath: "/effects/amplitube/source"

            WPN114.Convolver
            {
                id: amplitube
                active: false
                irPath: "/Users/pchd/Desktop/IRS/AMPDEFAULT.wav"
                exposePath: "/effects/amplitube"
            }
        }
    }
}
