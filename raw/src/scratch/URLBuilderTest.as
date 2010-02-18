package scratch
{

public class URLBuilderTest
{
    private static var extractInput:RegExp = /(\S+)/ ;
    private static var extractOutput:RegExp = /<URL:([^>]+)/ ;
    private static var ioSplit:RegExp = /\s*=\s*/ ;
    private static var caseSplit:String = "\n";

    public static function getBaseURLString():String
    {
        var content:String = rfcDoc..pre[0].toString();
        var match:Object = extractOutput.exec(content);
        return match[1];
    }

    public static function getTests():Array
    {
        var result:Array = [];
        var node:XML;

        for each (node in rfcDoc..pre)
        {
            processNode(node, result);
        }

        return result;
    }

    private static function processNode(node:XML, output:Array):void
    {
        var pairs:Array = node.toString().split(caseSplit);
        var pair:String;

        for each (pair in pairs)
        {
            processPair(pair, output);
        }
    }

    private static function processPair(pairText:String, output:Array):void
    {
        var match:Object;
        var testIn:String = "";
        var testOut:String = "";
        var split:Array = pairText.split(ioSplit, 2);

        if (split.length < 2) return;

        match = extractInput.exec(split[0]);
        if (match) testIn = match[1];

        match = extractOutput.exec(split[1]);
        if (match) testOut = match[1];

        if (testIn.length > 0 && testOut.length > 0)
        {
            output.push(testIn, testOut);
        }
    }

    public static var rfcDoc:XML = <html>
    <!-- http://www.freesoft.org/CIE/RFC/1808/19.htm -->
    <pre>      Base: &lt;URL:http://a/b/c/d;p?q#f&gt;
    </pre>
<pre>
      g:h        = &lt;URL:g:h&gt;
      g          = &lt;URL:http://a/b/c/g&gt;

      ./g        = &lt;URL:http://a/b/c/g&gt;
      g/         = &lt;URL:http://a/b/c/g/&gt;
      /g         = &lt;URL:http://a/g&gt;
      //g        = &lt;URL:http://g&gt;
      ?y         = &lt;URL:http://a/b/c/d;p?y&gt;

      g?y        = &lt;URL:http://a/b/c/g?y&gt;
      g?y/./x    = &lt;URL:http://a/b/c/g?y/./x&gt;
      #s         = &lt;URL:http://a/b/c/d;p?q#s&gt;
      g#s        = &lt;URL:http://a/b/c/g#s&gt;
      g#s/./x    = &lt;URL:http://a/b/c/g#s/./x&gt;

      g?y#s      = &lt;URL:http://a/b/c/g?y#s&gt;
      ;x         = &lt;URL:http://a/b/c/d;x&gt;
      g;x        = &lt;URL:http://a/b/c/g;x&gt;
      g;x?y#s    = &lt;URL:http://a/b/c/g;x?y#s&gt;
      .          = &lt;URL:http://a/b/c/&gt;

      ./         = &lt;URL:http://a/b/c/&gt;
      ..         = &lt;URL:http://a/b/&gt;
      ../        = &lt;URL:http://a/b/&gt;
      ../g       = &lt;URL:http://a/b/g&gt;
      ../..      = &lt;URL:http://a/&gt;

      ../../     = &lt;URL:http://a/&gt;
      ../../g    = &lt;URL:http://a/g&gt;
</pre>

<!-- http://www.freesoft.org/CIE/RFC/1808/21.htm -->
<p>
   An empty reference resolves to the complete base URL:
</p><p>
</p><pre>      &lt;&gt;            = &lt;URL:http://a/b/c/d;p?q#f&gt;

</pre>
<p>
   Parsers must be careful in handling the case where there are more
   relative path ".." segments than there are hierarchical levels in the
   base URL's path.  Note that the ".." syntax cannot be used to change
   the &lt;net_loc&gt; of a URL.
</p><p>
</p><pre>      ../../../g    = &lt;URL:http://a/../g&gt;
      ../../../../g = &lt;URL:http://a/../../g&gt;
</pre>

<p>
   Similarly, parsers must avoid treating "." and ".." as special when
   they are not complete components of a relative path.
</p><p>
</p><pre>      /./g          = &lt;URL:http://a/./g&gt;
      /../g         = &lt;URL:http://a/../g&gt;
      g.            = &lt;URL:http://a/b/c/g.&gt;
      .g            = &lt;URL:http://a/b/c/.g&gt;

      g..           = &lt;URL:http://a/b/c/g..&gt;
      ..g           = &lt;URL:http://a/b/c/..g&gt;
</pre>
<p>
   Less likely are cases where the relative URL uses unnecessary or
   nonsensical forms of the "." and ".." complete path segments.
</p><p>
</p><pre>      ./../g        = &lt;URL:http://a/b/g&gt;

      ./g/.         = &lt;URL:http://a/b/c/g/&gt;
      g/./h         = &lt;URL:http://a/b/c/g/h&gt;
      g/../h        = &lt;URL:http://a/b/c/h&gt;
</pre>
<p>
   Finally, some older parsers allow the scheme name to be present in a
   relative URL if it is the same as the base URL scheme.  This is
   considered to be a loophole in prior specifications of partial URLs
   [1] and should be avoided by future parsers.
</p><p>

</p><pre>      http:g        = &lt;URL:http:g&gt;
      http:         = &lt;URL:http:&gt;
</pre>

        </html> ;
    }
}
