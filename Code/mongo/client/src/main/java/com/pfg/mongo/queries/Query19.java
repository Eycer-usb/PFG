package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query19 extends Query {
    public Query19(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Obtener la colección lineitem
        MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");

        // Crear la consulta de agregación
        AggregateIterable<Document> result = lineitemCollection.aggregate(Arrays.asList(
                new Document("$lookup", new Document("from", "part")
                        .append("localField", "l_partkey")
                        .append("foreignField", "p_partkey")
                        .append("as", "partDetails")),
                new Document("$unwind", "$partDetails"),
                new Document("$match", new Document("$or", Arrays.asList(
                        new Document("partDetails.p_brand", "Brand#32")
                                .append("partDetails.p_container",
                                        new Document("$in", Arrays.asList("SM CASE", "SM BOX", "SM PACK", "SM PKG")))
                                .append("l_quantity", new Document("$gte", 9).append("$lte", 19))
                                .append("partDetails.p_size", new Document("$gte", 1).append("$lte", 5))
                                .append("l_shipmode", new Document("$in", Arrays.asList("AIR", "AIR REG")))
                                .append("l_shipinstruct", "DELIVER IN PERSON"),
                        new Document("partDetails.p_brand", "Brand#45")
                                .append("partDetails.p_container",
                                        new Document("$in", Arrays.asList("MED BAG", "MED BOX", "MED PKG", "MED PACK")))
                                .append("l_quantity", new Document("$gte", 10).append("$lte", 20))
                                .append("partDetails.p_size", new Document("$gte", 1).append("$lte", 10))
                                .append("l_shipmode", new Document("$in", Arrays.asList("AIR", "AIR REG")))
                                .append("l_shipinstruct", "DELIVER IN PERSON"),
                        new Document("partDetails.p_brand", "Brand#11")
                                .append("partDetails.p_container",
                                        new Document("$in", Arrays.asList("LG CASE", "LG BOX", "LG PACK", "LG PKG")))
                                .append("l_quantity", new Document("$gte", 25).append("$lte", 35))
                                .append("partDetails.p_size", new Document("$gte", 1).append("$lte", 15))
                                .append("l_shipmode", new Document("$in", Arrays.asList("AIR", "AIR REG")))
                                .append("l_shipinstruct", "DELIVER IN PERSON")))),
                new Document("$project",
                        new Document("revenue",
                                new Document("$multiply",
                                        Arrays.asList("$l_extendedprice",
                                                new Document("$subtract", Arrays.asList(1, "$l_discount")))))),
                new Document("$group",
                        new Document("_id", null).append("totalRevenue", new Document("$sum", "$revenue"))),
                new Document("$limit", 1)));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

    }
}
