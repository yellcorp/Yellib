package org.yellcorp.lib.sound
{
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.utils.ByteArray;


public class SoundSequencer
{
    private var _outputBufferSize:uint;

    private var cues:Array;
    private var sequenceSampleLength:Number;

    // the data from individual sounds are extracted into this ByteArray
    private var extractBuffer:ByteArray;

    // mixing buffers. during the mixing loop, one stores the accumulated
    // sum of the playing waves thus far, and the other is set to that sum
    // plus the next sound wave. A and B are swapped at the end of each
    // iteration
    private var mixingBufferA:ByteArray;
    private var mixingBufferB:ByteArray;

    // acts as a source of zero bytes when the first sound in the mixing
    // loop does not coincide exactly with the start of the packet
    private var zeroBuffer:ByteArray;

    public function SoundSequencer(outputBufferSize:uint = 8192)
    {
        if (outputBufferSize < 2048 || outputBufferSize > 8192)
        {
            throw new ArgumentError("outputBufferSize must be in the range 2048 to 8192");
        }
        _outputBufferSize = outputBufferSize;
        cues = [ ];

        extractBuffer = new ByteArray();
        mixingBufferA = new ByteArray();
        mixingBufferB = new ByteArray();
        zeroBuffer = createZeroBuffer(_outputBufferSize);
        sequenceSampleLength = 0;
    }

    public function cue(sound:Sound, sample:int, repeatCount:int = 0):void
    {
        var newCue:Cue;

        do {
            newCue = new Cue(sound, sample);
            cues.push(newCue);
            sample += newCue.length;
            repeatCount--;
        } while (repeatCount >= 0);

        if (newCue.endSample > sequenceSampleLength)
        {
            sequenceSampleLength = newCue.endSample;
        }
    }

    public function getSound():Sound
    {
        var userSound:Sound = new Sound();
        userSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData, false, 0, false);
        return userSound;
    }

    private function onSampleData(event:SampleDataEvent):void
    {
        var packetStart:Number = event.position;
        var packetEnd:Number = packetStart + _outputBufferSize;

        var cueLength:Number;
        var packetOffset:Number;
        var cueOffset:Number;
        var samplesExtracted:Number;

        var srcBuffer:ByteArray;
        var destBuffer:ByteArray;

        srcBuffer = zeroBuffer;
        destBuffer = mixingBufferB;

        if (packetStart > sequenceSampleLength)
        {
            // sequence complete
            return;
        }

        // this will contain data from the last packet, so clear it
        mixingBufferA.clear();

        for each (var cue:Cue in cues)
        {
            // check if it overlaps with the current packet
            if (cue.startSample > packetEnd ||
                cue.endSample < packetStart)
            {
                continue;
            }

            srcBuffer.position = 0;
            destBuffer.clear();
            extractBuffer.clear();

            if (packetStart >= cue.startSample)
            {
                // we are exactly at the start, or in the middle of the
                // cued sound
                packetOffset = 0;
                cueOffset = packetStart - cue.startSample;
                cueLength = _outputBufferSize;
            }
            else
            {
                // otherwise the cued sound is starting in the middle of
                // this packet
                packetOffset = cue.startSample - packetStart;
                cueOffset = 0;
                cueLength = _outputBufferSize - packetOffset;
            }

            samplesExtracted = cue.sound.extract(extractBuffer, cueLength, cueOffset);
            if (samplesExtracted == 0)
            {
                // reached the end of this cued sound
                continue;
            }
            extractBuffer.position = 0;

            if (packetOffset > 0)
            {
                // cued sound starts in the middle of the packet - just
                // copy the accumulation buffer data up to that point
                destBuffer.writeBytes(srcBuffer, 0, packetOffset * 8);
                srcBuffer.position = packetOffset * 8;
            }

            while (srcBuffer.bytesAvailable > 0 && extractBuffer.bytesAvailable > 0)
            {
                // mix the cued sound with the accumulation buffer
                // left channel
                destBuffer.writeFloat(srcBuffer.readFloat() + extractBuffer.readFloat());
                // right channel
                destBuffer.writeFloat(srcBuffer.readFloat() + extractBuffer.readFloat());
            }

            if (srcBuffer.bytesAvailable > 0)
            {
                // ran out of cued sound during the mix, write the rest of
                // the accumulation buffer
                destBuffer.writeBytes(srcBuffer, srcBuffer.position);
            }

            // we have just mixed one more cued sound into the destination
            // buffer, so it will act as the source on the next loop,
            // therefore swap the buffers.  we compare srcBuffer to mixingBufferB
            // because srcBuffer won't equal mixingBufferA on the first loop,
            // it will be pointing at zeroBuffer instead
            if (srcBuffer == mixingBufferB)
            {
                srcBuffer = mixingBufferA;
                destBuffer = mixingBufferB;
            }
            else
            {
                srcBuffer = mixingBufferB;
                destBuffer = mixingBufferA;
            }
        }
        event.data.writeBytes(srcBuffer);
    }

    private static function createZeroBuffer(sampleCount:uint):ByteArray
    {
        var zeroBuffer:ByteArray = new ByteArray();
        for (var i:int = 0; i < sampleCount; i++)
        {
            zeroBuffer.writeDouble(0);
        }
        zeroBuffer.position = 0;
        return zeroBuffer;
    }
}
}


import flash.media.Sound;


class Cue
{
    public var sound:Sound;
    public var startSample:Number;
    public var length:Number;
    public var endSample:Number;

    public function Cue(sound:Sound, startSample:Number)
    {
        this.sound = sound;
        this.startSample = startSample;
        this.length = Math.ceil(sound.length * 44.1);
        this.endSample = startSample + this.length;
    }
}
