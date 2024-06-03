{"aggregate": "supplier", "pipeline":  
[
    {
        $lookup: {
            from: "lineitem",
            let: { s_suppkey: "$s_suppkey" },
            pipeline: [
                {
                    $match: {
                        $expr: { $eq: ["$l_suppkey", "$$s_suppkey"] },
                        "l_receiptdate": { $gt: "$l_commitdate" }
                    }
                },
                {
                    $lookup: {
                        from: "orders",
                        localField: "l_orderkey",
                        foreignField: "o_orderkey",
                        as: "order"
                    }
                },
                {
                    $match: {
                        "order.o_orderstatus": "F"
                    }
                },
                {
                    $lookup: {
                        from: "lineitem",
                        let: { l_orderkey: "$l_orderkey", l_suppkey: "$l_suppkey" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: {
                                        $and: [
                                            { $eq: ["$l_orderkey", "$$l_orderkey"] },
                                            { $ne: ["$l_suppkey", "$$l_suppkey"] }
                                        ]
                                    }
                                }
                            }
                        ],
                        as: "related_lineitems"
                    }
                },
                {
                    $match: {
                        "related_lineitems": { $exists: true, $not: { $size: 0 } }
                    }
                },
                {
                    $lookup: {
                        from: "lineitem",
                        let: { l_orderkey: "$l_orderkey", l_suppkey: "$l_suppkey" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: {
                                        $and: [
                                            { $eq: ["$l_orderkey", "$$l_orderkey"] },
                                            { $ne: ["$l_suppkey", "$$l_suppkey"] },
                                            { $gt: ["$l_receiptdate", "$l_commitdate"] }
                                        ]
                                    }
                                }
                            }
                        ],
                        as: "late_lineitems"
                    }
                },
                {
                    $match: {
                        "late_lineitems": { $exists: false, $eq: [] }
                    }
                }
            ],
            as: "lineitems"
        }
    },
    {
        $unwind: "$lineitems"
    },
    {
        $lookup: {
            from: "nation",
            localField: "s_nationkey",
            foreignField: "n_nationkey",
            as: "nation"
        }
    },
    {
        $match: {
            "nation.n_name": "&1"
        }
    },
    {
        $group: {
            _id: "$s_name",
            numwait: { $sum: 1 }
        }
    },
    {
        $sort: { numwait: -1, _id: 1 }
    },
    {
        $limit: 100
    }
]
}