package org.yellcorp.format.geo
{
import org.yellcorp.format.geo.renderer.Renderer;


/**
 * %d   - absolute degrees
 * %m   - absolute minutes
 * %.#s - absolute seconds
 * %-   - sign, only if negative
 * %+   - sign if + or -
 * %o   - longitudinal sign (E/W)
 * %a   - latitudinal sign (N/S)
 * %*   - degree sign, U+00B0
 * %'   - prime, U+2032
 * %''  - double prime, U+2033
 * %%   - literal percent
 */
public class GeoFormat
{
    private static var cache:Object = { };
    private static var parser:Parser = new Parser();

    public static function format(formatString:String, degrees:Number):String
    {
        var renderers:Array = cache[formatString];

        if (!renderers)
        {
            cache[formatString] = renderers = parser.parse(formatString);
        }

        return renderers.map(
            function (r:Renderer, i:*, a:*):String
            {
                return r.render(degrees);
            }
        ).join("");
    }

    public static function clearCache():void
    {
        cache = { };
    }
}
}
