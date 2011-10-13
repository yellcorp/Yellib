package org.yellcorp.lib.sound
{
import flash.events.Event;


public class SoundSequencerCueEvent extends Event
{
    public static const SAMPLE_PLAYED:String = "samplePlayed";

    private var _sampleNumber:Number;
    private var _payload:*;

    public function SoundSequencerCueEvent(type:String, sampleNumber:Number, payload:*, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        _sampleNumber = sampleNumber;
        _payload = payload;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new SoundSequencerCueEvent(type, _sampleNumber, _payload, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("SoundSequencerCueEvent", "type", "sampleNumber");
    }

    public function get sampleNumber():Number
    {
        return _sampleNumber;
    }

    public function get payload():*
    {
        return _payload;
    }
}
}
