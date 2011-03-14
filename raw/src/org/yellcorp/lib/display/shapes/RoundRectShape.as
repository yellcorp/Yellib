package org.yellcorp.lib.display.shapes
{
/**
 * A DisplayObject that mimics a rounded rectangle with a scale9 applied.
 * Not implemented as one, though, as scale9 doesn't work on objects
 * used as masks.
 */
public class RoundRectShape extends BaseFilledOutlinedShape
{
    public var topLeftRadius:Number = 0;
    public var topRightRadius:Number = 0;
    public var bottomLeftRadius:Number = 0;
    public var bottomRightRadius:Number = 0;

    public function RoundRectShape(startWidth:Number, startHeight:Number)
    {
        super(startWidth, startHeight);
    }

    public function setRadius(tl:Number,
                              tr:Number = Number.NaN,
                              bl:Number = Number.NaN,
                              br:Number = Number.NaN):void
    {
        // always cast topLeft NaN to 0
        tl = tl || 0;

        if (!isFinite(tr) && !isFinite(bl) && !isFinite(br))
        {
            // if the remaining 3 args are all NaN,
            // take this to mean use topLeft for all
            tr = bl = br = tl;
        }
        else
        {
            // otherwise cast each remaining NaN to 0
            tr = tr || 0;
            bl = bl || 0;
            br = br || 0;
        }

        topLeftRadius = tl;
        topRightRadius = tr;
        bottomLeftRadius = bl;
        bottomRightRadius = br;
    }

    protected override function draw(w:Number, h:Number):void
    {
        graphics.drawRoundRectComplex(0, 0, w, h,
                                      topLeftRadius,
                                      topRightRadius,
                                      bottomLeftRadius,
                                      bottomRightRadius);
    }
}
}
