package org.yellcorp.lib.format.geo.renderer
{
import org.yellcorp.lib.format.geo.FieldProperties;
import org.yellcorp.lib.format.printf.Format;
import org.yellcorp.lib.format.printf.options.FloatFormatOptions;


public class NumberRenderer implements Renderer
{
    private var formatOptions:FloatFormatOptions;
    private var multiplier:Number;
    private var mod:Number;
    private var floor:Boolean;

    public function NumberRenderer(properties:FieldProperties,
        multiplier:Number, mod:Number, floorIfZeroPrecision:Boolean)
    {
        formatOptions = new FloatFormatOptions();
        formatOptions.minWidth = properties.minWidth;
        formatOptions.paddingCharacter = properties.zeroPad ? "0" : " ";
        formatOptions.fractionalWidth = properties.precision;

        this.multiplier = multiplier;
        this.mod = mod;
        this.floor = floorIfZeroPrecision && properties.precision == 0;
    }

    public function render(quantity:Number):String
    {
        quantity *= (quantity < 0) ? -multiplier : multiplier;
        if (mod != 0) quantity %= mod;
        if (floor) quantity = Math.floor(quantity);

        return Format.formatFixed(quantity, formatOptions);
    }
}
}
