customer
[
    {
        $match: {
            c_mktsegment: '&1'
        }
    },
    {
        $lookup: {
            from: "orders",
            localField: "c_custkey",
            foreignField: "o_custkey",
            as: "orders"
        }
    },
    {
        $unwind: "$orders"
    },
    {
        $lookup: {
            from: "lineitem",
            localField: "orders.o_orderkey",
            foreignField: "l_orderkey",
            as: "lineitems"
        }
    },
    {
        $unwind: "$lineitems"
    },
    {
        $match: {
            "orders.o_orderdate": { $lt: new Date('&2') },
            "lineitems.l_shipdate": { $gt: new Date('&2') }
        }
    },
    {
        $group: {
            _id: {
                l_orderkey: "$lineitems.l_orderkey",
                o_orderdate: "$orders.o_orderdate",
                o_shippriority: "$orders.o_shippriority"
            },
            revenue: {
                $sum: {
                    $multiply: [
                        "$lineitems.l_extendedprice",
                        { $subtract: [1, "$lineitems.l_discount"] }
                    ]
                }
            }
        }
    },
    {
        $sort: {
            revenue: -1,
            "_id.o_orderdate": 1
        }
    },
    {
        $limit: 10
    }
]