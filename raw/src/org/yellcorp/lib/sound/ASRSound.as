package org.yellcorp.lib.sound
{
import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;


/**
 * An ASRSound represents sampled audio with Attack, Sustain and Release
 * segments. The Attack segment is played once when playback begins, the
 * Sustain segment is looped continuously, and when directed, the Release
 * is played once, after which playback stops.
 */
public class ASRSound
{
    private var source:Sound;
    private var sustainStart:uint;
    private var sustainEnd:uint;
    private var sustainLength:uint;

    private var outputSound:Sound;
    private var outputBufferSize:uint;
    private var lastInputPosition:uint;
    private var playingRelease:Boolean;

    private var channel:SoundChannel;

    /**
     * Creates a new <code>ASRSound</code>.
     *
     * @param source  A flash.media.Sound object that provides the sampled
     *                audio to play.
     *
     * @param sustainStart  The number of the sample that marks the end of
     *                      the Attack segment and the beginning of the
     *                      Sustain segment. When the Sustain segment is
     *                      looped, playback returns to this sample. The
     *                      sampling rate is always 44100 hz.
     *
     * @param sustainEnd    The number of the sample that marks the end of
     *                      the Sustain segment and the beginning of the
     *                      Release segment.
     *
     * @param outputBufferSize  The number of samples to send to the Sample
     *                          Data API at once.  Higher values decrease
     *                          CPU load but increase latency in response
     *                          to calling <code>release()</code>.  Valid
     *                          range is 2048 to 8192.
     */
    public function ASRSound(
        source:Sound,
        sustainStart:uint,
        sustainEnd:uint,
        outputBufferSize:uint = 8192)
    {
        if (outputBufferSize < 2048 || outputBufferSize > 8192)
        {
            throw new ArgumentError(
                "outputBufferSize must be in the range 2048 to 8192");
        }

        this.source = source;
        this.sustainStart = sustainStart;
        this.sustainEnd = sustainEnd;
        this.outputBufferSize = outputBufferSize;
        sustainLength = sustainEnd - sustainStart;
        outputSound = new Sound();
    }

    /**
     * Begins playback. Playback begins from sample 0, plays the Attack
     * segment, and loops the Sustain segment until <code>release()</code>
     * or <code>stop()</code> is called.
     *
     * @return  A SoundChannel object associated with this sound's playback.
     */
    public function play():SoundChannel
    {
        stop();
        outputSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
        channel = outputSound.play();
        channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        return channel;
    }

    /**
     * Plays the Release segment, then stops playback.
     *
     * @param immediate If <code>true</code>, jumps immediately from the
     *                  current sample in the Sustain segment to the first
     *                  sample of the Release segment. If
     *                  <code>false</code>, the Sustain is played to its
     *                  end before playing the Release.
     */
    public function release(immediate:Boolean):void
    {
        playingRelease = true;
        if (immediate) lastInputPosition = sustainEnd;
    }

    /**
     * Immediately stops playback.
     */
    public function stop():void
    {
        if (channel)
        {
            channel.stop();
        }
        reset();
    }

    private function reset():void
    {
        outputSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
        if (channel)
            channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        channel = null;
        playingRelease = false;
        lastInputPosition = 0;
    }

    private function onSoundComplete(event:Event):void
    {
        reset();
    }

    private function onSampleData(event:SampleDataEvent):void
    {
        var samplesWritten:int;
        var samplesRead:int;
        var inputPosition:Number;
        var outputPosition:Number;

        if (playingRelease)
        {
            samplesRead = source.extract(event.data, outputBufferSize, lastInputPosition);
            lastInputPosition += samplesRead;
        }
        else
        {
            samplesWritten = 0;
            outputPosition = event.position;

            while (samplesWritten < outputBufferSize)
            {
                if (outputPosition < sustainStart)
                {
                    inputPosition = outputPosition;
                    samplesRead = sustainStart - inputPosition;
                }
                else
                {
                    inputPosition = (outputPosition - sustainStart) % sustainLength + sustainStart;
                    samplesRead = sustainEnd - inputPosition;
                }

                if (samplesRead + samplesWritten > outputBufferSize)
                    samplesRead = outputBufferSize - samplesWritten;

                samplesRead = source.extract(event.data, samplesRead, inputPosition);
                lastInputPosition = inputPosition + samplesRead;

                if (samplesRead == 0)
                {
                    throw new Error("no bytes");
                }

                samplesWritten += samplesRead;
                outputPosition += samplesRead;
            }
        }
    }
}
}
