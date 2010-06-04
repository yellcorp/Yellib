package test.schema
{
public class VHADataSchema
{
    public static var schema:Object =
    {
        name: "data",
        count: [1],
        attributes: [
        {
            name: "date"
        }],
        children: [
        {
            name: "mobiles",
            count: [1],
            children: [
            {
                name: "mobile",
                count: [1, inf],
                attributes: [
                {
                    name: "id",
                    required: true
                }],
                children: [
                {
                    name: "name",
                    count: [1]
                },
                {
                    name: "review",
                    count: [1]
                },
                {
                    name: "img",
                    count: [1],
                    attributes: [
                    {
                        name: "src",
                        required: true
                    }]
                },
                {
                    name: "plan",
                    count: [0, 1],
                    attributes: [
                    {
                        name: "refid",
                        required: true
                    }]
                },
                {
                    name: "description",
                    count: [1],
                    children: [
                    {
                        name: "blurb",
                        count: [0, 1]
                    },
                    {
                        name: "bullet",
                        count: [0, inf],
                        attributes: [
                        {
                            name: "type",
                            required: false
                        }]
                    }]
                },
                {
                    name: "features",
                    count: [1],
                    children: [
                        { name: "bluetooth",   count: [0, 1] },
                        { name: "wifi",        count: [0, 1] },
                        { name: "gps",         count: [0, 1] },
                        { name: "expandable",  count: [0, 1] },
                        { name: "threeg",      count: [0, 1] },
                        { name: "fmradio",     count: [0, 1] },
                        { name: "video",       count: [0, 1] },
                        { name: "mp3",         count: [0, 1] },

                        { name: "mobile_type", count: [0, 1] },
                        { name: "brand",       count: [0, 1] }
                    ]
                }]
            }]
        },
        {
            name: "plans",
            count: [1],
            children: [
            {
                name: "plan",
                count: [1, inf],
                attributes: [
                {
                    name: "id",
                    required: true
                }],
                children: [
                {
                    name: "monthly_spend",
                    count: [1]
                },
                {
                    name: "plan_type",
                    count: [1]
                },
                {
                    name: "included_value",
                    count: [1]
                },
                {
                    name: "data_allowance",
                    count: [1]
                },
                {
                    name: "description",
                    count: [1]
                }]
            }]
        },
        {
            name: "rates",
            count: [1],
            children: [
            {
                name: "sms",
                count: [1]
            },
            {
                name: "voice_rate",
                count: [1]
            },
            {
                name: "voice_flagfall",
                count: [1]
            },
            {
                name: "average_call_time",
                count: [1]
            }]
        }]
    };

    private static function get inf():Number
    {
        return Number.POSITIVE_INFINITY;
    }
}
}
