orders
[
    {
        $match: {
            o_orderdate: {
                $gte: new Date('&1'),
                $lt: new Date('&1').addMonths(3)
            }
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
        $match: {
            "lineitems": {
                $elemMatch: {
                    l_commitdate: { $lt: "$lineitems.l_receiptdate" }
                }
            }
        }
    },
    {
        $group: {
            _id: "$o_orderpriority",
            order_count: { $sum: 1 }
        }
    },
    {
        $sort: {
            _id: 1
        }
    },
    {
        $limit: 1
    }
]