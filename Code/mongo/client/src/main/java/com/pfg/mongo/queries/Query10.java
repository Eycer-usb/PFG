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

public class Query10 extends Query {
    public Query10(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Colecciones
        MongoCollection<Document> customerCollection = database.getCollection("customer");
        MongoCollection<Document> ordersCollection = database.getCollection("orders");
        MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");
        MongoCollection<Document> nationCollection = database.getCollection("nation");

        // Construir la consulta de agregación
        AggregateIterable<Document> result = customerCollection.aggregate(Arrays.asList(
                Aggregates.lookup("orders", "c_custkey", "o_custkey", "orders_docs"),
                Aggregates.unwind("$orders_docs"),
                Aggregates.lookup("lineitem", "orders_docs.o_orderkey", "l_orderkey", "lineitem_docs"),
                Aggregates.unwind("$lineitem_docs"),
                Aggregates.lookup("nation", "c_nationkey", "n_nationkey", "nation_docs"),
                Aggregates.unwind("$nation_docs"),
                Aggregates.match(Filters.and(
                        Filters.gte("orders_docs.o_orderdate", new Document("$date", "1994-09-01T00:00:00Z")),
                        Filters.lt("orders_docs.o_orderdate", new Document("$date", "1994-12-01T00:00:00Z")),
                        Filters.eq("lineitem_docs.l_returnflag", "R"))),
                Aggregates.project(Projections.fields(
                        Projections.include("c_custkey", "c_name", "c_acctbal", "c_phone", "c_address", "c_comment"),
                        Projections.computed("n_name", "$nation_docs.n_name"),
                        Projections.computed("revenue",
                                new Document("$multiply", Arrays.asList("$lineitem_docs.l_extendedprice",
                                        new Document("$subtract", Arrays.asList(1, "$lineitem_docs.l_discount"))))))),
                Aggregates.group(
                        new Document()
                                .append("c_custkey", "$c_custkey")
                                .append("c_name", "$c_name")
                                .append("c_acctbal", "$c_acctbal")
                                .append("c_phone", "$c_phone")
                                .append("c_address", "$c_address")
                                .append("c_comment", "$c_comment")
                                .append("n_name", "$n_name"),
                        Accumulators.sum("revenue", "$revenue")),
                Aggregates.sort(Sorts.descending("revenue")),
                Aggregates.limit(20)));

        // Procesar y mostrar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }
    }
}
