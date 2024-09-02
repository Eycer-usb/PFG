db.lineitem.aggregate([
    {
        $lookup:
        {
            from: "orders",
            localField: "l_orderkey",
            foreignField: "o_orderkey",
            as: "orderDetails"
        }
    },
    {
        $unwind: "$orderDetails"
    },
    {
        $match:
        {
            l_shipmode: {
                $in: ["REG AIR", "FOB"]
            },
            l_commitdate: {
                $lt: "$l_receiptdate"
            },
            l_shipdate: {
                $lt: "$l_commitdate"
            },
            l_receiptdate: {
                $gte: new Date("1996-01-01"),
                $lt: new Date("1997-01-01")
            }
        }
    },
    {
        $group: {
            _id: "$l_shipmode",
            high_line_count: {
                $sum: {
                    $cond: [{
                        $or: [
                            { $eq: ["$orderDetails.o_orderpriority", "1-URGENT"] },
                            { $eq: ["$orderDetails.o_orderpriority", "2-HIGH"] }]
                    }, 1, 0]
                }
            },
            low_line_count: {
                $sum: {
                    $cond: [{
                        $and: [{
                            $ne: ["$orderDetails.o_orderpriority", "1-URGENT"]
                        },
                        {
                            $ne: ["$orderDetails.o_orderpriority", "2-HIGH"]
                        }]
                    }, 1, 0]
                }
            }
        }
    },
    { $sort: { _id: 1 } },
    {
        $project: {
            _id: 0,
            l_shipmode: "$_id",
            high_line_count: 1,
            low_line_count: 1
        }
    }
]);