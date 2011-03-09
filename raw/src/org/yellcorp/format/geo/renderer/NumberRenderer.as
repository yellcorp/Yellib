package org.yellcorp.format.geo.renderer
{
import org.yellcorp.format.geo.FieldProperties;
import org.yellcorp.format.printf.Format;
import org.yellcorp.format.printf.options.FloatFormatOptions;


public class NumberRenderer implements Renderer
{
    private var formatOptions:FloatFormatOptions;
    private var multiplier:Number;
    private var mod:Number;
    private var truncate:Boolean;

    public function NumberRenderer(properties:FieldProperties,
        multiplier:Number, mod:Number, truncateIfZeroPrecision:Boolean)
    {
        formatOptions = new FloatFormatOptions();
        formatOptions.minWidth = properties.minWidth;
        formatOptions.paddingCharacter = properties.zeroPad ? "0" : " ";
        formatOptions.fractionalWidth = properties.precision;

        this.multiplier = multiplier;
        this.mod = mod;
        this.truncate = truncateIfZeroPrecision && properties.precision == 0;
    }

    public function render(quantity:Number):String
    {
        quantity *= (quantity < 0) ? -multiplier : multiplier;
        if (mod != 0) quantity %= mod;
        if (truncate) quantity = Math.floor(quantity);

        return Format.formatFixed(quantity, formatOptions);
    }
}
}
