package scratch
{
import org.yellcorp.lib.env.ResizableStage;
import org.yellcorp.lib.net.BitmapLoader;

import flash.display.Bitmap;
import flash.events.Event;
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
    }

    private function onComplete(event:Event):void
    {
        addChild(new Bitmap(bml.copyBitmapData()));
        trace(bml.width);
        trace(bml.height);
    }
}
}
