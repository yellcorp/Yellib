package org.yellcorp.lib.geom
{
public class FitMode
{
    /**
     * Constant that directs the <code>RectUtil.fit</code> function to
     * calculate a result that is always smaller or equal to the target
     * area. One of the axes of the result may not fully span the target.
     *
     * @see RectUtil.fit()
     */
    public static const INSIDE:String = "inside";

    /**
     * Constant that directs the <code>RectUtil.fit</code> function to
     * calculate a result that is always larget or equal to the target
     * area. One of the axes of the result may exceed the target area.
     *
     * @see RectUtil.fit()
     */
    public static const OUTSIDE:String = "outside";
}
}
