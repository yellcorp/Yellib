package scratch.scale9bmp
{
import org.yellcorp.bitmap.Scale9Bitmap;
import org.yellcorp.env.ResizableStage;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;


[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="480")]
public class TestScale9Bmp extends ResizableStage
{
    [Embed(source="testScale9.png")]
    private static var testBmpSource:Class;

    private var mousing:Boolean;
    private var testBmp:BitmapData;
    private var testScaleBmp:Scale9Bitmap;
    private var offset:Point;
    private var debugShape:Shape;

    public function TestScale9Bmp()
    {
        super();
        testBmp = Bitmap(new testBmpSource()).bitmapData.clone();
        testScaleBmp = new Scale9Bitmap(testBmp, PixelSnapping.AUTO, true, new Rectangle(80, 40, 204, 120));
//            testScaleBmp = new Scale9Bitmap(testBmp, PixelSnapping.AUTO, true, new Rectangle(70, 30, 224, 140));

            addChild(testScaleBmp);
            addChild(debugShape = new Shape());
        }

        protected override function onStageAvailable():void
        {
            stage.addEventListener(MouseEvent.CLICK, onClick);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }

        private function onClick(event:MouseEvent):void
        {
            mousing = !mousing;
            offset = new Point(testScaleBmp.width - event.stageX, testScaleBmp.height - event.stageY);
        }

        private function onMove(event:MouseEvent):void
        {
            if (mousing)
            {
                testScaleBmp.width = event.stageX + offset.x;
                testScaleBmp.height = event.stageY + offset.y;

                debugShape.graphics.clear();
                debugShape.graphics.beginFill(0, .2);
                debugShape.graphics.drawRect(0, 0, testScaleBmp.width, testScaleBmp.height);
                debugShape.graphics.endFill();
            }
        }
    }
}
