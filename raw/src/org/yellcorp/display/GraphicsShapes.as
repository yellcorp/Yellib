package org.yellcorp.display
{
import flash.display.Graphics;


public class GraphicsShapes
{
    public static function
    drawPlus(target:Graphics, centreX:Number, centreY:Number,
             halfWidth:Number, halfHeight:Number = Number.NaN):void
    {
        if (isNaN(halfHeight)) halfHeight = halfWidth;

        target.moveTo(centreX - halfWidth, centreY);
        target.lineTo(centreX + halfWidth, centreY);
        target.moveTo(centreX, centreY - halfHeight);
        target.lineTo(centreX, centreY - halfHeight);
    }

    public static function
    drawCross(target:Graphics, centreX:Number, centreY:Number,
              halfWidth:Number, halfHeight:Number = Number.NaN):void
    {
        if (isNaN(halfHeight)) halfHeight = halfWidth;

        target.moveTo(centreX - halfWidth, centreY - halfHeight);
        target.lineTo(centreX + halfWidth, centreY + halfHeight);
        target.moveTo(centreX + halfWidth, centreY - halfHeight);
        target.lineTo(centreX - halfWidth, centreY + halfHeight);
    }

    public static function
    drawArc(target:Graphics, centreX:Number, centreY:Number,
            radius:Number, startAngle:Number, endAngle:Number,
            drawRadius:Boolean = false, steps:Number = 6):void
    {
        var halfStepAngle:Number;
        var secant:Number;

        var currentAngle:Number;
        var secantAngle:Number;
        var nextAngle:Number;

        var i:int;

        halfStepAngle = (endAngle - startAngle) / (steps * 2);
        secant = radius / Math.cos(halfStepAngle);
        currentAngle = startAngle;

        if (drawRadius)
        {
            target.moveTo(centreX, centreY);
            target.lineTo(centreX + Math.cos(currentAngle) * radius,
                          centreY + Math.sin(currentAngle) * radius);
        }
        else
        {
            target.moveTo(centreX + Math.cos(currentAngle) * radius,
                          centreY + Math.sin(currentAngle) * radius);
        }

        for (i = 0; i < steps; i++)
        {
            secantAngle = currentAngle + halfStepAngle;
            nextAngle = secantAngle + halfStepAngle;

            target.curveTo(centreX + Math.cos(secantAngle) * secant,
                           centreY + Math.sin(secantAngle) * secant,
                           centreX + Math.cos(nextAngle) * radius,
                           centreY + Math.sin(nextAngle) * radius);

            currentAngle = nextAngle;
        }

        if (drawRadius)
        {
            target.lineTo(centreX, centreY);
        }
    }

    public static function
    drawPolygon(target:Graphics,
                centreX:Number, centreY:Number,
                radius:Number, sides:uint,
                rotate:Number = 0):void
    {
        var i:uint;
        var angleStep:Number;

        angleStep = Math.PI * (2 / sides);

        target.moveTo(centreX + Math.cos(rotate) * radius,
                      centreY + Math.sin(rotate) * radius);

        for (i = 0; i < sides; i++)
        {
            rotate += angleStep;
            target.lineTo(centreX + Math.cos(rotate) * radius,
                          centreY + Math.sin(rotate) * radius);
        }
    }

    public static function
    drawPolyStar(target:Graphics,
                 centreX:Number, centreY:Number,
                 radius1:Number, radius2:Number,
                 points:uint,
                 rotate1:Number = 0, rotate2:Number = Number.NaN):void
    {
        var i:uint;
        var angleStep:Number;

        angleStep = Math.PI * (2 / points);
        if (isNaN(rotate2)) rotate2 = rotate1 + angleStep * 0.5;

        target.moveTo(centreX + Math.cos(rotate1) * radius1,
                      centreY + Math.sin(rotate1) * radius1);

        for (i = 0; i < points; i++)
        {
            target.lineTo(centreX + Math.cos(rotate2) * radius2,
                          centreY + Math.sin(rotate2) * radius2);

            rotate2 += angleStep;
            rotate1 += angleStep;

            target.lineTo(centreX + Math.cos(rotate1) * radius1,
                          centreY + Math.sin(rotate1) * radius1);
        }
    }

    public static function
    drawArrow(target:Graphics,
              fromX:Number, fromY:Number,
              toX:Number, toY:Number,
              headLengthFactor:Number,
              headHalfWidthFactor:Number = Number.NaN,
              closeHead:Boolean = false):void
    {
        var headLengthX:Number;
        var headLengthY:Number;
        var halfHeadWidthX:Number;
        var halfHeadWidthY:Number;

        if (isNaN(headHalfWidthFactor)) headHalfWidthFactor = headLengthFactor * 0.5;

        headLengthX = (toX - fromX) * headLengthFactor;
        headLengthY = (toY - fromY) * headLengthFactor;

        halfHeadWidthX = (toY - fromY) * headHalfWidthFactor;
        halfHeadWidthY = (fromX - toX) * headHalfWidthFactor;

        target.moveTo(fromX, fromY);
        target.lineTo(toX, toX);

        target.moveTo(toX - headLengthX + halfHeadWidthX,
                      toY - headLengthY + halfHeadWidthY);

        target.lineTo(toX, toY);

        target.lineTo(toX - headLengthX - halfHeadWidthX,
                      toY - headLengthY - halfHeadWidthY);

        if (closeHead)
        {
            target.lineTo(toX - headLengthX + halfHeadWidthX,
                          toY - headLengthY + halfHeadWidthY);
        }
    }
}
}
