//
// Copyright (C) 2008 Christoph Sommer <christoph.sommer@informatik.uni-erlangen.de>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package inet.veins.nodes;

import inet.veins.base.modules.*;
import inet.veins.modules.nic.Nic80211p;
import inet.networklayer.ipv4.IPv4NetworkLayer;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.ipv4.IPv4RoutingTable;
import inet.linklayer.loopback.LoopbackInterface;

module Car
{
    parameters:
        string routingTableType = default("IPv4RoutingTable");
        string applType; //type of the application layer
        string nicType = default("Nic80211p"); // type of network interface card
        string veinsmobilityType; //type of the mobility module
        @networkNode;
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default(routingTableType != "" ? absPath(".routingTable") : "");
        //routingTable.forwarding = forwarding;
        //routingTable.multicastForwarding = multicastForwarding;   // for IPv4, IPv6, Generic
        
        
    gates:
        input veinsradioIn; // gate for sendDirect
    submodules:
        appl: <applType> like inet.veins.base.modules.IBaseApplLayer {
            parameters:
                @display("p=60,50");
        }

        nic: <nicType> like inet.veins.modules.nic.INic80211p {
            parameters:
                @display("p=60,166");
        }

        veinsmobility: <veinsmobilityType> like inet.veins.base.modules.IMobility {
            parameters:
                @display("p=130,172;i=block/cogwheel");
        }
        // network layer
        networkLayer: IPv4NetworkLayer {
            parameters:
                @display("p=329,287;q=queue");
        }
        // linklayer
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=53,300;is=s");
        }
        // routing table
        routingTable: IPv4RoutingTable {
            parameters:
                @display("p=53,250;is=s");
        }
        //loopback interface
        lo0: LoopbackInterface {
            @display("p=78,406");
        }
        
    connections allowunconnected:
        
        //wlan[i].upperLayerOut --> networkLayer.ifIn++;
        //appl. <-- networkLayer.ifOut++;
        
        
        ////networkLayer.ifOut++ --> appl.lowerLayerIn;
        //lo0.upperLayerOut --> networkLayer.ifIn++;
        ////appl.lowerLayerOut --> networkLayer.ifIn++;
        
        ////nic.upperLayerOut --> networkLayer.ifIn++;
        ////nic.upperLayerIn <-- networkLayer.ifOut++;
        
        //nic.upperLayerOut --> appl.lowerLayerIn;
        //nic.upperLayerIn <-- appl.lowerLayerOut;
        
        
       
        networkLayer.ifOut++ --> lo0.upperLayerIn;
        lo0.upperLayerOut --> networkLayer.ifIn++;


		networkLayer.transportOut++ --> appl.lowerLayerIn;
		networkLayer.transportIn++ <-- appl.lowerLayerOut;
        
            //radioIn[i] --> { @display("m=s"); } --> wlan[i].radioIn;
            nic.upperLayerOut --> networkLayer.ifIn++;
            nic.upperLayerIn <-- networkLayer.ifOut++;
             
           
        
        
        nic.upperControlOut --> appl.lowerControlIn;
        nic.upperControlIn <-- appl.lowerControlOut;

        veinsradioIn --> nic.radioIn;

}
