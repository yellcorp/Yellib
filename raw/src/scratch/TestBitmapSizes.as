package scratch
{
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLRequest;


public class TestBitmapSizes extends Sprite
{
    private var path:String;
    private var files:Array;

    public function TestBitmapSizes()
    {
        super();

        path = "img_size_test/";

        files = [
            "2880x2880.jpg",
            "6000x6000.jpg",
            "8192x2048.jpg",
            "8191x2048.jpg",
            "4095x4095.jpg",
            "4096x4096.jpg",
            "4096x4097.jpg",
        ];

        loadNextImage();
    }

    private function loadNextImage():void
    {
        var loader:Loader;
        var file:String = files.shift();

        if (file)
        {
            loader = new Loader();
            listen(loader.contentLoaderInfo);
            loader.load(new URLRequest(path + file));
            trace('---');
            trace('Loading ' + path + file);
        }
        else
        {
            trace('===');
            trace('End of images');
        }
    }

    private function listen(cli:LoaderInfo):void
    {
        cli.addEventListener(Event.COMPLETE, onImageLoad);
        cli.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
    }

    private function unlisten(cli:LoaderInfo):void
    {
        cli.addEventListener(Event.COMPLETE, onImageLoad);
        cli.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
    }

    private function onImageLoad(event:Event):void
    {
        var cli:LoaderInfo = LoaderInfo(event.target);
        var loader:Loader = cli.loader;
        unlisten(loader.contentLoaderInfo);
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoad);

        addChild(loader);
        stage.addEventListener(MouseEvent.CLICK, onClick);

        trace('---');

        trace('cli.width: ' + (cli.width));
        trace('cli.height: ' + (cli.height));
        trace('area: ' + (cli.height * cli.width));
        trace('cli.bytesTotal: ' + (cli.bytesTotal));
        trace('cli.content: ' + (cli.content));

        trace('loader.width: ' + (loader.width));
        trace('loader.height: ' + (loader.height));
    }

    private function onImageError(event:IOErrorEvent):void
    {
        trace(event);
        stage.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.CLICK, onClick);
        removeChild(getChildAt(0));
        loadNextImage();
    }
}
}
