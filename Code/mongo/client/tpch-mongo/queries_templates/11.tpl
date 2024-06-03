{"aggregate": "partsupp", "pipeline":  
[
    {
        $lookup: {
            from: "supplier",
            localField: "ps_suppkey",
            foreignField: "s_suppkey",
            as: "supplier"
        }
    },
    {
        $unwind: "$supplier"
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
            "supplier_nation.n_name": "&1"
        }
    },
    {
        $group: {
            _id: "$ps_partkey",
            value: { $sum: { $multiply: ["$ps_supplycost", "$ps_availqty"] } }
        }
    },
    {
        $group: {
            _id: null,
            maxValue: { $max: "$value" }
        }
    },
    {
        $lookup: {
            from: "supplier",
            let: { max_value: "$maxValue" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                { $eq: ["$s_nationkey", "$$nation_key"] },
                                { $gt: [{ $multiply: ["$ps_supplycost", "$ps_availqty"] }, { $multiply: ["$$max_value", &2] }] }
                            ]
                        }
                    }
                }
            ],
            as: "suppliers"
        }
    },
    {
        $project: {
            ps_partkey: "$_id",
            value: 1,
            hasHigherValue: { $gt: [{ $size: "$suppliers" }, 0] }
        }
    },
    {
        $match: {
            hasHigherValue: true
        }
    },
    {
        $sort: {
            value: -1
        }
    },
    {
        $limit: 1
    }
]
}