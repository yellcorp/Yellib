package test.yellcorp
{
import asunit.framework.TestSuite;
import asunit.textui.TestRunner;

import test.yellcorp.lib.binary.NumberInfoTest;
import test.yellcorp.lib.color.IntColorUtilTest;
import test.yellcorp.lib.core.SetTest;
import test.yellcorp.lib.format.DateFormatFlexTest;
import test.yellcorp.lib.format.NumberFormatUtilTest;
import test.yellcorp.lib.format.geo.GeoFormatTest;
import test.yellcorp.lib.format.printf.PrintfSuite;
import test.yellcorp.lib.format.template.TemplateTest;
import test.yellcorp.lib.geom.Vector2.Vector2TestSuite;
import test.yellcorp.lib.geom.Vector3.Vector3TestSuite;
import test.yellcorp.lib.string.CharacterMapperTest;
import test.yellcorp.lib.string.StringLiteralTest;


public class RunAll extends TestRunner
{
    private var tests:TestSuite;

    public function RunAll()
    {
        super();
        tests = new TestSuite();
        tests.addTest(new NumberInfoTest());
        tests.addTest(new IntColorUtilTest());
        tests.addTest(new GeoFormatTest());
        tests.addTest(new PrintfSuite());
        tests.addTest(new TemplateTest());
        tests.addTest(new DateFormatFlexTest());
        tests.addTest(new NumberFormatUtilTest());
        tests.addTest(new Vector2TestSuite());
        tests.addTest(new Vector3TestSuite());
        tests.addTest(new SetTest());
        tests.addTest(new CharacterMapperTest());
        tests.addTest(new StringLiteralTest());

        doRun(tests, TestRunner.SHOW_TRACE);
    }
}
}
