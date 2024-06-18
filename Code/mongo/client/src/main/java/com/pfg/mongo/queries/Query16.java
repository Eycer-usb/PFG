package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query16 extends Query {
        public Query16(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
               // Obtener la colección partsupp
        MongoCollection<Document> partsuppCollection = database.getCollection("partsupp");

        // Crear la consulta de agregación
        AggregateIterable<Document> result = partsuppCollection.aggregate(Arrays.asList(
            new Document("$lookup", new Document("from", "part")
                .append("localField", "ps_partkey")
                .append("foreignField", "p_partkey")
                .append("as", "partDetails")),
            new Document("$unwind", "$partDetails"),
            new Document("$lookup", new Document("from", "supplier")
                .append("localField", "ps_suppkey")
                .append("foreignField", "s_suppkey")
                .append("as", "supplierDetails")),
            new Document("$unwind", "$supplierDetails"),
            new Document("$match", new Document("partDetails.p_brand", new Document("$ne", "Brand#22"))
                .append("partDetails.p_type", new Document("$not", new Document("$regex", "^ECONOMY PLATED")))
                .append("partDetails.p_size", new Document("$in", Arrays.asList(21, 5, 46, 36, 30, 24, 32, 43)))
                .append("supplierDetails.s_comment", new Document("$not", new Document("$regex", "Customer.*Complaints")))),
            new Document("$group", new Document("_id", new Document("p_brand", "$partDetails.p_brand")
                .append("p_type", "$partDetails.p_type")
                .append("p_size", "$partDetails.p_size"))
                .append("supplier_cnt", new Document("$addToSet", "$ps_suppkey"))),
            new Document("$project", new Document("_id", 0)
                .append("p_brand", "$_id.p_brand")
                .append("p_type", "$_id.p_type")
                .append("p_size", "$_id.p_size")
                .append("supplier_cnt", new Document("$size", "$supplier_cnt"))),
            new Document("$sort", new Document("supplier_cnt", -1)
                .append("p_brand", 1)
                .append("p_type", 1)
                .append("p_size", 1))
        ));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }
        }
}
