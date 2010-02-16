package test
{
import org.yellcorp.bitmap.BitmapDataPool;
import org.yellcorp.env.ResizableStage;

import flash.display.BitmapData;


public class TestWorkingBitmapSet extends ResizableStage
{
    private var bmpSet:BitmapDataPool;

    public function TestWorkingBitmapSet()
    {
        var i:int;

        var bmp1:BitmapData;
        var bmp2:BitmapData;

        super();
        bmpSet = new BitmapDataPool();

        for (i=0; i < 10; i++)
        {
            bmp1 = bmpSet.getBitmapData(320, 240, true);
            bmp2 = bmpSet.getBitmapData(320, 240, true);

            bmp1.fillRect(bmp1.rect, 0xFF00FF00);
            bmp2.fillRect(bmp2.rect, 0xFFFF00FF);

            bmp1.dispose();
            bmp2.dispose();

            bmp1 = bmpSet.getBitmapData(320, 240, true);
            bmp2 = bmpSet.getBitmapData(320, 240, false);

            bmp1.fillRect(bmp1.rect, 0xFFFFFF00);
            bmp2.fillRect(bmp2.rect, 0xFF0000FF);

            bmp1.dispose();
            bmp2.dispose();
        }

        bmpSet.dispose();
    }
}
}
