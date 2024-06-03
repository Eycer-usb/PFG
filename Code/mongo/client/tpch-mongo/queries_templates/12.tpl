{"aggregate": "orders", "pipeline":  
[
    {
        $match: {
            "o_orderkey": { $in: db.lineitem.distinct("l_orderkey") },
            "o_orderpriority": { $in: ["1-URGENT", "2-HIGH"] }
        }
    },
    {
        $lookup: {
            from: "lineitem",
            localField: "o_orderkey",
            foreignField: "l_orderkey",
            as: "lineitems"
        }
    },
    {
        $unwind: "$lineitems"
    },
    {
        $match: {
            "lineitems.l_shipmode": { $in: ["&1", "&2"] },
            "lineitems.l_commitdate": { $lt: "$lineitems.l_receiptdate" },
            "lineitems.l_shipdate": { $lt: "$lineitems.l_commitdate" },
            "lineitems.l_receiptdate": {
                $gte: ISODate("&3"),
                $lt: { $add: [ISODate("&3"), 365 * 24 * 60 * 60 * 1000] }
            }
        }
    },
    {
        $group: {
            _id: "$lineitems.l_shipmode",
            high_line_count: {
                $sum: {
                    $cond: [
                        {
                            $or: [
                                { $eq: ["$o_orderpriority", "1-URGENT"] },
                                { $eq: ["$o_orderpriority", "2-HIGH"] }
                            ]
                        },
                        1,
                        0
                    ]
                }
            },
            low_line_count: {
                $sum: {
                    $cond: [
                        {
                            $and: [
                                { $ne: ["$o_orderpriority", "1-URGENT"] },
                                { $ne: ["$o_orderpriority", "2-HIGH"] }
                            ]
                        },
                        1,
                        0
                    ]
                }
            }
        }
    },
    {
        $sort: {
            "_id": 1
        }
    },
    {
        $limit: 1
    }
]
}