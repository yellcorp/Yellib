package scratch
{
import org.yellcorp.bitmap.BitmapLoader;
import org.yellcorp.bitmap.BitmapLoaderFitMethod;
import org.yellcorp.env.ResizableStage;

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
        bml = new BitmapLoader(true, 0, BitmapLoaderFitMethod.SCALE);
        bml.addEventListener(Event.COMPLETE, onComplete);
        bml.load(new URLRequest("presenter/miles.jpg"));
    }

    private function onComplete(event:Event):void
    {
        addChild(new Bitmap(bml.getBitmapData()));
    }
}
}
