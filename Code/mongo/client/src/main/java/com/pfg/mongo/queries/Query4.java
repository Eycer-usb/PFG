package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import com.mongodb.client.model.*;

import java.util.Date;

public class Query4 extends Query {
    public Query4(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Colección
        MongoCollection<Document> ordersCollection = database.getCollection("orders");

        // Fecha inicial y final para el filtro de fecha
        @SuppressWarnings("deprecation")
        Date startDate = new Date(1994 - 1900, 10, 1); // date '1994-11-01'
        @SuppressWarnings("deprecation")
        Date endDate = new Date(1995 - 1900, 0, 1); // date '1994-11-01' + interval '3' month

        // Construir la consulta de agregación
        AggregateIterable<Document> result = ordersCollection.aggregate(Arrays.asList(
                Aggregates.match(Filters.and(
                        Filters.gte("o_orderdate", startDate),
                        Filters.lt("o_orderdate", endDate))),
                Aggregates.lookup("lineitem", "o_orderkey", "l_orderkey", "lineitems"),
                Aggregates.match(
                        Filters.expr(new Document("$gt", Arrays.asList(new Document("$size", "$lineitems"), 0)))),
                Aggregates.addFields(new Field<>("lineitems",
                        new Document("$filter", new Document("input", "$lineitems")
                                .append("as", "item")
                                .append("cond",
                                        new Document("$lt",
                                                Arrays.asList("$$item.l_commitdate", "$$item.l_receiptdate")))))),
                Aggregates.match(
                        Filters.expr(new Document("$gt", Arrays.asList(new Document("$size", "$lineitems"), 0)))),
                Aggregates.group("$o_orderpriority", Accumulators.sum("order_count", 1)),
                Aggregates.sort(Sorts.ascending("_id")),
                Aggregates.limit(1)));

        // Procesar y mostrar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

    }
}
