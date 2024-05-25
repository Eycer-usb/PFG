lineitem

[
    {
        $match: {
            l_shipdate: { $lte: new Date('1998-12-01') - (68 * 24 * 60 * 60 * 1000) }
        }
    },
    {
        $group: {
            _id: { l_returnflag: "$l_returnflag", l_linestatus: "$l_linestatus" },
            sum_qty: { $sum: "$l_quantity" },
            sum_base_price: { $sum: "$l_extendedprice" },
            sum_disc_price: { $sum: { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }] } },
            sum_charge: { $sum: { $multiply: ["$l_extendedprice", { $subtract: [1, "$l_discount"] }, { $add: [1, "$l_tax"] }] } },
            avg_qty: { $avg: "$l_quantity" },
            avg_price: { $avg: "$l_extendedprice" },
            avg_disc: { $avg: "$l_discount" },
            count_order: { $sum: 1 }
        }
    },
    {
        $sort: { "_id.l_returnflag": 1, "_id.l_linestatus": 1 }
    },
    {
        $limit: 1
    }
]