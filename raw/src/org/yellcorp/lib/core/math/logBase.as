package org.yellcorp.lib.core.math
{
/**
 * Calculates an arbitrary base logarithm of a number.
 */
public function logBase(number:Number, base:Number):Number
{
    return Math.log(number) / Math.log(base);
}
}
