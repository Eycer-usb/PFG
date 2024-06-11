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

public class Query8 extends Query {
        public Query8(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Colecciones
                MongoCollection<Document> partCollection = database.getCollection("part");
                MongoCollection<Document> supplierCollection = database.getCollection("supplier");
                MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");
                MongoCollection<Document> ordersCollection = database.getCollection("orders");
                MongoCollection<Document> customerCollection = database.getCollection("customer");
                MongoCollection<Document> nationCollection = database.getCollection("nation");
                MongoCollection<Document> regionCollection = database.getCollection("region");

                // Fecha inicial y final para el filtro de fecha
                Date startDate = new Date(1995 - 1900, 0, 1); // date '1995-01-01'
                Date endDate = new Date(1996 - 1900, 11, 31); // date '1996-12-31'

                // Construir la consulta de agregación
                AggregateIterable<Document> result = partCollection.aggregate(Arrays.asList(
                                Aggregates.lookup("lineitem", "p_partkey", "l_partkey", "lineitem_docs"),
                                Aggregates.unwind("$lineitem_docs"),
                                Aggregates.lookup("supplier", "lineitem_docs.l_suppkey", "s_suppkey", "supplier_docs"),
                                Aggregates.unwind("$supplier_docs"),
                                Aggregates.lookup("orders", "lineitem_docs.l_orderkey", "o_orderkey", "orders_docs"),
                                Aggregates.unwind("$orders_docs"),
                                Aggregates.lookup("customer", "orders_docs.o_custkey", "c_custkey", "customer_docs"),
                                Aggregates.unwind("$customer_docs"),
                                Aggregates.lookup("nation", "customer_docs.c_nationkey", "n_nationkey",
                                                "customer_nation_docs"),
                                Aggregates.unwind("$customer_nation_docs"),
                                Aggregates.lookup("region", "customer_nation_docs.n_regionkey", "r_regionkey",
                                                "region_docs"),
                                Aggregates.unwind("$region_docs"),
                                Aggregates.lookup("nation", "supplier_docs.s_nationkey", "n_nationkey",
                                                "supplier_nation_docs"),
                                Aggregates.unwind("$supplier_nation_docs"),
                                Aggregates.match(Filters.and(
                                                Filters.eq("p_type", "LARGE BRUSHED BRASS"),
                                                Filters.eq("region_docs.r_name", "AFRICA"),
                                                Filters.gte("orders_docs.o_orderdate", startDate),
                                                Filters.lte("orders_docs.o_orderdate", endDate))),
                                Aggregates.project(Projections.fields(
                                                Projections.computed("o_year",
                                                                new Document("$year", "$orders_docs.o_orderdate")),
                                                Projections.computed("volume",
                                                                new Document("$multiply", Arrays.asList(
                                                                                "$lineitem_docs.l_extendedprice",
                                                                                new Document("$subtract", Arrays.asList(
                                                                                                1,
                                                                                                "$lineitem_docs.l_discount"))))),
                                                Projections.computed("nation", "$supplier_nation_docs.n_name"))),
                                Aggregates.group(
                                                "$o_year",
                                                Accumulators.sum("total_volume", "$volume"),
                                                Accumulators.sum("mozambique_volume",
                                                                new Document("$cond", Arrays.asList(
                                                                                new Document("$eq", Arrays.asList(
                                                                                                "$nation",
                                                                                                "MOZAMBIQUE")),
                                                                                "$volume",
                                                                                0)))),
                                Aggregates.project(Projections.fields(
                                                Projections.computed("o_year", "$_id"),
                                                Projections.computed("mkt_share",
                                                                new Document("$divide",
                                                                                Arrays.asList("$mozambique_volume",
                                                                                                "$total_volume"))),
                                                Projections.excludeId())),
                                Aggregates.sort(Sorts.ascending("o_year")),
                                Aggregates.limit(1)));

                // Procesar y mostrar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
