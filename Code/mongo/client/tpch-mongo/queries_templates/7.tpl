{"aggregate": "supplier", "pipeline":  
[
    {
        $lookup: {
            from: "lineitem",
            localField: "s_suppkey",
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
            localField: "s_nationkey",
            foreignField: "n_nationkey",
            as: "supplier_nation"
        }
    },
    {
        $unwind: "$supplier_nation"
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
        $match: {
            $or: [
                { "supplier_nation.n_name": "&1", "customer_nation.n_name": "&2" },
                { "supplier_nation.n_name": "&2", "customer_nation.n_name": "&1" }
            ],
            "lineitem.l_shipdate": {
                $gte: ISODate("1995-01-01"),
                $lte: ISODate("1996-12-31")
            }
        }
    },
    {
        $group: {
            _id: {
                supp_nation: "$supplier_nation.n_name",
                cust_nation: "$customer_nation.n_name",
                l_year: { $year: "$lineitem.l_shipdate" }
            },
            revenue: { $sum: { $multiply: ["$lineitem.l_extendedprice", { $subtract: [1, "$lineitem.l_discount"] }] } }
        }
    },
    {
        $sort: {
            "_id.supp_nation": 1,
            "_id.cust_nation": 1,
            "_id.l_year": 1
        }
    },
    {
        $limit: 1
    }
]
}