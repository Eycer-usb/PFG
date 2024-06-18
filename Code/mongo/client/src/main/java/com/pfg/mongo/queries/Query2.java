package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query2 extends Query {
        public Query2(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Obtener la colección part
                MongoCollection<Document> partCollection = database.getCollection("part");

                // Crear la consulta de agregación
                AggregateIterable<Document> result = partCollection.aggregate(Arrays.asList(
                                new Document("$match", new Document("p_size", 12)
                                                .append("p_type", new Document("$regex", "NICKEL$"))),
                                new Document("$lookup", new Document("from", "partsupp")
                                                .append("localField", "p_partkey")
                                                .append("foreignField", "ps_partkey")
                                                .append("as", "partsuppDetails")),
                                new Document("$unwind", "$partsuppDetails"),
                                new Document("$lookup", new Document("from", "supplier")
                                                .append("localField", "partsuppDetails.ps_suppkey")
                                                .append("foreignField", "s_suppkey")
                                                .append("as", "supplierDetails")),
                                new Document("$unwind", "$supplierDetails"),
                                new Document("$lookup", new Document("from", "nation")
                                                .append("localField", "supplierDetails.s_nationkey")
                                                .append("foreignField", "n_nationkey")
                                                .append("as", "nationDetails")),
                                new Document("$unwind", "$nationDetails"),
                                new Document("$lookup", new Document("from", "region")
                                                .append("localField", "nationDetails.n_regionkey")
                                                .append("foreignField", "r_regionkey")
                                                .append("as", "regionDetails")),
                                new Document("$unwind", "$regionDetails"),
                                new Document("$match", new Document("regionDetails.r_name", "AFRICA")),
                                new Document("$group", new Document("_id", new Document("p_partkey", "$p_partkey")
                                                .append("ps_supplycost", "$partsuppDetails.ps_supplycost"))
                                                .append("min_supplycost",
                                                                new Document("$min",
                                                                                "$partsuppDetails.ps_supplycost"))),
                                new Document("$match", new Document("$expr",
                                                new Document("$eq",
                                                                Arrays.asList("$ps_supplycost", "$min_supplycost")))),
                                new Document("$project", new Document("s_acctbal", "$supplierDetails.s_acctbal")
                                                .append("s_name", "$supplierDetails.s_name")
                                                .append("n_name", "$nationDetails.n_name")
                                                .append("p_partkey", "$p_partkey")
                                                .append("p_mfgr", "$p_mfgr")
                                                .append("s_address", "$supplierDetails.s_address")
                                                .append("s_phone", "$supplierDetails.s_phone")
                                                .append("s_comment", "$supplierDetails.s_comment")),
                                new Document("$sort", new Document("s_acctbal", -1)
                                                .append("n_name", 1)
                                                .append("s_name", 1)
                                                .append("p_partkey", 1)),
                                new Document("$limit", 100)));

                // Procesar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
