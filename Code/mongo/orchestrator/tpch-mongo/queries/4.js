
var end = new Date('1997-02-01')
var result = db.getCollection("orders").aggregate(
[
    {
        $match: {
            o_orderdate: {
                $gte: new Date('1996-11-01'),
                $lt: end
            }
        }
    },
    {
        $lookup: {
            from: "lineitem",
            localField: "o_orderkey",
            foreignField: "l_orderkey",
            as: "lineitems"
        }
    },
    {
        $match: {
            "lineitems": {
                $elemMatch: {
                    l_commitdate: { $lt: "$lineitems.l_receiptdate" }
                }
            }
        }
    },
    {
        $group: {
            _id: "$o_orderpriority",
            order_count: { $sum: 1 }
        }
    },
    {
        $sort: {
            _id: 1
        }
    },
    {
        $limit: 1
    }
])

print(result)