package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query12 extends Query {
        public Query12(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("lineitem").aggregate(Arrays.asList(
                                new Document("$match", new Document("l_shipmode",
                                                new Document("$in", Arrays.asList("MAIL", "FOB")))
                                                .append("l_commitdate", new Document("$lt", "$l_receiptdate"))
                                                .append("l_shipdate", new Document("$lt", "$l_commitdate"))
                                                .append("l_receiptdate", new Document("$gte",
                                                                new Document("$date", "1996-01-01T00:00:00Z"))
                                                                .append("$lt", new Document("$date",
                                                                                "1997-01-01T00:00:00Z")))),
                                new Document("$lookup", new Document("from", "orders")
                                                .append("localField", "l_orderkey")
                                                .append("foreignField", "o_orderkey")
                                                .append("as", "order")),
                                new Document("$unwind", "$order"),
                                new Document("$group", new Document("_id", "$l_shipmode")
                                                .append("high_line_count", new Document("$sum",
                                                                new Document("$cond", Arrays.asList(
                                                                                new Document("$or", Arrays.asList(
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$order.o_orderpriority",
                                                                                                                                "1-URGENT")),
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$order.o_orderpriority",
                                                                                                                                "2-HIGH")))),
                                                                                1,
                                                                                0))))
                                                .append("low_line_count", new Document("$sum",
                                                                new Document("$cond", Arrays.asList(
                                                                                new Document("$and", Arrays.asList(
                                                                                                new Document("$ne",
                                                                                                                Arrays.asList("$order.o_orderpriority",
                                                                                                                                "1-URGENT")),
                                                                                                new Document("$ne",
                                                                                                                Arrays.asList("$order.o_orderpriority",
                                                                                                                                "2-HIGH")))),
                                                                                1,
                                                                                0))))),
                                new Document("$sort", new Document("_id", 1)),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
