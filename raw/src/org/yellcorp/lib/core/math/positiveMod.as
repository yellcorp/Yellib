package org.yellcorp.lib.core.math
{
/**
 * Calculate the positive modulo of a division.
 */
public function positiveMod(dividend:Number, divisor:Number):Number
{
    var modResult:Number = dividend % divisor;
    return modResult < 0 ? modResult + divisor : modResult;
}
}
