{"aggregate": "customer", "pipeline": 
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
        $unwind: {
            path: "$orders",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $match: {
            $expr: {
                $and: [
                    { $eq: ["$c_custkey", "$orders.o_custkey"] },
                    { $not: { $regexMatch: { input: "$orders.o_comment", regex: /&1 &2/i } } }
                ]
            }
        }
    },
    {
        $group: {
            _id: "$c_custkey",
            c_count: { $sum: 1 }
        }
    },
    {
        $group: {
            _id: "$c_count",
            custdist: { $sum: 1 }
        }
    },
    {
        $sort: { custdist: -1, "_id": -1 }
    },
    {
        $limit: 1
    }
]
}