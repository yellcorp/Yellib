package scratch.asrsound
{
import org.yellcorp.lib.sound.ASRSound;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;


public class TestASRSound extends Sprite
{
    [Embed(source="sml128.mp3", mimeType="audio/mpeg")]
    private var musicEmbed:Class;

    private var asrSound:ASRSound;

    public function TestASRSound()
    {
        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    private function onStage(event:Event):void
    {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

        asrSound = new ASRSound(new musicEmbed(), 9 * 44100, 10 * 44100, 2048);
        asrSound.play();
    }

    private function onKeyDown(event:KeyboardEvent):void
    {
        var chr:String = String.fromCharCode(event.charCode);

        switch (chr)
        {
        case "r" :
            asrSound.release(false);
            break;
        case "i" :
            asrSound.release(true);
            break;
        case "s" :
            asrSound.stop();
            break;
        }
    }
}
}
