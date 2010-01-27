package org.yellcorp.media
{
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;


public class SoundPlayback
{
    private var _sound:Sound;
    private var _channel:SoundChannel;
    private var statePosition:Number;
    private var stateLoop:Boolean;
    private var stateTransform:SoundTransform;
    private var restartTransform:SoundTransform;

    public function SoundPlayback(baseSound:Sound)
    {
        _sound = baseSound;
        stateTransform = new SoundTransform();
        restartTransform = new SoundTransform();
    }

    public function play(startTime:Number = 0, loop:Boolean = false, sndTransform:SoundTransform = null):void
    {
        _stop(false);
        _channel = _sound.play(startTime, loop ? int.MAX_VALUE : 0, sndTransform);
        stateLoop = loop;
    }

    public function stop():void
    {
        _stop(false);
    }

    public function pause():void
    {
        _stop(true);
    }

    public function resume():void
    {
        if (!_channel)
        {
            copySoundTransform(stateTransform, restartTransform);
            _channel = _sound.play(statePosition, stateLoop ? int.MAX_VALUE : 0, restartTransform);
        }
    }

    public function get sound():Sound
    {
        return _sound;
    }

    public function get channel():SoundChannel
    {
        return _channel;
    }

    private function _stop(save:Boolean):void
    {
        if (_channel)
        {
            if (save)
            {
                saveState();
            }
            else
            {
                clearState();
            }
            _channel.stop();
            _channel = null;
        }
        else
        {
            clearState();
        }
    }

    private function saveState():void
    {
        statePosition = _channel.position;
        copySoundTransform(_channel.soundTransform, stateTransform);
    }

    private function clearState():void
    {
        statePosition = 0;
        stateLoop = false;
        stateTransform.volume = 1;
        stateTransform.pan = 0;
    }

    private static function copySoundTransform(source:SoundTransform, target:SoundTransform):void
    {
        target.leftToLeft = source.leftToLeft;
        target.rightToLeft = source.rightToLeft;
        target.leftToRight = source.leftToRight;
        target.rightToRight = source.rightToRight;
        target.volume = source.volume;
    }
}
}
