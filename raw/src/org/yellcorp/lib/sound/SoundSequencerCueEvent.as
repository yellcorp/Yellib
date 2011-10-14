package org.yellcorp.lib.sound
{
import flash.events.Event;
import flash.media.Sound;


public class SoundSequencerCueEvent extends Event
{
    public static const SAMPLE_PLAYED:String = "samplePlayed";

    private var _sound:Sound;
    private var _sampleNumber:Number;
    private var _payload:*;

    public function SoundSequencerCueEvent(type:String,
        sound:Sound, sampleNumber:Number, payload:*,
        bubbles:Boolean = false, cancelable:Boolean = false)
    {
        _sound = sound;
        _sampleNumber = sampleNumber;
        _payload = payload;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new SoundSequencerCueEvent(
            type, _sound, _sampleNumber, _payload, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("SoundSequencerCueEvent", "type", "sampleNumber");
    }

    public function get sound():Sound
    {
        return _sound;
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
