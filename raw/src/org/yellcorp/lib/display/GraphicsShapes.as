package org.yellcorp.lib.display
{
import flash.display.Graphics;


/**
 * Functions for drawing common shapes on to flash.display.Graphics
 * instances.
 */
public class GraphicsShapes
{
    /**
     * Draws a dashed straight line.
     *
     * @param target The Graphics instance to draw into.
     * @param fromX  The x coordinate of the start of the line.
     * @param fromY  The y coordinate of the start of the line.
     * @param toX    The x coordinate of the end of the line.
     * @param toY    The y coordinate of the end of the line.
     * @param dashIntervals
     * An array of segment lengths.  The first number is the length of the
     * first dash.  Each number after that alternates between gap and dash,
     * then wraps around.
     */
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
        var isLineSegment:Boolean = true;

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
            if (isLineSegment)
            {
                target.moveTo(currentX, currentY);
            }
            else
            {
                target.lineTo(currentX, currentY);
            }
            dashIndex++;
            isLineSegment = !isLineSegment;
            if (dashIndex >= dashIntervals.length)
            {
                dashIndex = 0;
            }
        }
    }

    /**
     * Draws a plus symbol.
     *
     * @param target   The Graphics instance to draw into.
     * @param centerX  The x coordinate of the center of the plus.
     * @param centerY  The y coordinate of the center of the plus.
     * @param halfWidth   The half-width of the plus.  The plus will have
     *                    a width double this value.
     * @param halfHeight  The half-height of the plus.  The plus will have
     *                    a width double this value.  If omitted or
     *                    <code>NaN</code>, will use the same value as
     *                    <code>halfWidth</code>.
     */
    public static function
    drawPlus(target:Graphics, centerX:Number, centerY:Number,
             halfWidth:Number, halfHeight:Number = Number.NaN):void
    {
        if (isNaN(halfHeight))
        {
            halfHeight = halfWidth;
        }

        target.moveTo(centerX - halfWidth, centerY);
        target.lineTo(centerX + halfWidth, centerY);
        target.moveTo(centerX, centerY - halfHeight);
        target.lineTo(centerX, centerY + halfHeight);
    }

    /**
     * Draws an X symbol.
     *
     * @param target   The Graphics instance to draw into.
     * @param centerX  The x coordinate of the center of the cross.
     * @param centerY  The y coordinate of the center of the cross.
     * @param halfWidth   The half-width of the cross.  The cross will have
     *                    a width double this value.
     * @param halfHeight  The half-height of the cross.  The cross will have
     *                    a width double this value.  If omitted or
     *                    <code>NaN</code>, will use the same value as
     *                    <code>halfWidth</code>.
     */
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

    /**
     * Draws an arc of a circle.
     *
     * @param target   The Graphics instance to draw into.
     * @param centerX  The x coordinate of the center of the circle.
     * @param centerY  The y coordinate of the center of the circle.
     * @param radius   The radius of the circle.
     * @param startAngle  The angle at the start of the arc.
     * @param endAngle    The angle at the end of the arc.
     * @param drawRadius  If <code>true</code>, connects the ends of the
     *                    arc to the center of the circle, creating a wedge
     *                    shape.
     * @param steps  The number of quadratic curves to use when drawing.
     */
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

    /**
     * Draws a regular polygon.
     *
     * @param target   The Graphics instance to draw into.
     * @param centerX  The x coordinate of the center of the polygon.
     * @param centerY  The y coordinate of the center of the polygon.
     * @param radius   The distance from the center to each vertex.
     * @param sides    The number of sides.
     * @param rotate   A rotation offset to apply to all vertices.
     */
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

    /**
     * Draws a star by connecting the points of two concentric regular
     * polygons.
     *
     * @param target   The Graphics instance to draw into.
     * @param centerX  The x coordinate of the center of the star.
     * @param centerY  The y coordinate of the center of the star.
     * @param radius1  The radius of the first guide polygon.
     * @param radius2  The radius of the second guide polygon.
     * @param points   The number of outer points of the star.
     * @param rotate1  The rotational offset of the first guide polygon.
     * @param rotate2  The rotational offset of the second guide polygon. If
     *                 omitted or <code>NaN</code>, uses half the angle
     *                 between two outer points.
     */
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

    /**
     * Draws an arrow.
     *
     * @param target The Graphics instance to draw into.
     * @param fromX  The x coordinate of the origin of the arrow.
     * @param fromY  The y coordinate of the origin of the arrow.
     * @param toX    The x coordinate of the tip of the arrowhead.
     * @param toY    The y coordinate of the tip of the arrowhead.
     * @param headLengthFactor
     *     The length of the arrowhead, expressed as a factor of the
     *     arrow's length.
     * @param headHalfWidthFactor
     *     The perpendicular distance from the line to a trailing point of
     *     the arrowhead, expressed as a factor of the arrow's length.
     * @param closeHead  If <code>true</code>, draws a line between the
     *               trailing points of the arrowhead.
     */
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
