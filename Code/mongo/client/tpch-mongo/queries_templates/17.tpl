lineitem
[
    {
        $group: {
            _id: "$l_partkey",
            avg_quantity: { $avg: "$l_quantity" }
        }
    },
    {
        $project: {
            _id: 0,
            agg_partkey: "$_id",
            avg_quantity: { $multiply: ["$avg_quantity", 0.2] }
        }
    },
    {
        $lookup: {
            from: "part",
            localField: "agg_partkey",
            foreignField: "p_partkey",
            as: "part"
        }
    },
    {
        $unwind: "$part"
    },
    {
        $match: {
            "part.p_brand": "&1",
            "part.p_container": "&2"
        }
    },
    {
        $lookup: {
            from: "lineitem",
            localField: "part.p_partkey",
            foreignField: "l_partkey",
            as: "lineitem"
        }
    },
    {
        $unwind: "$lineitem"
    },
    {
        $group: {
            _id: null,
            total_price: { $sum: "$lineitem.l_extendedprice" },
            avg_quantity: { $first: "$avg_quantity" }
        }
    },
    {
        $project: {
            _id: 0,
            avg_yearly: { $divide: ["$total_price", 7.0] }
        }
    },
    {
        $limit: 1
    }
]