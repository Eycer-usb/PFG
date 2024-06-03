{"aggregate": "part", "pipeline": 
[
    {
        $lookup: {
            from: "supplier",
            localField: "p_partkey",
            foreignField: "s_suppkey",
            as: "supplier"
        }
    },
    {
        $unwind: "$supplier"
    },
    {
        $lookup: {
            from: "lineitem",
            localField: "supplier.s_suppkey",
            foreignField: "l_suppkey",
            as: "lineitem"
        }
    },
    {
        $unwind: "$lineitem"
    },
    {
        $lookup: {
            from: "orders",
            localField: "lineitem.l_orderkey",
            foreignField: "o_orderkey",
            as: "order"
        }
    },
    {
        $unwind: "$order"
    },
    {
        $lookup: {
            from: "customer",
            localField: "order.o_custkey",
            foreignField: "c_custkey",
            as: "customer"
        }
    },
    {
        $unwind: "$customer"
    },
    {
        $lookup: {
            from: "nation",
            localField: "customer.c_nationkey",
            foreignField: "n_nationkey",
            as: "customer_nation"
        }
    },
    {
        $unwind: "$customer_nation"
    },
    {
        $lookup: {
            from: "nation",
            localField: "supplier.s_nationkey",
            foreignField: "n_nationkey",
            as: "supplier_nation"
        }
    },
    {
        $unwind: "$supplier_nation"
    },
    {
        $lookup: {
            from: "region",
            localField: "customer_nation.n_regionkey",
            foreignField: "r_regionkey",
            as: "region"
        }
    },
    {
        $unwind: "$region"
    },
    {
        $match: {
            "p_type": "&3",
            "order.o_orderdate": {
                $gte: ISODate("1995-01-01"),
                $lte: ISODate("1996-12-31")
            },
            "region.r_name": "&2"
        }
    },
    {
        $project: {
            o_year: { $year: "$order.o_orderdate" },
            volume: { $multiply: ["$lineitem.l_extendedprice", { $subtract: [1, "$lineitem.l_discount"] }] },
            nation: "$customer_nation.n_name"
        }
    },
    {
        $group: {
            _id: "$o_year",
            total_volume: { $sum: "$volume" },
            ethiopia_volume: {
                $sum: {
                    $cond: [
                        { $eq: ["$nation", "&1"] },
                        "$volume",
                        0
                    ]
                }
            }
        }
    },
    {
        $project: {
            _id: 0,
            o_year: "$_id",
            mkt_share: { $divide: ["$ethiopia_volume", "$total_volume"] }
        }
    },
    {
        $sort: {
            o_year: 1
        }
    },
    {
        $limit: 1
    }
]
}