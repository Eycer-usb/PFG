package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query11 extends Query {
        public Query11(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("partsupp").aggregate(Arrays.asList(
                                new Document("$lookup", new Document("from", "supplier")
                                                .append("localField", "ps_suppkey")
                                                .append("foreignField", "s_suppkey")
                                                .append("as", "supplier")),
                                new Document("$unwind", "$supplier"),
                                new Document("$lookup", new Document("from", "nation")
                                                .append("localField", "supplier.s_nationkey")
                                                .append("foreignField", "n_nationkey")
                                                .append("as", "nation")),
                                new Document("$unwind", "$nation"),
                                new Document("$match", new Document("nation.n_name", "ARGENTINA")),
                                new Document("$group", new Document("_id", "$ps_partkey")
                                                .append("totalValue",
                                                                new Document("$sum",
                                                                                new Document("$multiply", Arrays.asList(
                                                                                                "$ps_supplycost",
                                                                                                "$ps_availqty"))))),
                                new Document("$sort", new Document("totalValue", -1)),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
