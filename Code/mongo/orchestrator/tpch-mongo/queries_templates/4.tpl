orders
[
    {
        $match: {
            o_orderdate: {
                $gte: new Date('&1'),
                $lt: {
                    $dateAdd: {
                        startDate: ISODate('&1'),
                        unit: "month",
                        amount: 3
                    }
                }
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
]


TODO

ALTER TABLE PART ADD PRIMARY KEY (P_PARTKEY);
ALTER TABLE SUPPLIER ADD PRIMARY KEY (S_SUPPKEY);
ALTER TABLE PARTSUPP ADD PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY);
ALTER TABLE CUSTOMER ADD PRIMARY KEY (C_CUSTKEY);
ALTER TABLE ORDERS ADD PRIMARY KEY (O_ORDERKEY);
ALTER TABLE LINEITEM ADD PRIMARY KEY (L_ORDERKEY, L_LINENUMBER);
ALTER TABLE NATION ADD PRIMARY KEY (N_NATIONKEY);
ALTER TABLE REGION ADD PRIMARY KEY (R_REGIONKEY);