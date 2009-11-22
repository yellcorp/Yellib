package org.yellcorp.util {
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;


public class GeomEx {
    /**
     * Returns the top-left point necessary to centre a rectangle relative to another.
     *
     * @param subject    The Rectangle, Point or DisplayObject to centre.
     *                     When a DisplayObject is used, it is assumed to be
     *                     anchored at x=0, y=0.
     *                     When a Point is used, Point.x is interpreted as the
     *                     width, and Point.y as the height of the rectangle.
     * @param relativeTo    The Rectangle or DisplayObject to centre relative to.
     */
    public static function centreTopLeft(subject:*, relativeTo:*):Point {
        var dispObj:DisplayObject;
        var moveRect:Rectangle;
        var relRect:Rectangle;
        var result:Point;


        if (subject is Rectangle) {
            moveRect = subject as Rectangle;
        } else if (subject is DisplayObject) {
            dispObj = subject as DisplayObject;
            moveRect = new Rectangle(dispObj.x, dispObj.y, dispObj.width, dispObj.height);
        } else if (subject is Point) {
            moveRect = new Rectangle();
            moveRect.bottomRight = subject as Point;
        } else {
            throw new ArgumentError("subject must be a Rectangle, Point or DisplayObject");
        }


        if (relativeTo is Rectangle) {
            relRect = relativeTo as Rectangle;
        } else if (relativeTo is DisplayObject) {
            dispObj = relativeTo as DisplayObject;
            relRect = new Rectangle(dispObj.x, dispObj.y, dispObj.width, dispObj.height);
        } else {
            throw new ArgumentError("relativeTo must be a Rectangle or DisplayObject");
        }


        result = new Point(
             (relRect.width - moveRect.width) / 2
            ,(relRect.height - moveRect.height) / 2
        );

        result.x += relRect.left;
        result.y += relRect.top;

        return result;
    }
}
}
