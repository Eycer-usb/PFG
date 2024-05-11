supplier
[
    {
        $lookup: {
            from: "nation",
            localField: "s_nationkey",
            foreignField: "n_nationkey",
            as: "supplier_nation"
        }
    },
    {
        $unwind: "$supplier_nation"
    },
    {
        $match: {
            "supplier_nation.n_name": "&3",
            "s_suppkey": {
                $in: db.partsupp.distinct("ps_suppkey", {
                    "ps_partkey": {
                        $in: db.part.distinct("p_partkey", { "p_name": { $regex: /^&1/i } })
                    },
                    "ps_availqty": {
                        $gt: {
                            $multiply: [
                                0.5,
                                {
                                    $sum: {
                                        $cond: [
                                            {
                                                $and: [
                                                    { $eq: ["$l_partkey", "$ps_partkey"] },
                                                    { $eq: ["$l_suppkey", "$ps_suppkey"] },
                                                    { $gte: ["$l_shipdate", ISODate("&2")] },
                                                    { $lt: ["$l_shipdate", { $add: [ISODate("&2"), 365 * 24 * 60 * 60 * 1000] }] }
                                                ]
                                            },
                                            "$l_quantity",
                                            0
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                })
            }
        }
    },
    {
        $project: {
            _id: 0,
            s_name: 1,
            s_address: 1
        }
    },
    {
        $sort: {
            s_name: 1
        }
    }
]