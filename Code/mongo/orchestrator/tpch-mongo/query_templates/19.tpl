lineitem
[
    {
        $lookup: {
            from: "part",
            localField: "l_partkey",
            foreignField: "p_partkey",
            as: "part"
        }
    },
    {
        $unwind: "$part"
    },
    {
        $match: {
            $or: [
                {
                    "part.p_brand": "&1",
                    "part.p_container": { $in: ["SM CASE", "SM BOX", "SM PACK", "SM PKG"] },
                    "l_quantity": { $gte: &4, $lte: { $add: [&4, 10] } },
                    "part.p_size": { $gte: 1, $lte: 5 },
                    "l_shipmode": { $in: ["AIR", "AIR REG"] },
                    "l_shipinstruct": "DELIVER IN PERSON"
                },
                {
                    "part.p_brand": "&2",
                    "part.p_container": { $in: ["MED BAG", "MED BOX", "MED PKG", "MED PACK"] },
                    "l_quantity": { $gte: &5, $lte: { $add: [&5, 10] } },
                    "part.p_size": { $gte: 1, $lte: 10 },
                    "l_shipmode": { $in: ["AIR", "AIR REG"] },
                    "l_shipinstruct": "DELIVER IN PERSON"
                },
                {
                    "part.p_brand": "&3",
                    "part.p_container": { $in: ["LG CASE", "LG BOX", "LG PACK", "LG PKG"] },
                    "l_quantity": { $gte: &6, $lte: { $add: [&6, 10] } },
                    "part.p_size": { $gte: 1, $lte: 15 },
                    "l_shipmode": { $in: ["AIR", "AIR REG"] },
                    "l_shipinstruct": "DELIVER IN PERSON"
                }
            ]
        }
    },
    {
        $group: {
            _id: null,
            revenue: { $sum: { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }] } }
        }
    },
    {
        $project: {
            _id: 0,
            revenue: 1
        }
    },
    {
        $limit: 1
    }
]