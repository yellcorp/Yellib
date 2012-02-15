package test.yellcorp.lib.bitmap.Scale9BitmapMesh
{
import org.yellcorp.lib.bitmap.Scale9BitmapMesh;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;


[SWF(backgroundColor="#7f7f7f", frameRate="90", width="640", height="480")]
public class Scale9BitmapMeshTestInteractive extends Sprite
{
    [Embed(source="/../rsrc/embed/Scale9BitmapMeshTest/testgrid.png")]
    private var testgrid:Class;

    private var imageDisplay:Bitmap;
    private var image:BitmapData;
    private var source:RectangleControl;

    private var targetLayer:Sprite;
    private var scale9Demo:Scale9BitmapMesh;
    private var target:RectangleControl;

    public function Scale9BitmapMeshTestInteractive()
    {
        imageDisplay = new testgrid();
        image = imageDisplay.bitmapData;

        addChild(imageDisplay);
        source = new RectangleControl(image.width * .5, image.height * .5, 1, 0xFFFFFFFF, 0);
        source.filters = [ new GlowFilter(0, 1, 4, 4, 1, 2) ];
        source.x = image.width * .25;
        source.y = image.height * .25;

        addChild(source);

        targetLayer = new Sprite();
        targetLayer.x = 320;
        addChild(targetLayer);
        scale9Demo = new Scale9BitmapMesh(image, new Rectangle(source.x, source.y, source.width, source.height), true);
        targetLayer.addChild(scale9Demo);
        target = new RectangleControl(image.width, image.height, 0, 0xFFFF0000, 0);
        targetLayer.addChild(target);

        source.addEventListener(Event.CHANGE, onSourceChange);
        target.addEventListener(Event.CHANGE, onTargetChange);
    }

    private function onSourceChange(event:Event):void
    {
        scale9Demo.scale9Grid = new Rectangle(source.x, source.y, source.width, source.height);
    }

    private function onTargetChange(event:Event):void
    {
        scale9Demo.x = target.x;
        scale9Demo.y = target.y;
        scale9Demo.width = target.width;
        scale9Demo.height = target.height;
    }
}
}
