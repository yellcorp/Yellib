package wip.yellcorp.lib.debug
{
public class FileHeuristic
{
    private static var signatures:Array;

    public static function test():void
    {
        if (!signatures) initSigs();
    }

    private static function initSigs():void
    {
        signatures = processSigs([
            ["JPEG image/JFIF", 0xFF, 0xD8, 0xFF, 0xE0],
            ["JPEG image/Exif", 0xFF, 0xD8, 0xFF, 0xE1],

            ["GIF image/GIF87a", "GIF87a"],
            ["GIF image/GIF89a", "GIF89a"],

            ["PNG image", 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],

            ["SWF file/uncompressed", "FWS"],
            ["SWF file/compressed", "CWS"],

            ["FLV video", "FLV"]
        ]);
    }

    private static function processSigs(tableWithStrings:Array):Array
    {
        var inArray:Array;
        var outArray:Array;
        var result:Array;

        var i:int;
        var j:int;
        var splitString:String;

        result = new Array();

        for each (inArray in tableWithStrings)
        {
            outArray = [ inArray[0] ];
            for (i=1; i < inArray.length; i++)
            {
                if (inArray[i] is String)
                {
                    splitString = inArray[i];
                    for (j=0; j<splitString.length; j++)
                    {
                        outArray.push(splitString.charCodeAt(j));
                    }
                }
                else
                {
                    outArray.push(inArray[i]);
                }
            }
            result.push(outArray);
        }
        return result;
    }
}
}
