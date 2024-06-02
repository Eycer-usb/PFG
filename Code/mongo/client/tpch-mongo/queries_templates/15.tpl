lineitem
[
    {
        $match: {
            "l_shipdate": {
                $gte: new Date('&1'),
                $lt: new Date('&1').addMonths(3)
            }
        }
    },
    {
        $group: {
            _id: "$l_suppkey",
            total_revenue: {
                $sum: { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }] }
            }
        }
    },
    {
        $lookup: {
            from: "supplier",
            localField: "_id",
            foreignField: "s_suppkey",
            as: "supplier"
        }
    },
    {
        $unwind: "$supplier"
    },
    {
        $sort: { total_revenue: -1 }
    },
    {
        $limit: 1
    },
    {
        $project: {
            _id: 0,
            s_suppkey: "$supplier.s_suppkey",
            s_name: "$supplier.s_name",
            s_address: "$supplier.s_address",
            s_phone: "$supplier.s_phone",
            total_revenue: 1
        }
    }
]