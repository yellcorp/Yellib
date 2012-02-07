package org.yellcorp.lib.number
{
public class NumericLimits
{
    /**
     * The value above which a Number lacks the precision to represent every
     * integer. Equal to 2^53.
     */
    public static const MAX_INTEGRAL_PRECISION:Number = 9007199254740992.0;

    /**
     * The value below which a Number lacks the precision to represent every
     * integer. Equal to -(2^53).
     */
    public static const MIN_INTEGRAL_PRECISION:Number = -9007199254740992.0;
}
}
