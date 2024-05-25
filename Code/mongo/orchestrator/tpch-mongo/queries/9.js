part
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
            from: "partsupp",
            localField: "lineitem.l_suppkey",
            foreignField: "ps_suppkey",
            as: "partsupp"
        }
    },
    {
        $unwind: "$partsupp"
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
        $match: {
            "p_name": { $regex: "pink", $options: "i" }
        }
    },
    {
        $project: {
            nation: "$supplier_nation.n_name",
            o_year: { $year: "$order.o_orderdate" },
            amount: {
                $subtract: [
                    { $multiply: ["$lineitem.l_extendedprice", { $subtract: [1, "$lineitem.l_discount"] }] },
                    { $multiply: ["$partsupp.ps_supplycost", "$lineitem.l_quantity"] }
                ]
            }
        }
    },
    {
        $group: {
            _id: { nation: "$nation", o_year: "$o_year" },
            sum_profit: { $sum: "$amount" }
        }
    },
    {
        $sort: {
            "_id.nation": 1,
            "_id.o_year": -1
        }
    },
    {
        $limit: 1
    }
]