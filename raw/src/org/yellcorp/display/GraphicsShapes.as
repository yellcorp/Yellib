package org.yellcorp.display
{
import flash.display.Graphics;


public class GraphicsShapes
{
    public static function
    drawDashLine(target:Graphics, fromX:Number, fromY:Number,
                 toX:Number, toY:Number, dashIntervals:Array):void
    {
        var deltaX:Number, deltaY:Number,
            unitX:Number, unitY:Number,
            currentX:Number, currentY:Number,
            lineDistance:Number;

        var sumDistance:Number = 0;

        var dashIndex:int = 0;

        if (!dashIntervals || dashIntervals.length < 2)
        {
            target.moveTo(fromX, fromY);
            target.lineTo(toX, toY);
            return;
        }
        deltaX = toX - fromX;
        deltaY = toY - fromY;
        lineDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
        unitX = deltaX / lineDistance;
        unitY = deltaY / lineDistance;
        currentX = fromX;
        currentY = fromY;
        target.moveTo(currentX, currentY);
        while (sumDistance < lineDistance)
        {
            sumDistance += dashIntervals[dashIndex];
            if (sumDistance < lineDistance)
            {
                currentX += dashIntervals[dashIndex] * unitX;
                currentY += dashIntervals[dashIndex] * unitY;
            }
            else
            {
                currentX = toX;
                currentY = toY;
            }
            if (dashIndex & 1)
            {
                target.moveTo(currentX, currentY);
            }
            else
            {
                target.lineTo(currentX, currentY);
            }
            dashIndex++;
            if (dashIndex >= dashIntervals.length)
            {
                dashIndex = 0;
            }
        }
    }

    public static function
    drawPlus(target:Graphics, centreX:Number, centreY:Number,
             halfWidth:Number, halfHeight:Number = Number.NaN):void
    {
        if (isNaN(halfHeight))
        {
            halfHeight = halfWidth;
        }

        target.moveTo(centreX - halfWidth, centreY);
        target.lineTo(centreX + halfWidth, centreY);
        target.moveTo(centreX, centreY - halfHeight);
        target.lineTo(centreX, centreY + halfHeight);
    }

    public static function
    drawCross(target:Graphics, centreX:Number, centreY:Number,
              halfWidth:Number, halfHeight:Number = Number.NaN):void
    {
        if (isNaN(halfHeight))
        {
            halfHeight = halfWidth;
        }

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
        var secant:Number;

        var halfStepAngle:Number, currentAngle:Number,
            influenceAngle:Number, nextAngle:Number;

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
            influenceAngle = currentAngle + halfStepAngle;
            nextAngle = influenceAngle + halfStepAngle;

            target.curveTo(centreX + Math.cos(influenceAngle) * secant,
                           centreY + Math.sin(influenceAngle) * secant,
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
        if (isNaN(rotate2))
        {
            rotate2 = rotate1 + angleStep * 0.5;
        }

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
        var deltaX:Number, deltaY:Number, headDeltaX:Number,
            headDeltaY:Number, headCenterX:Number, headCenterY:Number;

        if (isNaN(headHalfWidthFactor))
        {
            headHalfWidthFactor = headLengthFactor * 0.5;
        }

        target.moveTo(fromX, fromY);
        target.lineTo(toX, toY);

        deltaX = toX - fromX;
        deltaY = toY - fromY;

        headCenterX = fromX + (1 - headLengthFactor) * deltaX;
        headCenterY = fromY + (1 - headLengthFactor) * deltaY;

        headDeltaX = -deltaY * headHalfWidthFactor;
        headDeltaY = deltaX * headHalfWidthFactor;

        target.moveTo(headCenterX + headDeltaX, headCenterY + headDeltaY);
        target.lineTo(toX, toY);
        target.lineTo(headCenterX - headDeltaX, headCenterY - headDeltaY);

        if (closeHead)
        {
            target.lineTo(headCenterX + headDeltaX, headCenterY + headDeltaY);
        }
    }
}
}
