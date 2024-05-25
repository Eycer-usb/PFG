lineitem
[
  {
    $match: {
      l_shipdate: {
        $gte: ISODate('1997-01-01'),
        $lt: {
          $dateAdd: {
            startDate: ISODate('1997-01-01'),
            unit: "year",
            amount: 1
          }
        }
      },
      l_discount: { $gte: 0.05 - 0.01, $lte: 0.05 + 0.01 },
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