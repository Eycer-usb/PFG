lineitem
[
    {
        $group: {
            _id: "$l_orderkey",
            total_quantity: { $sum: "$l_quantity" }
        }
    },
    {
        $match: {
            total_quantity: { $gt: 314 }
        }
    },
    {
        $lookup: {
            from: "orders",
            localField: "_id",
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
            from: "lineitem",
            localField: "_id",
            foreignField: "l_orderkey",
            as: "lineitems"
        }
    },
    {
        $unwind: "$lineitems"
    },
    {
        $group: {
            _id: {
                c_name: "$customer.c_name",
                c_custkey: "$customer.c_custkey",
                o_orderkey: "$order.o_orderkey",
                o_orderdate: "$order.o_orderdate",
                o_totalprice: "$order.o_totalprice"
            },
            total_quantity: { $sum: "$lineitems.l_quantity" }
        }
    },
    {
        $sort: { "_id.o_totalprice": -1, "_id.o_orderdate": 1 }
    },
    {
        $limit: 100
    }
]