package scratch.schema
{
public var localDataSchema:Object =
{
    name: "data",
    count: [1],
    attributes: [
    {
        name: "date"
    }],
    children: [
    {
        name: "feature_text",
        count: [0, 1],
        any_children: true
    },
    {
        name: "mobiles",
        count: [0, 1],
        children: [
        {
            name: "mobile",
            count: [0, 'inf'],
            attributes: [
            {
                name: "id",
                required: true
            }],

            children: [
            {
                name: "brand",
                count: [0, 1]
            },
            {
                name: "model",
                count: [0, 1]
            },
            {
                name: "review",
                count: [0,1]
            },
            {
                name: "img",
                count: [0, 1],
                attributes: [
                {
                    name: "src",
                    required: true
                }]
            },
            {
                name: "plans",
                count: [0, 1],
                children: [
                {
                    name: "plan",
                    count: [0, 'inf'],
                    attributes: [
                    {
                        name: "refid",
                        required: true
                    },
                    {
                        name: "default",
                        required: false
                    },
                    {
                        // i have no idea what this means or does but
                        // they put it in
                        name: "cust_contribution",
                        required: false
                    }]
                }]
            },
            {
                name: "description",
                count: [0, 1],
                children: [
                {
                    name: "bullet",
                    count: [0, 'inf'],
                    attributes: [
                    {
                        name: "type",
                        required: false
                    }]
                }]
            },
            {
                name: "features",
                count: [0, 1],
                any_children: true
            }]
        }]
    },
    {
        name: "plans",
        count: [0, 1],
        children: [
        {
            name: "plan",
            count: [0, 'inf'],
            attributes: [
            {
                name: "id",
                required: true
            }],
            children: [
                { name: "monthly_spend",   count: [0, 1] },
                { name: "category",        count: [0, 1] },
                { name: "subcategory",     count: [0, 1] },
                { name: "included_value",  count: [0, 1] },
                { name: "data_allowance",  count: [0, 1] },
                { name: "sms_rate",        count: [0, 1] },
                { name: "voice_rate",      count: [0, 1] },
                { name: "voice_flagfall",  count: [0, 1] },
                { name: "data_rate",       count: [0, 1] },
                { name: "network_credit",  count: [0, 1] },
                { name: "network_minutes", count: [0, 1] },
                { name: "voice_minutes",   count: [0, 1] },
                { name: "sms_units",       count: [0, 1] },
                { name: "term",            count: [0, 1] },
                { name: "is_prepaid",      count: [0, 1] },

                { name: "description",     count: [0, 1] }
            ]
        }]
    }]
};
}
