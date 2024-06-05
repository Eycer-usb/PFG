package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query15 extends Query {
        public Query15(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("lineitem").aggregate(Arrays.asList(
                                new Document("$match",
                                                new Document("l_shipdate", new Document("$gte", "1997-07-01T00:00:00Z")
                                                                .append("$lt", "1997-10-01T00:00:00Z"))),
                                new Document("$group", new Document("_id", "$l_suppkey")
                                                .append("total_revenue",
                                                                new Document("$sum",
                                                                                new Document("$multiply",
                                                                                                Arrays.asList("$l_extendedprice",
                                                                                                                new Document("$subtract",
                                                                                                                                Arrays.asList(1, "$l_discount"))))))),
                                new Document("$sort", new Document("total_revenue", -1)),
                                new Document("$limit", 1),
                                new Document("$lookup", new Document("from", "supplier")
                                                .append("localField", "_id")
                                                .append("foreignField", "s_suppkey")
                                                .append("as", "supplier_info")),
                                new Document("$unwind", "$supplier_info"),
                                new Document("$project", new Document("_id", 0)
                                                .append("s_suppkey", "$supplier_info.s_suppkey")
                                                .append("s_name", "$supplier_info.s_name")
                                                .append("s_address", "$supplier_info.s_address")
                                                .append("s_phone", "$supplier_info.s_phone")
                                                .append("total_revenue", "$total_revenue")),
                                new Document("$sort", new Document("s_suppkey", 1)),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
