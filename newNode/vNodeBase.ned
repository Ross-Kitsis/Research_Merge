//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 


//Base  module defining a node in a veins simulation
//All nodes in a veins simulation should use this as a base

package inet.veins.newNode;

import inet.node.inet.INetworkNode;
import inet.common.lifecycle.NodeStatus;
import inet.common.packet.PcapRecorder;

import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.common.InterfaceTable;
import inet.linklayer.contract.IWirelessNic;

import inet.power.contract.IEnergyStorage;
import inet.power.contract.IEnergyGenerator;

import inet.linklayer.loopback.LoopbackInterface;

import inet.linklayer.ieee80211.Ieee80211Nic;

//Base module for all wireless nodes in a simulation using Veins
module vNodeBase like INetworkNode
{
    parameters:
        @display("bgb=,448");
        @networkNode;
        @labels(wireless-node);
        bool hasStatus = default(false); //Module to store status of node
        int numRadios = default(1); //Number of radios (All veins applications should use 1+ radios)
        int numPcapRecorders = default(0); // no of PcapRecorders. (Packet capture)
        string networkLayerType = default("IPv4NetworkLayer"); //Type of network layer (IPv4 or IPv6)
        string routingTableType = default("IPv4RoutingTable"); //Type of routing (if required) (IPv4 or IPv6)
        bool forwarding = default(true); //Does node forward messages?
        bool multicastForwarding = default(false); //Multicast messages forwarded?
        string energyStorageType = default(""); // Energy storage type
        string energyGeneratorType = default(""); //Energy generation
        routingTable.forwarding = forwarding; //Set routing table to allow forwarding
        routingTable.multicastForwarding = multicastForwarding;   // for IPv4, IPv6, Generic
        *.interfaceTableModule = default(absPath(".interfaceTable")); //Set interface table module
        *.routingTableModule = default(routingTableType != "" ? absPath(".routingTable") : ""); //Set routing table module
        *.energySourceModule = default(energyStorageType != "" ? absPath(".energyStorage") : ""); //Set energy source module
    gates:
        input radioIn[numRadios] @directIn; //Interface for airframes (Wireless)
        inout pppg[] @labels(PPPFrame-conn); //PPP Interfaces for PPP frames (Not used but required for INetworkNode interface)
        inout ethg[] @labels(EtherFrame-conn); //Ethernet interfaces for ethernet frames (Not used but required for INetworkNode interface)
    submodules:
        
        //Status submodule 
        status: NodeStatus if hasStatus 
        {
            @display("p=50,50");
        }
        //Energy Storage
        energyStorage: <energyStorageType> like IEnergyStorage if energyStorageType != "" {
            parameters:
                @display("p=50,100;i=block/plug;is=s");
        }
        // network layer
        networkLayer: <networkLayerType> like INetworkLayer {
            parameters:
                @display("p=329,287;q=queue");
        }
        // routing table
        routingTable: <routingTableType> like IRoutingTable if routingTableType != "" {
            parameters:
                @display("p=53,250;is=s");
        }
        // linklayer
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=53,300;is=s");
        }
        // Packet capture recorder
        pcapRecorder[numPcapRecorders]: PcapRecorder {
            @display("p=53,350,r,10");
        }
        //Loopback interface
        lo0: LoopbackInterface {
            @display("p=78,406");
        }
        
        wlan[numRadios]: Ieee80211Nic
        {
            parameters:
                @display("p=244,434,row,60;q=queue");
        }
        
    connections allowunconnected:
        
        // connections to network outside
        networkLayer.ifOut++ --> lo0.upperLayerIn;
        lo0.upperLayerOut --> networkLayer.ifIn++;
        
        for i=0..sizeof(radioIn)-1 
        {
            radioIn[i] --> { @display("m=s"); } --> wlan[i].radioIn;
            wlan[i].upperLayerOut --> networkLayer.ifIn++;
            wlan[i].upperLayerIn <-- networkLayer.ifOut++;
        }
        
}