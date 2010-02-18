package scratch
{
import org.yellcorp.env.ResizableStage;

import flash.display.Bitmap;
import flash.display.BitmapData;


public class BmpXor extends ResizableStage
{
    public function BmpXor()
    {
        super();

        var x:int, y:int;
        var bmp:BitmapData = new BitmapData(256, 256, false, 0);

        for (y = 0;y < 256; y++)
        {
            for (x = 0;x < 256; x++)
            {
                bmp.setPixel(x, y, x^y);
            }
        }

        addChild(new Bitmap(bmp));
    }
}
}
