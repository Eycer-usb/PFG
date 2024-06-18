package com.pfg.mongo.queries;
import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

import java.util.Date;

public class Query5 extends Query {
        public Query5(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Colecciones
                MongoCollection<Document> customerCollection = database.getCollection("customer");
                MongoCollection<Document> ordersCollection = database.getCollection("orders");
                MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");
                MongoCollection<Document> supplierCollection = database.getCollection("supplier");
                MongoCollection<Document> nationCollection = database.getCollection("nation");
                MongoCollection<Document> regionCollection = database.getCollection("region");

                // Fecha inicial y final para el filtro de fecha
                Date startDate = new Date(1997 - 1900, 0, 1); // date '1997-01-01'
                Date endDate = new Date(1998 - 1900, 0, 1); // date '1997-01-01' + interval '1' year

                // Construir la consulta de agregación
                AggregateIterable<Document> result = customerCollection.aggregate(Arrays.asList(
                                Aggregates.lookup("orders", "c_custkey", "o_custkey", "orders_docs"),
                                Aggregates.unwind("$orders_docs"),
                                Aggregates.lookup("lineitem", "orders_docs.o_orderkey", "l_orderkey", "lineitem_docs"),
                                Aggregates.unwind("$lineitem_docs"),
                                Aggregates.lookup("supplier", "lineitem_docs.l_suppkey", "s_suppkey", "supplier_docs"),
                                Aggregates.unwind("$supplier_docs"),
                                Aggregates.lookup("nation", "c_nationkey", "n_nationkey", "customer_nation_docs"),
                                Aggregates.unwind("$customer_nation_docs"),
                                Aggregates.lookup("nation", "supplier_docs.s_nationkey", "n_nationkey",
                                                "supplier_nation_docs"),
                                Aggregates.unwind("$supplier_nation_docs"),
                                Aggregates.lookup("region", "customer_nation_docs.n_regionkey", "r_regionkey",
                                                "region_docs"),
                                Aggregates.unwind("$region_docs"),
                                Aggregates.match(Filters.and(
                                                Filters.eq("region_docs.r_name", "MIDDLE EAST"),
                                                Filters.gte("orders_docs.o_orderdate", startDate),
                                                Filters.lt("orders_docs.o_orderdate", endDate))),
                                Aggregates.group("$customer_nation_docs.n_name",
                                                Accumulators.sum("revenue", new Document("$multiply", Arrays.asList(
                                                                "$lineitem_docs.l_extendedprice",
                                                                new Document("$subtract", Arrays.asList(1,
                                                                                "$lineitem_docs.l_discount")))))),
                                Aggregates.project(Projections.fields(
                                                Projections.computed("n_name", "$_id"),
                                                Projections.computed("revenue", "$revenue"),
                                                Projections.excludeId())),
                                Aggregates.sort(Sorts.descending("revenue")),
                                Aggregates.limit(1)));

                // Procesar y mostrar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }

        }
}
