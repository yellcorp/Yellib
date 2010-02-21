package test.yellcorp.format
{
import asunit.framework.TestCase;

import org.yellcorp.format.DateFormatFlex;


public class DateFormatFlexTest extends TestCase
{
    private var date:Date;
    private var midnight:Date;
    private var midday:Date;

    public function DateFormatFlexTest(testMethod:String = null)
    {
        super(testMethod);
    }
    protected override function setUp():void
    {
        date = new Date(2010, 1, 21, 22, 49, 30, 456);
        midnight = new Date(2010, 1, 21, 0);
        midday = new Date(2010, 1, 21, 12);
    }
    public function testEmpty():void
    {
        assertEquals("Empty string",
                     "",
                     DateFormatFlex.format("", date));
    }
    public function testNoTokens():void
    {
        assertEquals("No tokens",
                     "no tokens here",
                     DateFormatFlex.format("no tokens here", date));
    }
    public function testYear():void
    {
        assertEquals("Year 4 digits",
                     "<2010>",
                     DateFormatFlex.format("<YYYY>", date));
        assertEquals("Year 5 digits",
                     "<02010>",
                     DateFormatFlex.format("<YYYYY>", date));
        assertEquals("Year 2 digits",
                     "<10>",
                     DateFormatFlex.format("<YY>", date));
        assertEquals("Year 1->2 digits",
                     "<10>",
                     DateFormatFlex.format("<Y>", date));
        assertEquals("Year 3->4 digits",
                     "<2010>",
                     DateFormatFlex.format("<YYY>", date));
    }
    public function testMonth():void
    {
        assertEquals("Month 1",
                     "<2>",
                     DateFormatFlex.format("<M>", date));
        assertEquals("Month 2",
                     "<02>",
                     DateFormatFlex.format("<MM>", date));
        assertEquals("Month 3",
                     "<Feb>",
                     DateFormatFlex.format("<MMM>", date));
        assertEquals("Month 4",
                     "<February>",
                     DateFormatFlex.format("<MMMM>", date));
        assertEquals("Month 5",
                     "<February>",
                     DateFormatFlex.format("<MMMMM>", date));
    }
    public function testDayOfMonth():void
    {
        assertEquals("Day(month) 1",
                     "<21>",
                     DateFormatFlex.format("<D>", date));
        assertEquals("Day(month) 2",
                     "<21>",
                     DateFormatFlex.format("<DD>", date));
        assertEquals("Day(month) 3",
                     "<021>",
                     DateFormatFlex.format("<DDD>", date));
    }
    public function testDayOfWeek():void
    {
        assertEquals("Day(week) 1",
                     "<0>",
                     DateFormatFlex.format("<E>", date));
        assertEquals("Day(week) 2",
                     "<00>",
                     DateFormatFlex.format("<EE>", date));
        assertEquals("Day(week) 3",
                     "<Sun>",
                     DateFormatFlex.format("<EEE>", date));
        assertEquals("Day(week) 4",
                     "<Sunday>",
                     DateFormatFlex.format("<EEEE>", date));
        assertEquals("Day(week) 5",
                     "<Sunday>",
                     DateFormatFlex.format("<EEEEE>", date));
    }
    public function testDayHalf():void
    {
        var am:Date = new Date(2010, 1, 10, 3);
        assertEquals("Day half pm",
                     "<PM>",
                     DateFormatFlex.format("<A>", date));
        assertEquals("Day half am",
                     "<AM>",
                     DateFormatFlex.format("<A>", am));
    }
    public function testHour0_23():void
    {
        assertEquals("Hour(0-23) 1",
                     "<22>",
                     DateFormatFlex.format("<J>", date));
        assertEquals("Hour(0-23) 1",
                     "<0>",
                     DateFormatFlex.format("<J>", midnight));
    }
    public function testHour1_24():void
    {
        assertEquals("Hour(1-24) 1",
                     "<22>",
                     DateFormatFlex.format("<H>", date));
        assertEquals("Hour(1-24) 1",
                     "<24>",
                     DateFormatFlex.format("<H>", midnight));
    }
    public function testHour0_11():void
    {
        assertEquals("Hour(0-11) 1",
                     "<10>",
                     DateFormatFlex.format("<K>", date));
        assertEquals("Hour(0-11) 1",
                     "<0>",
                     DateFormatFlex.format("<K>", midnight));
        assertEquals("Hour(0-11) 1",
                     "<0>",
                     DateFormatFlex.format("<K>", midday));
    }
    public function testHour1_12():void
    {
        assertEquals("Hour(1-12) 1",
                     "<10>",
                     DateFormatFlex.format("<L>", date));
        assertEquals("Hour(1-12) 1",
                     "<12>",
                     DateFormatFlex.format("<L>", midnight));
        assertEquals("Hour(1-12) 1",
                     "<12>",
                     DateFormatFlex.format("<L>", midday));
    }
    public function testMinutes():void
    {
        assertEquals("Minute 1",
                     "<49>",
                     DateFormatFlex.format("<N>", date));
    }
    public function testSeconds():void
    {
        assertEquals("Seconds 1",
                     "<30>",
                     DateFormatFlex.format("<S>", date));
    }
    public function testOrdinal():void
    {
        assertEquals("Ordinal 1",
                     "<st>",
                     DateFormatFlex.format("<T>", date));
        assertEquals("Ordinal 2",
                     "<st>",
                     DateFormatFlex.format("<TT>", date));
        assertEquals("Ordinal 3",
                     "<st>",
                     DateFormatFlex.format("<TTT>", date));
        var ordTestDate:Date = new Date(2010, 1, 1);
        assertEquals("Ordinal 1st",
                     "<st>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 2;
        assertEquals("Ordinal 2nd",
                     "<nd>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 3;
        assertEquals("Ordinal 3rd",
                     "<rd>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 4;
        assertEquals("Ordinal 4th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 11;
        assertEquals("Ordinal 11th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 12;
        assertEquals("Ordinal 12th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 13;
        assertEquals("Ordinal 13th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 14;
        assertEquals("Ordinal 14th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 21;
        assertEquals("Ordinal 21st",
                     "<st>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 22;
        assertEquals("Ordinal 22nd",
                     "<nd>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 23;
        assertEquals("Ordinal 23rd",
                     "<rd>",
                     DateFormatFlex.format("<T>", ordTestDate));
        ordTestDate.date = 24;
        assertEquals("Ordinal 24th",
                     "<th>",
                     DateFormatFlex.format("<T>", ordTestDate));
    }
    public function testMsec():void
    {
        assertEquals("msec 1",
                     "<5>",
                     DateFormatFlex.format("<U>", date));
        assertEquals("msec 2",
                     "<46>",
                     DateFormatFlex.format("<UU>", date));
        assertEquals("msec 3",
                     "<456>",
                     DateFormatFlex.format("<UUU>", date));
        assertEquals("msec 4",
                     "<4560>",
                     DateFormatFlex.format("<UUUU>", date));
        assertEquals("msec 5",
                     "<45600>",
                     DateFormatFlex.format("<UUUUU>", date));
    }
    public function testMultiTokens():void
    {
        assertEquals("common compact",
                     "21/02/10",
                     DateFormatFlex.format("DD/MM/YY", date));
        assertEquals("common short",
                     "21 Feb 2010",
                     DateFormatFlex.format("D MMM YYYY", date));
        assertEquals("common long",
                     "<<February 21st, 2010>>",
                     DateFormatFlex.format("<<MMMM DT, YYYY>>", date));
        assertEquals("adjacent tokens",
                     "<<20100221-224930>>",
                     DateFormatFlex.format("<<YYYYMMDD-JJNNSS>>", date));
    }
}
}
