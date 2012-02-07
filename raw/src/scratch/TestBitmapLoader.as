package scratch
{
import org.yellcorp.lib.env.ResizableStage;
import org.yellcorp.lib.net.BitmapLoader;

import flash.display.Bitmap;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;


[SWF(backgroundColor="#FFFFFF", frameRate="10", width="1024", height="768")]
public class TestBitmapLoader extends ResizableStage
{
    private var bml:BitmapLoader;

    public function TestBitmapLoader()
    {
        super();
        bml = new BitmapLoader();
        bml.addEventListener(Event.COMPLETE, onComplete);
        bml.load(new URLRequest("fp10-exact-area.png"));
        bml.addEventListener(IOErrorEvent.IO_ERROR, onError);
        bml.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }

    private function onComplete(event:Event):void
    {
        addChild(new Bitmap(bml.copyBitmapData()));
        trace(bml.width + " x " + bml.height);
    }

    private function onError(event:ErrorEvent):void
    {
        trace(event);
    }
}
}
