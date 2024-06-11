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

public class Query7 extends Query {
        public Query7(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Colecciones
                MongoCollection<Document> supplierCollection = database.getCollection("supplier");
                MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");
                MongoCollection<Document> ordersCollection = database.getCollection("orders");
                MongoCollection<Document> customerCollection = database.getCollection("customer");
                MongoCollection<Document> nationCollection = database.getCollection("nation");

                // Fecha inicial y final para el filtro de fecha
                Date startDate = new Date(1995 - 1900, 0, 1); // date '1995-01-01'
                Date endDate = new Date(1996 - 1900, 11, 31); // date '1996-12-31'

                // Construir la consulta de agregación
                AggregateIterable<Document> result = supplierCollection.aggregate(Arrays.asList(
                                Aggregates.lookup("lineitem", "s_suppkey", "l_suppkey", "lineitem_docs"),
                                Aggregates.unwind("$lineitem_docs"),
                                Aggregates.lookup("orders", "lineitem_docs.l_orderkey", "o_orderkey", "orders_docs"),
                                Aggregates.unwind("$orders_docs"),
                                Aggregates.lookup("customer", "orders_docs.o_custkey", "c_custkey", "customer_docs"),
                                Aggregates.unwind("$customer_docs"),
                                Aggregates.lookup("nation", "s_nationkey", "n_nationkey", "supp_nation_docs"),
                                Aggregates.unwind("$supp_nation_docs"),
                                Aggregates.lookup("nation", "customer_docs.c_nationkey", "n_nationkey",
                                                "cust_nation_docs"),
                                Aggregates.unwind("$cust_nation_docs"),
                                Aggregates.match(Filters.and(
                                                Filters.or(
                                                                Filters.and(
                                                                                Filters.eq("supp_nation_docs.n_name",
                                                                                                "BRAZIL"),
                                                                                Filters.eq("cust_nation_docs.n_name",
                                                                                                "MOZAMBIQUE")),
                                                                Filters.and(
                                                                                Filters.eq("supp_nation_docs.n_name",
                                                                                                "MOZAMBIQUE"),
                                                                                Filters.eq("cust_nation_docs.n_name",
                                                                                                "BRAZIL"))),
                                                Filters.gte("lineitem_docs.l_shipdate", startDate),
                                                Filters.lte("lineitem_docs.l_shipdate", endDate))),
                                Aggregates.project(Projections.fields(
                                                Projections.computed("supp_nation", "$supp_nation_docs.n_name"),
                                                Projections.computed("cust_nation", "$cust_nation_docs.n_name"),
                                                Projections.computed("l_year",
                                                                new Document("$year", "$lineitem_docs.l_shipdate")),
                                                Projections.computed("volume", new Document("$multiply", Arrays.asList(
                                                                "$lineitem_docs.l_extendedprice",
                                                                new Document("$subtract", Arrays.asList(1,
                                                                                "$lineitem_docs.l_discount"))))))),
                                Aggregates.group(
                                                new Document()
                                                                .append("supp_nation", "$supp_nation")
                                                                .append("cust_nation", "$cust_nation")
                                                                .append("l_year", "$l_year"),
                                                Accumulators.sum("revenue", "$volume")),
                                Aggregates.sort(Sorts.ascending("_id.supp_nation", "_id.cust_nation", "_id.l_year")),
                                Aggregates.limit(1)));

                // Procesar y mostrar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
