{"aggregate": "customer", "pipeline": 
[
  {
    $lookup: {
      from: "orders",
      localField: "c_custkey",
      foreignField: "o_custkey",
      as: "customer_orders"
    }
  },
  { $unwind: "$customer_orders" },
  {
    $lookup: {
      from: "lineitem",
      localField: "customer_orders.o_orderkey",
      foreignField: "l_orderkey",
      as: "order_lineitems"
    }
  },
  { $unwind: "$order_lineitems" },
  {
    $lookup: {
      from: "supplier",
      localField: "order_lineitems.l_suppkey",
      foreignField: "s_suppkey",
      as: "supplier_details"
    }
  },
  { $unwind: "$supplier_details" },
  {
    $lookup: {
      from: "nation",
      localField: "supplier_details.s_nationkey",
      foreignField: "n_nationkey",
      as: "supplier_nation"
    }
  },
  { $unwind: "$supplier_nation" },
  {
    $lookup: {
      from: "region",
      localField: "supplier_nation.n_regionkey",
      foreignField: "r_regionkey",
      as: "supplier_region"
    }
  },
  { $unwind: "$supplier_region" },
  {
    $addFields: {
      startDate: ISODate('&2'),
      endDate: {
        $dateFromString: {
          dateString: "&2",
          format: "%Y-%m-%d"
        }
      }
    }
  },
  {
    $set: {
      "endDate.$year": { $add: ["$endDate.$year", 1] }
    }
  },
  {
    $set: {
      endDate: {
        $dateToString: {
          format: "%Y-%m-%d",
          date: "$endDate"
        }
      }
    }
  },
  {
    $match: {
      "supplier_region.r_name": "&1",
      "customer_orders.o_orderdate": {
        $gte: "$startDate",
        $lt: { $dateFromString: { dateString: "$endDate", format: "%Y-%m-%d" } }
      }
    }
  },
  {
    $group: {
      _id: "$supplier_nation.n_name",
      revenue: {
        $sum: {
          $multiply: ["$order_lineitems.l_extendedprice", { $subtract: [1, "$order_lineitems.l_discount"] }]
        }
      }
    }
  },
  {
    $sort: { revenue: -1 }
  },
  {
    $limit: 1
  }
]
}