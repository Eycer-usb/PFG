{"aggregate": "customer", "pipeline": 
[
    {
        $addFields: {
            cntrycode: { $substr: ["$c_phone", 0, 2] }
        }
    },
    {
        $match: {
            cntrycode: { $in: ['&1', '&2', '&3', '&4', '&5', '&6', '&7'] },
            c_acctbal: { $gt: 0 },
            $expr: {
                $gt: [
                    "$c_acctbal",
                    {
                        $avg: {
                            $cond: [
                                { $in: ['&1', '&2', '&3', '&4', '&5', '&6', '&7'] },
                                "$c_acctbal",
                                null
                            ]
                        }
                    }
                ]
            },
            $expr: {
                $eq: [
                    {
                        $size: {
                            $filter: {
                                input: "$orders",
                                as: "order",
                                cond: { $eq: ["$$order.o_custkey", "$c_custkey"] }
                            }
                        }
                    },
                    0
                ]
            }
        }
    },
    {
        $group: {
            _id: "$cntrycode",
            numcust: { $sum: 1 },
            totacctbal: { $sum: "$c_acctbal" }
        }
    },
    {
        $sort: { _id: 1 }
    },
    {
        $limit: 1
    }
]
}