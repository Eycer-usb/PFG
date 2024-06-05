package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query14 extends Query {
        public Query14(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {

                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("lineitem").aggregate(Arrays.asList(
                                new Document("$match",
                                                new Document("l_shipdate", new Document("$gte", "1996-06-01T00:00:00Z")
                                                                .append("$lt", "1996-07-01T00:00:00Z"))),
                                new Document("$lookup", new Document("from", "part")
                                                .append("localField", "l_partkey")
                                                .append("foreignField", "p_partkey")
                                                .append("as", "part")),
                                new Document("$unwind", "$part"),
                                new Document("$group", new Document("_id", null)
                                                .append("promo_revenue", new Document("$sum",
                                                                new Document("$cond", Arrays.asList(
                                                                                new Document("$regexMatch",
                                                                                                new Document("input",
                                                                                                                "$part.p_type")
                                                                                                                .append("regex", "^PROMO")),
                                                                                new Document("$multiply",
                                                                                                Arrays.asList("$l_extendedprice",
                                                                                                                new Document("$subtract",
                                                                                                                                Arrays.asList(1, "$l_discount")))),
                                                                                0))))
                                                .append("total_revenue",
                                                                new Document("$sum",
                                                                                new Document("$multiply",
                                                                                                Arrays.asList("$l_extendedprice",
                                                                                                                new Document("$subtract",
                                                                                                                                Arrays.asList(1, "$l_discount"))))))),
                                new Document("$project", new Document("_id", 0)
                                                .append("promo_revenue",
                                                                new Document("$multiply",
                                                                                Arrays.asList(new Document("$divide",
                                                                                                Arrays.asList("$promo_revenue",
                                                                                                                "$total_revenue")),
                                                                                                100)))),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }

        }
}
