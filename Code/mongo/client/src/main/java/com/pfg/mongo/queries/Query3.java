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

public class Query3 extends Query {
    public Query3(String[] args) {
        super(args);
    }

    @Override
    @SuppressWarnings("deprecation")
    public void run(MongoDatabase database) {
        // Colecciones
        MongoCollection<Document> customerCollection = database.getCollection("customer");

        // Construir la consulta de agregación
        AggregateIterable<Document> result = customerCollection.aggregate(Arrays.asList(
                Aggregates.match(Filters.eq("c_mktsegment", "BUILDING")),
                Aggregates.lookup("orders", "c_custkey", "o_custkey", "orders_docs"),
                Aggregates.unwind("$orders_docs"),
                Aggregates.match(Filters.lt("orders_docs.o_orderdate", new java.util.Date(1995 - 1900, 2, 12))), // date
                                                                                                                 // '1995-03-12'
                Aggregates.lookup("lineitem", "orders_docs.o_orderkey", "l_orderkey", "lineitem_docs"),
                Aggregates.unwind("$lineitem_docs"),
                Aggregates.match(Filters.gt("lineitem_docs.l_shipdate", new java.util.Date(1995 - 1900, 2, 12))), // date
                                                                                                                  // '1995-03-12'
                Aggregates.group(new Document("l_orderkey", "$lineitem_docs.l_orderkey")
                        .append("o_orderdate", "$orders_docs.o_orderdate")
                        .append("o_shippriority", "$orders_docs.o_shippriority"),
                        Accumulators.sum("revenue",
                                new Document("$multiply", Arrays.asList("$lineitem_docs.l_extendedprice",
                                        new Document("$subtract", Arrays.asList(1, "$lineitem_docs.l_discount")))))),
                Aggregates.project(Projections.fields(
                        Projections.computed("l_orderkey", "$_id.l_orderkey"),
                        Projections.computed("revenue", "$revenue"),
                        Projections.computed("o_orderdate", "$_id.o_orderdate"),
                        Projections.computed("o_shippriority", "$_id.o_shippriority"),
                        Projections.excludeId())),
                Aggregates.sort(Sorts.orderBy(Sorts.descending("revenue"), Sorts.ascending("o_orderdate"))),
                Aggregates.limit(10)));

        // Procesar y mostrar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

    }
}
