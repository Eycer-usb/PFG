part 
[
    {
        $match: {
            p_size: &1,
            p_type: /.*&2/
        }
    },
    {
        $lookup: {
            from: "partsupp",
            localField: "p_partkey",
            foreignField: "ps_partkey",
            as: "partsupp"
        }
    },
    {
        $unwind: "$partsupp"
    },
    {
        $lookup: {
            from: "supplier",
            localField: "partsupp.ps_suppkey",
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
            as: "nation"
        }
    },
    {
        $unwind: "$nation"
    },
    {
        $lookup: {
            from: "region",
            localField: "nation.n_regionkey",
            foreignField: "r_regionkey",
            as: "region"
        }
    },
    {
        $unwind: "$region"
    },
    {
        $match: {
            "region.r_name": "&3"
        }
    },
    {
        $group: {
            _id: "$_id",
            s_acctbal: { $first: "$supplier.s_acctbal" },
            s_name: { $first: "$supplier.s_name" },
            n_name: { $first: "$nation.n_name" },
            p_partkey: { $first: "$p_partkey" },
            p_mfgr: { $first: "$p_mfgr" },
            s_address: { $first: "$supplier.s_address" },
            s_phone: { $first: "$supplier.s_phone" },
            s_comment: { $first: "$supplier.s_comment" },
            min_supplycost: { $min: "$partsupp.ps_supplycost" }
        }
    },
    {
        $match: {
            "partsupp.ps_supplycost": "$min_supplycost"
        }
    },
    {
        $sort: {
            s_acctbal: -1,
            n_name: 1,
            s_name: 1,
            p_partkey: 1
        }
    },
    {
        $limit: 100
    }
]