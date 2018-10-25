import QtQuick 2.0
import WPN114 1.0 as WPN114

Item
{
    property int maxClients;
    property alias clients: clients

    function dispatch(target, interaction)
    {
        var candidates = [ ];
        var priorities = [ ];

        if ( interaction.broadcast )
        {
            for ( var u = 0; u < maxClients; ++u )
                if ( clients.itemAt(u).connected )
                     clients.itemAt(u).notifyInteraction(interaction);
            return;
        }

        for ( var c = 0; c < maxClients; ++c )
        {
            var client = clients.itemAt(c);           
            var priority = 0;

            if      ( !client.connected )                    continue;
            if      ( client.status === "incoming" )         continue;
            else if ( client.status === "active_incoming" )  continue;
            else if ( client.status === "active" )
            {
                var acd = client.getActiveCountdown();
                if ( interaction.countdown < acd+5 )         continue;

                priority = 1;
            }
            else if ( client.status === "idle" );
            else continue;

            priority += client.interaction_count;

            candidates.push ( client );
            priorities.push ( priority );
        }

        var winner;
        var winner_priority = 0;

        for ( var i = 0; i < candidates.length; ++i )
        {
            var select = candidates[i];
            if ( winner === undefined )
            {
                winner = select;
                winner_priority = priorities[i];
                continue;
            }

            if ( priorities[i] === winner_priority )
            {
                var r = Math.random();
                if ( r > 0.5 ) winner = select;
            }
            else if ( priorities[i] < winner_priority )
                winner = select;
        }

        if ( winner !== undefined )
        {
            winner.notifyInteraction(interaction);
            interaction.dispatched.value = true;
        }
    }

    function notifyStart()
    {
        for ( var c = 0; c < maxClients; ++c )
        {
            var  client = clients.itemAt(c);
            if ( client.connected )
                 client.remote.sendMessage("/scenario/running", true, true);
        }
    }

    function notifyEnd()
    {
        for ( var c = 0; c < maxClients; ++c )
        {
            var  client = clients.itemAt(c);
            if ( client.connected )
                 client.remote.sendMessage("/scenario/running", false, true);
        }
    }

    function notifyScene(name)
    {
        for ( var c = 0; c < maxClients; ++c )
        {
            var  client = clients.itemAt(c);
            if ( client.connected )
                 client.remote.sendMessage("/scenario/scene/name", name, true);
        }
    }

    WPN114.Node
    {
        path: "/global/interactions/reset"
        type: WPN114.Type.Impulse

        critical: true

        onValueReceived:
        {
            for ( var c = 0; c < maxClients; ++c )
            {
                var  client = clients.itemAt(c);
                if ( client.connected )
                {
                    client.remote.get("/interactions/reset").value = 0;
                    client.interaction_count = 0;
                }
            }
        }
    }

    Connections
    {
        target: module_server
        onNewConnection:
        {            
            var hostaddr  = host.split(":")[0]+':'+'5678'
            console.log("New connection:", hostaddr);

            for ( var c = 0; c < maxClients; ++c )
            {
                var client = clients.itemAt(c);
                if ( !client.connected )
                {
                    client.remote.connect(hostaddr);
                    break;
                }
            }
        }
    }

    Repeater
    {
        id: clients
        model: maxClients

        QuarreClient { number: index }
    }
}
