{"aggregate": "lineitem", "pipeline": 
[
  {
    $match: {
      l_shipdate: {
        $gte: ISODate('&1'),
        $lt: {
          $dateAdd: {
            startDate: ISODate('&1'),
            unit: "year",
            amount: 1
          }
        }
      },
      l_discount: { $gte: &2 - 0.01, $lte: &2 + 0.01 },
      l_quantity: { $lt: 24 }
    }
  },
  {
    $group: {
      _id: null,
      revenue: { $sum: { $multiply: ["$l_extendedprice", "$l_discount"] } }
    }
  },
  { $limit: 1 }
]
}