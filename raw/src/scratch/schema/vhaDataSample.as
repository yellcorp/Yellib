package test.schema
{
public var vhaDataSample:XML =

<data date="YYYY-MM-DD">

    <!-- mobiles tag will contain one or more mobile tags -->
    <mobiles>
        <!-- id value can be any number or string, as long as it is consistent
             and unique among mobiles -->
        <mobile id="0123456789ABCDEF">
            <name>Nokia E71</name>

            <!-- Not available at launch. Stars will not be
                 displayed if 'review' tag is omitted -->
            <review>4.2</review>

            <!-- URL to image of phone.  The following URL is an
                 example only - the value can be any reachable URL.  This
                 URL will be downloaded and associated with the phone after
                 the kiosk downloads this XML document -->
            <img src="http://images.vodafone.com.au/phones/nokia_e71.png" />

            <!-- The default plan with this phone. Must reference the id
                 of a 'plan' tag -->
            <plan refid="FEDCBA9876543210" />

            <description>
                <!-- Not available at launch -->
                <blurb>A combination of excellent features and performance, matched with sleek design and an affordable price tag</blurb>

                <!-- One or more of the following 'bullet' tags.
                     Full range of values for 'type' to be confirmed.
                     Will display a generic bullet point if value for 'type' is
                     not understood. -->
                <bullet type="camera">3.2 megapixel camera with auto-focus and flash</bullet>
                <bullet type="gps">Built-in GPS receiver</bullet>
            </description>

            <features>
                <!-- boolean values -->
                <bluetooth>true</bluetooth>
                <wifi>true</wifi>
                <gps>true</gps>
                <expandable>true</expandable> <!-- corresponds to "expandable memory" -->
                <threeg>true</threeg> <!-- xml tags can't begin with digits -->
                <fmradio>true</fmradio>
                <video>true</video>
                <mp3>true</mp3>

                <!-- free text values -->
                <mobile_type>Flip|Touchscreen|Full keyboard|etc</mobile_type>
                <brand>Nokia</brand>
            </features>
        </mobile>
    </mobiles>

    <!-- plans tag contains one or more plan tags -->
    <plans>
        <!-- id value can be any number or string, as long as it is consistent
             and unique among plans -->
        <plan id="FEDCBA9876543210">

            <!-- the plan name is formed by combining a '$',
                 the monthly_spend, and the plan_type together -->
            <monthly_spend>129</monthly_spend>
            <plan_type>Cap|Prepaid|Unlimited</plan_type>

            <!-- value in dollar amount, or the word 'unlimited'
                 also known as cap inclusions -->
            <included_value>350</included_value>

            <!-- data allowance is a number in megabytes,
                 or the word 'unlimited'.

                 set this to 0 if there is no separate
                 data allowance - that is, if the data
                 is charged from the 'included value' -->
            <data_allowance>4000</data_allowance>

            <!-- taken from mockups. to be confirmed -->
            <description>
                International calls included
                Unlimited Vodafone to Vodafone
            </description>
        </plan>
    </plans>

    <!-- rates tag occurs only once -->
    <rates>
        <!-- cost in dollars per single sms sent -->
        <sms>0.28</sms>

        <!-- voice rate in dollars per minute -->
        <voice_rate>0.90</voice_rate>

        <!-- voice flagfall in dollars per call -->
        <voice_flagfall>0.35</voice_flagfall>

        <!-- assume this average call time, in mm:ss -->
        <average_call_time>2:00</average_call_time>
    </rates>

</data> ;

}
