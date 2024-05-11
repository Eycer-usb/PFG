partsupp
[
    {
        $lookup: {
            from: "part",
            localField: "ps_partkey",
            foreignField: "p_partkey",
            as: "part"
        }
    },
    {
        $unwind: "$part"
    },
    {
        $match: {
            "part.p_brand": { $ne: "&1" },
            "part.p_type": { $not: /^&2/ },
            "part.p_size": { $in: [&3, &4, &5, &6, &7, &8, &9, &10] }
        }
    },
    {
        $lookup: {
            from: "supplier",
            localField: "ps_suppkey",
            foreignField: "s_suppkey",
            as: "supplier"
        }
    },
    {
        $match: {
            "supplier.s_comment": { $not: /Customer Complaints/ }
        }
    },
    {
        $group: {
            _id: {
                p_brand: "$part.p_brand",
                p_type: "$part.p_type",
                p_size: "$part.p_size"
            },
            supplier_cnt: { $addToSet: "$ps_suppkey" }
        }
    },
    {
        $project: {
            _id: 0,
            p_brand: "$_id.p_brand",
            p_type: "$_id.p_type",
            p_size: "$_id.p_size",
            supplier_cnt: { $size: "$supplier_cnt" }
        }
    },
    {
        $sort: { supplier_cnt: -1, p_brand: 1, p_type: 1, p_size: 1 }
    },
    {
        $limit: 1
    }
]