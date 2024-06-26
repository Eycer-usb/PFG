-- Custom Indexes found in where and join clauses
CREATE INDEX IDX_LINEITEM_L_SHIPDATE ON LINEITEM (L_SHIPDATE);
CREATE INDEX IDX_LINEITEM_L_DISCOUNT ON LINEITEM (L_DISCOUNT);
CREATE INDEX IDX_LINEITEM_L_QUANTITY ON LINEITEM (L_QUANTITY);
CREATE INDEX IDX_LINEITEM_L_SHIPMODE ON LINEITEM (L_SHIPMODE);
CREATE INDEX IDX_LINEITEM_L_RETURNFLAG ON LINEITEM (L_RETURNFLAG);
CREATE INDEX IDX_LINEITEM_L_LINESTATUS ON LINEITEM (L_LINESTATUS);
CREATE INDEX IDX_LINEITEM_L_COMMITDATE ON LINEITEM (L_COMMITDATE);
CREATE INDEX IDX_LINEITEM_L_RECEIPTDATE ON LINEITEM (L_RECEIPTDATE);
CREATE INDEX IDX_LINEITEM_L_SHIPINSTRUCT ON LINEITEM (L_SHIPINSTRUCT);

CREATE INDEX IDX_PART_P_TYPE ON PART (P_TYPE);
CREATE INDEX IDX_PART_P_SIZE ON PART (P_SIZE);
CREATE INDEX IDX_PART_P_BRAND ON PART (P_BRAND);
CREATE INDEX IDX_PART_P_PARTKEY ON PART (P_PARTKEY);
CREATE INDEX IDX_PART_P_CONTAINER ON PART (P_CONTAINER);

CREATE INDEX IDX_ORDERS_O_ORDERKEY ON ORDERS (O_ORDERKEY);
CREATE INDEX IDX_ORDERS_O_ORDERDATE ON ORDERS (O_ORDERDATE);
CREATE INDEX IDX_ORDERS_O_ORDERSTATUS ON ORDERS (O_ORDERSTATUS);

CREATE INDEX IDX_SUPPLIER_S_SUPPKEY ON SUPPLIER (S_SUPPKEY);

CREATE INDEX IDX_CUSTOMER_C_CUSTKEY ON CUSTOMER (C_CUSTKEY);
CREATE INDEX IDX_CUSTOMER_C_ACCTBAL ON CUSTOMER (C_ACCTBAL);

CREATE INDEX IDX_NATION_N_NAME ON NATION (N_NAME);

CREATE INDEX IDX_REGION_R_NAME ON REGION (R_NAME);
CREATE INDEX IDX_REGION_R_REGIONKEY ON REGION (r_REGIONKEY);