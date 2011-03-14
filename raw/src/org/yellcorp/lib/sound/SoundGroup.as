package org.yellcorp.lib.sound
{
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;


public class SoundGroup
{
    private var channels:Dictionary;
    private var groupTransform:SoundTransform;

    function SoundGroup()
    {
        channels = new Dictionary();
        groupTransform = new SoundTransform();
    }

    public function addAndPlay(newSnd:Sound, startTime:Number = 0, loops:int = 0):void
    {
        if (loops == -1)
        {
            loops = int.MAX_VALUE;
        }
        _addAndPlay(newSnd, startTime, loops, channels);
    }

    public function addAndPlayName(newSndId:String, startTime:Number = 0, loops:int = 0):void
    {
        var sndClass:Class = Class(getDefinitionByName(newSndId));
        var newSnd:Sound = new sndClass();
        addAndPlay(newSnd, startTime, loops);
    }

    private function _addAndPlay(newSound:Sound, startTime:Number, loops:int, dict:Dictionary):void
    {
        var newChan:SoundChannel;

        newChan = newSound.play(startTime, loops, groupTransform);
        newChan.addEventListener(Event.SOUND_COMPLETE, onMemberComplete);
        dict[newChan] = new SoundInfo(newSound, startTime, loops);
    }

    public function pauseAll():void
    {
        var i:Object;
        var sc:SoundChannel;
        var s:SoundInfo;

        for (i in channels)
        {
            sc = SoundChannel(i);
            s = SoundInfo(channels[i]);
            s.playHead = sc.position;
            sc.stop();
        }
    }

    public function resumeAll():void
    {
        var i:Object;
        var sc:SoundChannel;
        var s:SoundInfo;

        var tempNew:Dictionary = new Dictionary();

        for (i in channels)
        {
            sc = SoundChannel(i);
            s = SoundInfo(channels[i]);

            _addAndPlay(s.sound, s.playHead, s.loops, tempNew);
        }
        channels = tempNew;
    }

    public function clear():void
    {
        pauseAll();
        channels = new Dictionary();
    }

    public function destroy():void
    {
        pauseAll();
        channels = null;
        groupTransform = null;
    }

    public function set pan(v:Number):void
    {
        groupTransform.pan = v;
        updateTransform();
    }

    public function get pan():Number
    {
        return groupTransform.pan;
    }

    public function set volume(v:Number):void
    {
        groupTransform.volume = v;
        updateTransform();
    }

    public function get volume():Number
    {
        return groupTransform.volume;
    }

    private function updateTransform():void
    {
        var i:Object;
        var sc:SoundChannel;

        for (i in channels)
        {
            sc = SoundChannel(i);
            sc.soundTransform = groupTransform;
        }
    }

    private function onMemberComplete(e:Event):void
    {
        var oldChan:SoundChannel;

        oldChan = SoundChannel(e.target);
        oldChan.removeEventListener(Event.SOUND_COMPLETE, onMemberComplete);
        delete channels[oldChan];
    }
}
}

// Helper class -- works but uncertain if officially supported by AS3
import flash.media.Sound;


class SoundInfo
{
    public var sound:Sound;
    public var loops:int;
    public var playHead:Number;

    function SoundInfo(s:Sound, p:Number, l:int)
    {
        sound = s;
        loops = l;
        playHead = p;
    }
}
