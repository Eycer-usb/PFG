package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query16 extends Query {
        public Query16(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("partsupp").aggregate(Arrays.asList(
                                new Document("$lookup", new Document("from", "part")
                                                .append("localField", "ps_partkey")
                                                .append("foreignField", "p_partkey")
                                                .append("as", "part_info")),
                                new Document("$unwind", "$part_info"),
                                new Document("$match",
                                                new Document("part_info.p_brand", new Document("$ne", "Brand#15"))
                                                                .append("part_info.p_type", new Document("$not",
                                                                                new Document("$regex",
                                                                                                "^LARGE BURNISHED")))
                                                                .append("part_info.p_size", new Document("$in",
                                                                                Arrays.asList(29, 18, 37, 45, 13, 8, 42,
                                                                                                9)))),
                                new Document("$lookup", new Document("from", "supplier")
                                                .append("localField", "ps_suppkey")
                                                .append("foreignField", "s_suppkey")
                                                .append("as", "supplier_info")),
                                new Document("$unwind",
                                                new Document("$cond", Arrays.asList(
                                                                new Document("$regexMatch",
                                                                                new Document("input",
                                                                                                "$supplier_info.s_comment")
                                                                                                .append("regex",
                                                                                                                "Customer Complaints")),
                                                                "$$REMOVE",
                                                                "$supplier_info"))),
                                new Document("$group", new Document("_id", new Document("p_brand", "$part_info.p_brand")
                                                .append("p_type", "$part_info.p_type")
                                                .append("p_size", "$part_info.p_size"))
                                                .append("supplier_cnt", new Document("$addToSet", "$ps_suppkey"))),
                                new Document("$project", new Document("_id", 0)
                                                .append("p_brand", "$_id.p_brand")
                                                .append("p_type", "$_id.p_type")
                                                .append("p_size", "$_id.p_size")
                                                .append("supplier_cnt", new Document("$size", "$supplier_cnt"))),
                                new Document("$sort", new Document("supplier_cnt", -1)
                                                .append("p_brand", 1)
                                                .append("p_type", 1)
                                                .append("p_size", 1)),
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }

        }
}
