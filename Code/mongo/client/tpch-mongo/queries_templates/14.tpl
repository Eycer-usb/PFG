{"aggregate": "lineitem", "pipeline": 
[
    {
        $lookup: {
            from: "part",
            localField: "l_partkey",
            foreignField: "p_partkey",
            as: "part"
        }
    },
    {
        $unwind: "$part"
    },
    {
        $match: {
            "part.p_type": /^PROMO/,
            "l_shipdate": {
                $gte: new Date('&1'),
                $lt: new Date('&1').addMonths(1)
            }
        }
    },
    {
        $group: {
            _id: null,
            promo_revenue: {
                $sum: {
                    $cond: [
                        { $eq: [{ $substrCP: ["$part.p_type", 0, 5] }, "PROMO"] },
                        { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }] },
                        0
                    ]
                }
            },
            total_revenue: {
                $sum: { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }] }
            }
        }
    },
    {
        $project: {
            _id: 0,
            promo_revenue_percentage: { $multiply: [{ $divide: ["$promo_revenue", "$total_revenue"] }, 100] }
        }
    },
    {
        $limit: 1
    }
]
}