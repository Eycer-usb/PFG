customer
[
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
        $match: {
            "orders.o_orderdate": {
                $gte: new Date('&1'),
                $lt: new Date('&1').addMonths(3)
            }
        }
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
            "lineitems.l_returnflag": "R"
        }
    },
    {
        $lookup: {
            from: "nation",
            localField: "c_nationkey",
            foreignField: "n_nationkey",
            as: "nation"
        }
    },
    {
        $unwind: "$nation"
    },
    {
        $group: {
            _id: {
                c_custkey: "$c_custkey",
                c_name: "$c_name",
                c_acctbal: "$c_acctbal",
                c_phone: "$c_phone",
                n_name: "$nation.n_name",
                c_address: "$c_address",
                c_comment: "$c_comment"
            },
            revenue: {
                $sum: {
                    $multiply: ["$lineitems.l_extendedprice", { $subtract: [1, "$lineitems.l_discount"] }]
                }
            }
        }
    },
    {
        $project: {
            _id: 0,
            c_custkey: "$_id.c_custkey",
            c_name: "$_id.c_name",
            revenue: 1,
            c_acctbal: "$_id.c_acctbal",
            n_name: "$_id.n_name",
            c_address: "$_id.c_address",
            c_phone: "$_id.c_phone",
            c_comment: "$_id.c_comment"
        }
    },
    {
        $sort: { revenue: -1 }
    },
    {
        $limit: 20
    }
]