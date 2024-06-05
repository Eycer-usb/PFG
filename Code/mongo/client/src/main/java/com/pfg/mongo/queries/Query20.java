package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import java.util.Date;

public class Query20 extends Query {
        public Query20(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Obtener la colección supplier
                MongoCollection<Document> supplierCollection = database.getCollection("supplier");

                // Crear la consulta de agregación
                AggregateIterable<Document> result = supplierCollection.aggregate(Arrays.asList(
                                new Document("$lookup", new Document("from", "nation")
                                                .append("localField", "s_nationkey")
                                                .append("foreignField", "n_nationkey")
                                                .append("as", "nationDetails")),
                                new Document("$unwind", "$nationDetails"),
                                new Document("$match", new Document("nationDetails.n_name", "VIETNAM")),
                                new Document("$lookup", new Document("from", "partsupp")
                                                .append("localField", "s_suppkey")
                                                .append("foreignField", "ps_suppkey")
                                                .append("as", "partsuppDetails")),
                                new Document("$unwind", "$partsuppDetails"),
                                new Document("$lookup", new Document("from", "part")
                                                .append("localField", "partsuppDetails.ps_partkey")
                                                .append("foreignField", "p_partkey")
                                                .append("as", "partDetails")),
                                new Document("$unwind", "$partDetails"),
                                new Document("$match",
                                                new Document("partDetails.p_name",
                                                                new Document("$regex", "^gainsboro"))),
                                new Document("$lookup", new Document("from", "lineitem")
                                                .append("let", new Document("partkey", "$partsuppDetails.ps_partkey")
                                                                .append("suppkey", "$partsuppDetails.ps_suppkey"))
                                                .append("pipeline", Arrays.asList(
                                                                new Document("$match", new Document("$expr",
                                                                                new Document("$and", Arrays.asList(
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$l_partkey",
                                                                                                                                "$$partkey")),
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$l_suppkey",
                                                                                                                                "$$suppkey")),
                                                                                                new Document("$gte",
                                                                                                                Arrays.asList("$l_shipdate",
                                                                                                                                new Date("1996-01-01"))),
                                                                                                new Document("$lt",
                                                                                                                Arrays.asList("$l_shipdate",
                                                                                                                                new Date("1997-01-01"))))))),
                                                                new Document("$group", new Document("_id", new Document(
                                                                                "l_partkey", "$l_partkey")
                                                                                .append("l_suppkey", "$l_suppkey"))
                                                                                .append("agg_quantity", new Document(
                                                                                                "$sum",
                                                                                                "$l_quantity"))),
                                                                new Document("$project", new Document("agg_quantity",
                                                                                new Document("$multiply", Arrays.asList(
                                                                                                "$agg_quantity",
                                                                                                0.5))))))
                                                .append("as", "agg_lineitemDetails")),
                                new Document("$unwind", "$agg_lineitemDetails"),
                                new Document("$match",
                                                new Document("$expr", new Document("$gt",
                                                                Arrays.asList("$partsuppDetails.ps_availqty",
                                                                                "$agg_lineitemDetails.agg_quantity")))),
                                new Document("$project", new Document("s_name", 1).append("s_address", 1)),
                                new Document("$sort", new Document("s_name", 1)),
                                new Document("$limit", 1)));

                // Procesar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
