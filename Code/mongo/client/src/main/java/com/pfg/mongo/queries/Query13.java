package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query13 extends Query {
        public Query13(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("customer").aggregate(Arrays.asList(
                                new Document("$lookup", new Document("from", "orders")
                                                .append("localField", "c_custkey")
                                                .append("foreignField", "o_custkey")
                                                .append("as", "orders")),
                                new Document("$unwind",
                                                new Document("path", "$orders").append("preserveNullAndEmptyArrays",
                                                                true)),
                                new Document("$match", new Document("$or", Arrays.asList(
                                                new Document("orders", new Document("$exists", false)),
                                                new Document("orders.o_comment",
                                                                new Document("$not", "express.*accounts"))))),
                                new Document("$group", new Document("_id", "$c_custkey")
                                                .append("c_count", new Document("$sum",
                                                                new Document("$cond", Arrays.asList(
                                                                                new Document("$ifNull", Arrays.asList(
                                                                                                "$orders.o_orderkey",
                                                                                                false)),
                                                                                1,
                                                                                0))))),
                                new Document("$group", new Document("_id", "$c_count")
                                                .append("custdist", new Document("$sum", 1))),
                                new Document("$sort", new Document("custdist", -1).append("_id", -1)),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }

        }
}
