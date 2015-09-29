//
// Generated file, do not edit! Created by nedtool 4.6 from base/messages/ChannelSenseRequest.msg.
//

#ifndef _CHANNELSENSEREQUEST_M_H_
#define _CHANNELSENSEREQUEST_M_H_

#include <omnetpp.h>

// nedtool version check
#define MSGC_VERSION 0x0406
#if (MSGC_VERSION!=OMNETPP_VERSION)
#    error Version mismatch! Probably this file was generated by an earlier version of nedtool: 'make clean' should help.
#endif



// cplusplus {{
#include "../phyLayer/ChannelState.h"
// }}

/**
 * Enum generated from <tt>base/messages/ChannelSenseRequest.msg:8</tt> by nedtool.
 * <pre>
 * enum SenseMode
 * {
 * 
 *     UNTIL_IDLE = 1;		//sense until channel is busy or timeout is reached
 *     UNTIL_BUSY = 2;		//sense until channel is idle or timeout is reached
 *     UNTIL_TIMEOUT = 3;	//sense until timeout is reached
 * }
 * </pre>
 */
enum SenseMode {
    UNTIL_IDLE = 1,
    UNTIL_BUSY = 2,
    UNTIL_TIMEOUT = 3
};

/**
 * Class generated from <tt>base/messages/ChannelSenseRequest.msg:46</tt> by nedtool.
 * <pre>
 * //
 * // The ChannelSenseRequest is a control packet from the
 * // MAC layer to the physical layer. In contrast to the
 * // "getChannelState()" method of the MacToPhyInterface
 * // which imediatly returns the current ChannelState
 * // the ChannelSenseRequest tells the physical layers decider
 * // to sense over a period of time before sending back
 * // the request together with the ChannelState over this period.
 * //
 * // Every ChannelSenseRequest sent to the physical layer
 * // has to define a SenseMode and a timeout.
 * // The timeout defines after how much seconds the request
 * // should be sent back to the MAC layer at latest.
 * // The SenseMode tells the physical layers the purpose of the
 * // sense. The SenseModes "UNTIL_IDLE" and "UNTIL_BUSY" are
 * // telling it to inform the MAC layer as soon as the 
 * // channel turns idle/busy by sending the request back to it.
 * // If the channel state does not change the request is sent
 * // back after the timeout.
 * // While "UNTIL_IDLE" and "UNTIL_BUSY" can be used as pure
 * // conveniance functions which don't necessarily represent a
 * // real channel sense, "UNTIL_TIMEOUT" *always* represents a real 
 * // channel sensing of the MAC over a fixed period of time
 * // where the request together with the result will be always sent 
 * // back after the timeout.
 * //
 * // The request returned to the MAC layer holds the result
 * // in the form of a ChannelState object. How the idle and
 * // rssi info contained in the ChannelState are calculated
 * // and interpreted depends on the Decider.
 * //
 * packet ChannelSenseRequest
 * {
 *     int senseMode @enum(SenseMode);	// defines the sensing mode (see SenseMode enum)
 *     simtime_t senseTimeout; 		// Time to listen on the channel
 *     ChannelState result; 			// The result of the request containing the current state of the channel.
 * 									// See ChannelState for details.
 * }
 * </pre>
 */
class ChannelSenseRequest : public ::cPacket
{
  protected:
    int senseMode_var;
    simtime_t senseTimeout_var;
    ChannelState result_var;

  private:
    void copy(const ChannelSenseRequest& other);

  protected:
    // protected and unimplemented operator==(), to prevent accidental usage
    bool operator==(const ChannelSenseRequest&);

  public:
    ChannelSenseRequest(const char *name=NULL, int kind=0);
    ChannelSenseRequest(const ChannelSenseRequest& other);
    virtual ~ChannelSenseRequest();
    ChannelSenseRequest& operator=(const ChannelSenseRequest& other);
    virtual ChannelSenseRequest *dup() const {return new ChannelSenseRequest(*this);}
    virtual void parsimPack(cCommBuffer *b);
    virtual void parsimUnpack(cCommBuffer *b);

    // field getter/setter methods
    virtual int getSenseMode() const;
    virtual void setSenseMode(int senseMode);
    virtual simtime_t getSenseTimeout() const;
    virtual void setSenseTimeout(simtime_t senseTimeout);
    virtual ChannelState& getResult();
    virtual const ChannelState& getResult() const {return const_cast<ChannelSenseRequest*>(this)->getResult();}
    virtual void setResult(const ChannelState& result);
};

inline void doPacking(cCommBuffer *b, ChannelSenseRequest& obj) {obj.parsimPack(b);}
inline void doUnpacking(cCommBuffer *b, ChannelSenseRequest& obj) {obj.parsimUnpack(b);}


#endif // ifndef _CHANNELSENSEREQUEST_M_H_

